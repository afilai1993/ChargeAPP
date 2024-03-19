import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'bluetooth/bluetooth_charge_device.dart';
import 'data/device_transfer_dto.dart';

export 'data/device_transfer_dto.dart';
export 'bluetooth/bluetooth_charge_device.dart';

enum HouseholdChargeDeviceConnectState {
  idle,
  connecting,
  ensureKey,
  connected,
}

enum TriggerMessageType {
  /// 设备数据
  deviceData("DeviceData"),
  //状态记录
  synchroInfo("SynchroInfo"),
  synchroSchedule("SynchroSchedule");

  final String value;

  const TriggerMessageType(this.value);
}

class ChargeDeviceAction {
  static const handShake = "HandShake";
  static const deviceData = "DeviceData";
  static const synchroData = "SynchroData";
  static const synchroInfo = "SynchroInfo";
  static const getRecord = "GetRecord";
  static const setSchedule = "SetSchedule";
  static const cancelSchedule = "CancelSchedule";
  static const triggerMessage = "TriggerMessage";
  static const synchroStatus = "SynchroStatus";
  static const authorize = "Authorize";
  static const synchroSchedule = "SynchroSchedule";
  static const synchroScheduleFinish = "SynchroScheduleFinish";
  static const loadBalance = "LoadBalance";
  static const pnCSet = "PnCSet";
  static const instruction = "instruction";
  static const uploadRecord = "UploadRecord";
  static const uploadFinish = "UploadFinish";

  ChargeDeviceAction._();
}

class HardwareChargeDeviceManager {
  final Map<String, HardwareChargeDevice> _chargeDeviceMap = {};
  static final HardwareChargeDeviceManager instance =
      HardwareChargeDeviceManager._();

  HardwareChargeDeviceManager._();

  HardwareChargeDevice find(String mac) {
    final cache = _chargeDeviceMap[mac];
    if (cache != null) {
      return cache;
    }
    final current = BluetoothChargeDevice(BluetoothDevice.fromId(mac));
    _chargeDeviceMap[mac] = current;
    return current;
  }
}

abstract class HardwareChargeDevice {

  bool get isConnected;

  /// 连接设备
  Future connect({
    required String sn,
    required String userId,
    required String connectionKey,
  });

  ///断开设备
  Future disconnect();

  Stream<HouseholdChargeDeviceConnectState> get watchConnectState;

  Future triggerMessage(TriggerMessageType messageType);

  Future<bool> authCharge(
      {required int connectorId, required bool isCharge, required int current});

  Future<bool> setSchedule(
      {required int reservationId,
      required int connectorId,
      required List<Schedule> scheduleList,
      required bool isCancel});

  Future requestSyncRecord(
      {required String recordType, String? startTime, String? endTime,String? startAddress});

  Future reboot();

  Stream<DeviceTransferJsonBody?> get watchNotify;
}

class Schedule {
  DateTime? startDate;
  DateTime? endDate;
  Duration startTime;
  Duration endTime;
  int current;
  String? isRecurring;

  Schedule({
    this.startDate,
    this.endDate,
    required this.startTime,
    required this.endTime,
    required this.current,
    this.isRecurring,
  });
}
