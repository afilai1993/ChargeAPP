import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:chargestation/domain/device/charge_device.dart';
import 'package:chargestation/infrastructure/glogger.dart';
import 'package:chargestation/infrastructure/utils/iterables.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../../data/charge_station_dto.dart';
import '../ValueStreamProvider.dart';
import 'package:intl/intl.dart';

import '../exception.dart';

part 'bluetooth_writer.dart';

part 'bluetooth_notify.dart';

part 'bluetooth_request_manager.dart';

class BluetoothChargeDevice implements HardwareChargeDevice {
  final BluetoothDevice device;
  // static final serviceId =
  //     Guid.fromString("6e400001-b5a3-f393-e0a9-e50e24dcca9e");
  //
  // static final _writeCharacteristicId =
  //     Guid.fromString("6e400002-b5a3-f393-e0a9-e50e24dcca9e");
  //
  // static final _notifyCharacteristicId =
  //     Guid.fromString("6e400003-b5a3-f393-e0a9-e50e24dcca9e");
  static var serviceId =
  Guid.fromString("0000a002-0000-1000-8000-00805f9b34fb");

  static var _writeCharacteristicId =
  Guid.fromString("0000c303-0000-1000-8000-00805f9b34fb");

  static var _notifyCharacteristicId =
  Guid.fromString("0000c305-0000-1000-8000-00805f9b34fb");
  BluetoothWriter? _writer;
  _BluetoothNotify? _notify;
  _BluetoothRequestManager? _requestManager;
  String? sn;
  String userId='1';
  static const int _noResponseSerial = 1;
  int _serial = _noResponseSerial;
  final connectStateProvider =
      ValueStreamProvider<HouseholdChargeDeviceConnectState>(
          HouseholdChargeDeviceConnectState.idle);
  final notifyProvider = ValueStreamProvider<DeviceTransferJsonBody?>(null);
  final logger = loggerFactory.getLogger("BluetoothChargeDevice");
  StreamSubscription<BluetoothConnectionState>? _stateSubscription;
  StreamSubscription<Object?>? _receiveSubscription;

  BluetoothChargeDevice(this.device);

  void _subscribe() {
    notifyProvider.value = null;
    _stateSubscription = device.connectionState.listen((state) {
      if (state == BluetoothConnectionState.disconnected) {
        _unsubscribe();
        connectStateProvider.value = HouseholdChargeDeviceConnectState.idle;
      }
    });
    _receiveSubscription = _notify?.stream.listen((event) {
      if (event is DeviceTransferData) {
        final resumeCall = _requestManager?.resumeData(event) ?? false;
        if (resumeCall) {
          return;
        }
        try {
          final body = event.body.toJsonBody();
          final action = body.action;
          if (action == ChargeDeviceAction.synchroScheduleFinish ||
              action == ChargeDeviceAction.synchroSchedule ||
              action == ChargeDeviceAction.uploadFinish ||
              action == ChargeDeviceAction.synchroData ||
              action == ChargeDeviceAction.uploadRecord ||
              action == ChargeDeviceAction.setSchedule ||
              action == ChargeDeviceAction.deviceData ||
              action == ChargeDeviceAction.synchroInfo ||
              action == ChargeDeviceAction.synchroStatus) {
            notifyProvider.value = body;
          }
        } catch (e, st) {
          logger.error("处理接收数据有误", e, st);
        }
      }
    });
  }

  void _unsubscribe() {
    _stateSubscription?.cancel();
    _receiveSubscription?.cancel();
    _notify?.cancel();
    _notify = null;
    _writer = null;
    _requestManager = null;
    sn = null;
    userId = "0";
  }

  void setBleUUID(String sn)
  {
    if(sn.contains("A23-"))
      {
        BluetoothChargeDevice.serviceId = Guid.fromString("6e400001-b5a3-f393-e0a9-e50e24dcca9e");
        BluetoothChargeDevice._writeCharacteristicId = Guid.fromString("6e400002-b5a3-f393-e0a9-e50e24dcca9e");
        BluetoothChargeDevice._notifyCharacteristicId = Guid.fromString("6e400003-b5a3-f393-e0a9-e50e24dcca9e");
      }
    else
      {
        BluetoothChargeDevice.serviceId = Guid.fromString("0000a002-0000-1000-8000-00805f9b34fb");
        BluetoothChargeDevice._writeCharacteristicId = Guid.fromString("0000c303-0000-1000-8000-00805f9b34fb");
        BluetoothChargeDevice._notifyCharacteristicId = Guid.fromString("0000c305-0000-1000-8000-00805f9b34fb");
      }

  }

