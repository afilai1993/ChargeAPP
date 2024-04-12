part of '../household_device_case.dart';

class _WrapperBluetoothDevice {
  final String address;
  List<DeviceTransferJsonBody> bodyList = [];
  Future? _handleBodyFuture;
  final synchroStatusProvider =
      ValueStreamProvider<GPChargeSynchroStatus?>(null);
  int? id;
  final syncInfoProvider = ValueStreamProvider<GPChargeSynchroInfo?>(null);
  final synchroDataProvider = ValueStreamProvider<GPChargeSynchroData?>(null);
  // final dateFormatTimeZone = DateFormat(
  //   "yyyy-MM-dd'T'HH:mm:ss'Z'",
  // );
  final dateFormatTimeZone = DateFormat(
    "yyyy-MM-dd",
  );
  late final _DeviceScheduleTask syncScheduleTask;
  BluetoothDiagnosisReader? _diagnosisReader;
  DateTime? _lastSyncRecordTime;
  late final logger =
      loggerFactory.getLogger("_WrapperBluetoothDevice[$address]");

  _WrapperBluetoothDevice(this.address) {
    syncScheduleTask = _DeviceScheduleTask(address);
    bind();
  }

  void bind() {
    final device = HardwareChargeDeviceManager.instance.find(address);
    device.watchConnectState.listen((event) {
      if (event == HouseholdChargeDeviceConnectState.idle) {
        synchroStatusProvider.value = null;
        syncInfoProvider.value = null;
        synchroDataProvider.value = null;
      }
    });
    device.watchNotify.listen((event) {
      if (event == null) {
        return;
      }
      bodyList.add(event);
      handleBody();
    });
  }

  void handleBody() {
    _handleBodyFuture ??= Future(() async {
      final consumer = _DeviceDataConsumer(this);
      do {
        final list = List.of(bodyList);
        bodyList.clear();
        DeviceTransferJsonBody item;

        for (var index = list.length - 1; index >= 0; index--) {
          item = list[index];
          try {
            if (item.action == ChargeDeviceAction.synchroSchedule) {
              await syncScheduleTask.onReceive(item);
            } else if (item.action ==
                ChargeDeviceAction.synchroScheduleFinish) {
              await syncScheduleTask.onFinish();
            } else {
              await consumer.consume(item);
            }
          } catch (e, st) {
            loggerFactory.getLogger("_WrapperBluetoothDevice").error(e, st);
          }
        }
        consumer.clear();
        await Future.delayed(const Duration(milliseconds: 500));
      } while (bodyList.isNotEmpty);
      _handleBodyFuture = null;
    });
  }

  void startSync(int deviceId) async {
    try {
      id = deviceId;
      final device = HardwareChargeDeviceManager.instance.find(address);
      final devicePO = await UserDatabase.instance.chargeDeviceDao
          .findDeviceByAddress(address);
      if (devicePO == null) {
        return;
      }
      await device.triggerMessage(TriggerMessageType.synchroInfo);
      // sleep(const Duration(milliseconds: 1000));
      await device.triggerMessage(TriggerMessageType.deviceData);
      sleep(const Duration(milliseconds: 1000));
      if (_lastSyncRecordTime == null ||
          DateTime.now().millisecondsSinceEpoch -
                  _lastSyncRecordTime!.millisecondsSinceEpoch >
              30 * 1000) {
        await _startRecordSync(deviceId);
      }
      await syncScheduleTask.startSync(device, devicePO);

      ///触发充电
    } catch (e) {
      //ignore
    }
  }

  Future readDiagnosis(File eepromFile) {
    final task = BluetoothDiagnosisReader(
        eepromFile, HardwareChargeDeviceManager.instance.find(address));
    _diagnosisReader = task;
    return task.execute();
  }

  void maybeSyncRecordFinish() {
    logger.debug("同步记录结束");
    _lastSyncRecordTime = null;
  }