  @override
  Future connect(
      {required String sn,
      required String userId,
      required String connectionKey}) async {
    setBleUUID(sn);
    if (connectStateProvider.value != HouseholdChargeDeviceConnectState.idle) {
      return;
    }
    connectStateProvider.value = HouseholdChargeDeviceConnectState.connecting;
    final currentAdapterState = await FlutterBluePlus.adapterState
        .firstWhere((element) => element != BluetoothAdapterState.unknown);
    if (currentAdapterState != BluetoothAdapterState.on) {
      connectStateProvider.value = HouseholdChargeDeviceConnectState.idle;
      throw DeviceConnectException(ConnectErrorType.bluetoothOff,
          e: "蓝牙未打开$currentAdapterState");
    }
    try {
      await device.connect(timeout: const Duration(seconds: 20));
    } catch (e) {
      connectStateProvider.value = HouseholdChargeDeviceConnectState.idle;
      throw DeviceConnectException(ConnectErrorType.unknown, e: e);
    }
    connectStateProvider.value = HouseholdChargeDeviceConnectState.ensureKey;
    BluetoothWriter? writer;
    _BluetoothNotify? notify;

    try {
      final services = await device.discoverServices();
      final service =
          services.find((element) => element.serviceUuid == serviceId);
      if (service == null) {
        throw const DeviceConnectException(ConnectErrorType.notFoundService);
      }
      final writeCharacteristic = service.characteristics.find(
          (element) => element.characteristicUuid == _writeCharacteristicId);

      if (writeCharacteristic == null) {
        throw const DeviceConnectException(
            ConnectErrorType.notFoundWriteCharacteristic);
      }
      final notifyCharacteristic = service.characteristics.find(
          (element) => element.characteristicUuid == _notifyCharacteristicId);
      if (notifyCharacteristic == null) {
        throw const DeviceConnectException(
            ConnectErrorType.notFoundNotifyCharacteristic);
      }
      if (Platform.isAndroid) {
        await device.requestMtu(512);
      }
      notify = await _BluetoothNotify.create(notifyCharacteristic);
      writer = BluetoothWriter(writeCharacteristic);
      await _matchKey(
          writer: writer,
          notify: notify,
          sn: sn,
          userId: userId,
          connectionKey: connectionKey);
      _writer = writer;
      _notify = notify;
      this.sn = sn;
      this.userId = userId;
      _requestManager = _BluetoothRequestManager(writer);
      connectStateProvider.value = HouseholdChargeDeviceConnectState.connected;
      _subscribe();
    } catch (e) {
      device.disconnect().catchError((e) {});
      notify?.cancel();
      connectStateProvider.value = HouseholdChargeDeviceConnectState.idle;
      rethrow;
    }
  }