  Future requestRecordSync() async {
    final device = HardwareChargeDeviceManager.instance.find(address);
    if (!device.isConnected) {
      logger.debug("设备未连接");
      return;
    }
    if (_lastSyncRecordTime != null) {
      final now = DateTime.now();
      if (now.millisecondsSinceEpoch -
              _lastSyncRecordTime!.millisecondsSinceEpoch <=
          30 * 1000) {
        logger.debug("还未过30s");
        return;
      }
    }
    final devicePO = await UserDatabase.instance.chargeDeviceDao
        .findDeviceByAddress(address);
    if (devicePO == null) {
      logger.debug("设备不存在");
      return;
    }
    await _startRecordSync(devicePO.id!);
    return Future.delayed(const Duration(seconds: 5));
  }

  Future _startRecordSync(int deviceId) async {
    logger.debug("触发同步记录");
    _lastSyncRecordTime = DateTime.now();
    final int startDate;
    final currentEndTime = await UserDatabase.instance.chargeRecordDao
        .getRecentlyEndTime(deviceId);
    if (currentEndTime != null) {
      startDate = currentEndTime;
    } else {
      final currentStartTime = await UserDatabase.instance.chargeRecordDao
          .getRecentlyStartTime(deviceId);
      if (currentStartTime != null) {
        startDate = currentStartTime;
      } else {
        startDate = DateTime(2024, 1, 1).millisecondsSinceEpoch;
      }
    }
    final syncStartDate = dateFormatTimeZone
        .format(DateTime.fromMillisecondsSinceEpoch(startDate));
    final syncEndDate =
        dateFormatTimeZone.format(DateTime.now().add(const Duration(days: 1)));

    //print("同步范围: ${syncStartDate}-${syncEndDate}");

    await HardwareChargeDeviceManager.instance.find(address).requestSyncRecord(
        recordType: "charge", startTime: syncStartDate, endTime: syncEndDate);
  }
}
class StartHeartBeat{
  late ReceivePort portHeartBeat1;
  void receivePortAction(ReceivePort portHeartBeat)
  {
    portHeartBeat1=portHeartBeat;
}
}
class _DeviceScheduleTask {
  final String address;
  int currentVersion = 0;
  ChargeDevicePO? devicePO;
  final dateFormat = DateFormat("yyyy-MM-dd");
  final _logger = loggerFactory.getLogger("BluetoothWriter");
  _DeviceScheduleTask(this.address);

  Future startSync(HardwareChargeDevice device, ChargeDevicePO devicePO) async {
    this.devicePO = devicePO;
    currentVersion =
        (await UserDatabase.instance.chargeTimerDao.getMaxVersion(address) ??
                0) +
            1;
    sleep(const Duration(milliseconds: 1000));
    // await device.triggerMessage(TriggerMessageType.synchroSchedule);
    // sleep(const Duration(milliseconds: 1000));
    // 定时任务
    Timer(const Duration(seconds: 3), () {
      try {
        BluetoothWriter.startHeartBeartEn=1;

        // final data = DeviceTransferData.parse(BluetoothWriter.startSynchroStatus);
        // _logger.debug("重新加载连接时收的SynchroStatus:$data");
      } catch (e, st) {
        // _logger.warn("重新加载连接时收的SynchroStatus解析失败;${BluetoothWriter.startSynchroStatus.toString()}", e, st);
      }
      BluetoothWriter.startSynchroStatus=[];
      // _logger.debug('开启心跳包');
      // int serialHeartBeat=10;
      // String  uid = (serialHeartBeat & 0x000000ffffff).toString();
      //           String  chargeBoxSN = "2100102310200220";
      // String  message = '{"messageTypeId":"6","uniqueId":"$uid","payload":{"chargeBoxSN":"$chargeBoxSN"}}';
      // BluetoothWriter.sendMessageStatic(message);
      //             // body = '{"messageTypeId":"6","uniqueId":"$uid","payload":{"chargeBoxSN":"$chargeBoxSN"}}';
      //             _logger.debug("定时任务执行中");
      //             _logger.debug("定时发送数据给充电桩:$message#");
    });

  }

  Future onReceive(DeviceTransferJsonBody data) async {
    final scheduleList = data.payload["schedule"] as List<dynamic>?;
    if (scheduleList == null) {
      return;
    }
    final currentDevice = devicePO;
    if (currentDevice == null) {
      return;
    }
    for (var schedule in scheduleList) {
      final task = ChargeTimeTaskPO()
        ..taskName = "任务"
        ..deviceId = currentDevice.id!
        ..deviceAddress = currentDevice.address
        ..startDate = parseDate(schedule["startDate"])
        ..endDate = parseDate(schedule["endDate"])
        ..deviceName = currentDevice.name
        ..startTime = parseTime(schedule["startTime"])
        ..endTime = parseTime(schedule["endTime"])
        ..current = schedule["current"]
        ..loop = parseLoop(schedule["isRecurring"])
        ..open = 1
        ..version = currentVersion
        ..updateUnique();
      final exist = await UserDatabase.instance.chargeTimerDao
          .getTimeTask(address, task.uniqueNo);
      if (exist != null) {
        UserDatabase.instance.chargeTimerDao.updateTimer(exist
          ..open = 1
          ..version = currentVersion);
      } else {
        UserDatabase.instance.chargeTimerDao.insertTimer(task);
      }
    }
  }

  int parseDate(String? date) {
    if (date == null || date.isEmpty || date == '-') {
      return -1;
    }
    return dateFormat.parse(date).millisecondsSinceEpoch;
  }

  int parseTime(String time) {
    final array = time.split(":").map((e) => int.parse(e)).toList();
    return array[0] * 60 * 60 + array[1] * 60 + array[2];
  }

  String parseLoop(String? loop) {
    if (loop == null || loop.isEmpty || loop == '-') {
      return "";
    } else {
      return loop.characters.join(",");
    }
  }

  Future onFinish() async {
    await UserDatabase.instance.chargeTimerDao
        .closeLowVersion(address, currentVersion);
  }
}

class _DeviceDataConsumer {
  GPChargeDeviceData? lastDeviceData;
  GPChargeSynchroStatus? lastSynchroStatus;
  GPChargeSynchroInfo? lastChargeSynchroInfo;
  GPChargeSynchroData? lastChargeSynchroData;
  final _WrapperBluetoothDevice device;

  _DeviceDataConsumer(this.device);

  Future consume(DeviceTransferJsonBody item) async {
    if (item.action == ChargeDeviceAction.deviceData) {
      await consumeDeviceData(item);
    } else if (item.action == ChargeDeviceAction.synchroInfo) {
      consumeSynchroStatusInfo(item);
    } else if (item.action == ChargeDeviceAction.synchroStatus) {
      consumeSynchroStatus(item);
    } else if (item.action == ChargeDeviceAction.synchroData) {
      consumeChargeSynchroData(item);
    } else if (item.action == ChargeDeviceAction.uploadRecord) {
      await consumeUploadRecord(item);
    } else if (item.action == ChargeDeviceAction.uploadFinish) {
      device._diagnosisReader?.finish();
      device.maybeSyncRecordFinish();
    }
  }

  void clear() {
    lastDeviceData = null;
    lastSynchroStatus = null;
    lastChargeSynchroInfo = null;
    lastChargeSynchroData = null;
  }

  Future consumeDeviceData(DeviceTransferJsonBody data) async {
    if (lastDeviceData != null) {
      return;
    }
    final deviceData = GPChargeDeviceData.fromJson(data.payload);
    lastDeviceData = deviceData;
    final device = await UserDatabase.instance.chargeDeviceDao
        .findDeviceByAddress(address);
    if (device == null) {
      return;
    }
    await UserDatabase.instance.chargeDeviceDao.update(device
      ..sVersion = deviceData.sVersion ?? ""
      ..hVersion = deviceData.hVersion ?? ""
      ..cumulativeTime = deviceData.cumulativeTime ?? 0
      ..totalPower = deviceData.totalPower ?? 0
      ..chargeTimes = deviceData.chargeTimes ?? 0);

    final gunData = deviceData.connectorMain;
    if (gunData != null) {
      ChargeDeviceGunPO? gun =
          await UserDatabase.instance.chargeDeviceGunDao.getGun(address, 1);

      gun ??= ChargeDeviceGunPO(
          deviceId: device.id!, deviceAddress: device.address);
      gun = gun.copyWith(
        miniCurrent: gunData.miniCurrent ?? 20,
        maxCurrent: gunData.maxCurrent ?? 30,
        pncStatus: gunData.pncStatus ?? 4,
      );
      if (gun.id == null) {
        await UserDatabase.instance.chargeDeviceGunDao.insertGun(gun);
      } else {
        await UserDatabase.instance.chargeDeviceGunDao.updateGun(gun);
      }
    }
  }