  Future _matchKey(
      {required BluetoothWriter writer,
      required _BluetoothNotify notify,
      required String sn,
      required String userId,
      required String connectionKey}) async {
    final completer = Completer();
    final serial = ++_serial;
    StreamSubscription? subscription;
    final timer = Timer(const Duration(seconds: 10), () {
      if (!completer.isCompleted) {
        completer.completeError(const DeviceRequestTimeoutException());
        subscription?.cancel();
      }
    });

    subscription = notify.stream.listen((event) {
      if (event is DeviceTransferData) {
        if (event.unique.serial == serial) {
          try {
            final body = event.body.toJsonBody();
            final result = body.payload?["result"] ?? false;
            if (!completer.isCompleted) {
              if (result) {
                completer.complete();
              } else {
                completer.completeError(const DeviceMatchException());
              }
            }
            timer.cancel();
            subscription?.cancel();
          } catch (e) {
            //ignore
          }
        }
      }
    });

    writer
        .writeRequest(_BluetoothRequest(
            unique: DeviceTransferUnique(
              serial: serial,
            ),
            action: ChargeDeviceAction.handShake,
            payload: {
              "userId": "1",
              "chargeBoxSN": sn,
              "currentTime":
              DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now()),
              "connectionKey": connectionKey
        }))
        .catchError((e) {
      if (!completer.isCompleted) {
        completer.completeError(e);
      }
      BluetoothWriter.startHeartBeartEn=0;
      timer.cancel();
      subscription?.cancel();
    });
    BluetoothWriter.startHeartBeartEn=0;
    return completer.future;
  }

  @override
  Stream<HouseholdChargeDeviceConnectState> get watchConnectState =>
      connectStateProvider.stream;




  @override
  Future triggerMessage(TriggerMessageType messageType) async {
    return _requiredWriter().writeRequest(_BluetoothRequest(
        unique: DeviceTransferUnique(
          serial: ++_serial,
        ),
        action: ChargeDeviceAction.triggerMessage,
        payload: {
          "chargeBoxSN": sn,
          "userId": "1",
          "requestedMessage": messageType.value,
        }));
  }

  BluetoothWriter _requiredWriter() {
    final current = _writer;
    if (current != null) {
      return current;
    }
    throw const DeviceUnconnectedException();
  }

  _BluetoothRequestManager _getRequestManager() {
    final current = _requestManager;
    if (current != null) {
      return current;
    }
    throw const DeviceUnconnectedException();
  }

  @override
  Stream<DeviceTransferJsonBody?> get watchNotify => notifyProvider.stream;

  @override
  Future disconnect() async {
    await device.disconnect();
    _unsubscribe();
  }

  @override
  Future<bool> authCharge(
      {required int connectorId,
      required bool isCharge,
      required int current}) async {
    // String chargeBoxSN = "2100102310200220";
    // String uid="123456";
    // String startOrStop=isCharge?"Start":"Stop";
    // String body = '{"messageTypeId":"5","uniqueId":"$uid","action":"Authorize","payload":{"userId":"1","chargeBoxSN":"$chargeBoxSN","purpose":"$startOrStop","current":32,"connectorId":1}}';
    // // print(body);
    // _writer?.sendMessage(body);

    // await _BluetoothWriter.sendMessage(body);
    return _getRequestManager()
        .request(_BluetoothRequest(
            unique: DeviceTransferUnique(
              serial: ++_serial,
            ),
            action: ChargeDeviceAction.authorize,
            payload: {
          "chargeBoxSN": sn,
          "userId": "1",
          "connectorId": connectorId,
          "current": current,
          "purpose": isCharge ? "Start" : "Stop"
        }))
        .then((value) {
      final json = value.body.toJsonBody();
      return json.payload["result"] ?? false;
    });
  }

  @override
  Future<bool> setSchedule(
      {required int reservationId,
      required int connectorId,
      required List<Schedule> scheduleList,
      required bool isCancel}) {
    final dateFormat = DateFormat("yyyy-MM-dd");
    String formatTime(Duration duration) {
      return "${(duration.inHours % 24).toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
    }

    String formatRecurring(String? isRecurring) {
      if (isRecurring == null || isRecurring.isEmpty) {
        return "-";
      } else if (isRecurring == "1,2,3,4,5,6,7") {
        return "8";
      } else {
        return isRecurring;
      }
    }

    return _getRequestManager()
        .request(_BluetoothRequest(
            unique: DeviceTransferUnique(
              serial: ++_serial,
            ),
            action: isCancel
                ? ChargeDeviceAction.cancelSchedule
                : ChargeDeviceAction.setSchedule,
            payload: {
          "chargeBoxSN": sn,
              "userId": "1",
          "reservationId": reservationId,
          "connectorId": connectorId,
          "schedule": scheduleList.map((e) {
            return {
              "startDate":
                  e.startDate == null ? "-" : dateFormat.format(e.startDate!),
              "endDate":
                  e.endDate == null ? "-" : dateFormat.format(e.endDate!),
              "startTime": formatTime(e.startTime),
              "endTime": formatTime(e.endTime),
              "current": e.current,
              "isRecurring": formatRecurring(e.isRecurring),
            };
          }).toList()
        }))
        .then((value) {
      final json = value.body.toJsonBody();
      return json.payload["result"] ?? false;
    });
  }

  @override
  Future requestSyncRecord(
      {required String recordType,
      String? startTime,
      String? endTime,
      String? startAddress}) {
    return _requiredWriter().writeRequest(_BluetoothRequest(
        unique: DeviceTransferUnique(
          serial: ++_serial,
        ),
        action: ChargeDeviceAction.getRecord,
        payload: {
          "chargeBoxSN": sn,
          "userId": "1",
          "recordType": recordType,
          // "startAddress": startAddress,
          if (startTime != null) "startTime": startTime,
          if (endTime != null) "endTime": endTime
        }));
  }

  @override
  Future reboot() {
    return _requiredWriter().writeRequest(_BluetoothRequest(
        unique: DeviceTransferUnique(
          serial: ++_serial,
        ),
        action: ChargeDeviceAction.instruction,
        payload: {
          "chargeBoxSN": sn,
          "userId": userId,
          "command": "Reboot",
        }));
  }

  @override
  bool get isConnected =>
      connectStateProvider.value == HouseholdChargeDeviceConnectState.connected;
}