  void consumeSynchroStatus(DeviceTransferJsonBody data) async {
    if (lastSynchroStatus != null) {
      return;
    }
    lastSynchroStatus = GPChargeSynchroStatus.fromJson(data.payload);
    synchroStatusProvider.value = lastSynchroStatus;
    final statusCode = lastSynchroStatus?.connectorMain?.statusCode;
    if (statusCode != null && statusCode != 0) {
      Future(() async {
        final recently = await UserDatabase.instance.chargeWarningReminderDao
            .findRecently(address);
        final now = DateTime.now().millisecondsSinceEpoch;
        if (recently != null &&
            recently.statusCode == statusCode &&
            now - recently.time < 60 * 60 * 1000) {
          return;
        }
        UserDatabase.instance.chargeWarningReminderDao
            .insertReminder(ChargeWarningReminderPO()
              ..deviceId = id ?? 0
              ..deviceAddress = address
              ..statusCode = statusCode
              ..time = now);
      });
    }
  }

  void consumeSynchroStatusInfo(DeviceTransferJsonBody data) async {
    if (lastChargeSynchroInfo != null) {
      return;
    }
    consumeSynchroStatus(data);
    lastChargeSynchroInfo = GPChargeSynchroInfo.fromJson(data.payload);
    syncInfoProvider.value = lastChargeSynchroInfo;
  }

  void consumeChargeSynchroData(DeviceTransferJsonBody data) {
    if (lastChargeSynchroData != null) {
      return;
    }
    lastChargeSynchroData = GPChargeSynchroData.fromJson(data.payload);
    synchroDataProvider.value = lastChargeSynchroData;
  }

  Future consumeChargeRecord(dynamic result) async {
    final id = this.id;
    if (id == null) {
      return;
    }
    final detail = result["recordDetails"];
    if (detail == null) {
      return;
    }

    int startTime=0;
    int endTime=0;


    final dateTimeFormat = DateFormat(
      "yyyy-MM-dd'T'HH:mm:ssZ",
    );
    startTime = dateTimeFormat.parse(detail["startTime"]).millisecondsSinceEpoch;
    endTime = dateTimeFormat.parse(detail["endTime"]).millisecondsSinceEpoch;


    if (startTime > endTime) {
      //有问题的数据，不导入
      return;
    }
    final exist = await UserDatabase.instance.chargeRecordDao
        .existChargeRecord(id, startTime, endTime);
    if (exist) {
      return;
    }
    await  UserDatabase.instance.chargeRecordDao
        .insertChargeRecord(ChargeRecordPO()
          ..deviceId = id
          ..deviceAddress = address
          ..connectorId = detail["connectorId"]
          ..startTime = startTime
          ..endTime = endTime
          ..energy = double.parse(detail["energy"])
          ..prices = detail["prices"]
          ..stopReason = detail["stopReason"] ?? "");
  }

  Future consumeUploadRecord(DeviceTransferJsonBody data) async {
    final result = data.payload;
    final recordType = result["recordType"];
    if (recordType == "Charge") {
      return consumeChargeRecord(result);
    } else if (recordType == "Diagnosis") {
      device._diagnosisReader?.onReceive(data);
    }
  }

  int? get id => device.id;

  String get address => device.address;

  ValueStreamProvider<GPChargeSynchroStatus?> get synchroStatusProvider =>
      device.synchroStatusProvider;

  ValueStreamProvider<GPChargeSynchroInfo?> get syncInfoProvider =>
      device.syncInfoProvider;

  ValueStreamProvider<GPChargeSynchroData?> get synchroDataProvider =>
      device.synchroDataProvider;

  DateFormat get dateFormatTimeZone => device.dateFormatTimeZone;
}
