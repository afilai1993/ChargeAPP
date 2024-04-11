part of '../household_device_case.dart';

class _HouseholdDeviceCaseImpl implements HouseholdDeviceCase {
  final Map<String, _WrapperBluetoothDevice> _deviceMap = {};

  @override
  Future saveDevice(
      {required String address,
      required String sn,
      required String name,
      required String key}) async {
    BluetoothChargeDevice.setBleUUID(sn);
    final device = HardwareChargeDeviceManager.instance.find(address);
    final userId = await userStore.asyncGetValue<String>("userId") ?? "";
    await device.connect(sn: sn, userId: userId, connectionKey: key);
    final ChargeDevicePO devicePO;
    final existDevice = await UserDatabase.instance.chargeDeviceDao
        .findDeviceByAddress(address);
    if (existDevice == null) {
      devicePO = ChargeDevicePO();
      final id = await UserDatabase.instance.chargeDeviceDao.insert(devicePO
        ..name = name
        ..sn = sn
        ..address = address);
      devicePO.id = id;
    } else {
      devicePO = existDevice;
    }
    await UserDatabase.instance.userBindChargeDeviceDao
        .insert(UserBindChargeDevicePO()
          ..sn = sn
          ..userId = userId
          ..deviceId = devicePO.id!
          ..deviceAddress = address
          ..key = key);
    serviceEventBus.post(HardwareChargeEvent(
        operateType: DataOperateType.insert, chargePO: existDevice));
    getDevice(devicePO.address).startSync(devicePO.id!);
  }

  @override
  Stream<List<HouseholdDeviceItemVO>> watchDeviceList(DeviceType deviceType) =>
      createDataStream(
          key: BeanMethodFetchKey(
              beanType: _HouseholdDeviceCaseImpl,
              methodType: watchDeviceList.runtimeType,
              arguments: deviceType),
          where: (event) {
            if (event is HardwareChargeEvent) {
              final data = event.chargePO;
              return data == null || data.deviceType == deviceType;
            }
            return event is RefreshAllDataChangedEvent;
          },
          fetchData: () async => UserDatabase.instance.chargeDeviceDao
              .findDeviceList(
                  await userStore.asyncGetValue<String>("userId") ?? "",
                  deviceType)
              .then((value) => value
                  .map((item) => HouseholdDeviceItemVO(
                      id: item.id,
                      name: item.name,
                      address: item.address,
                      deviceType: item.deviceType))
                  .toList()));

  @override
  Stream<HouseholdChargeDeviceConnectState> watchConnectState(String address) =>
      HardwareChargeDeviceManager.instance.find(address).watchConnectState;

  @override
  Future requestConnect(String address) async {
    final bind = await UserDatabase.instance.userBindChargeDeviceDao
        .findByAddress(
            await userStore.asyncGetValue<String>("userId") ?? "", address);
    if (bind == null) {
      throw DomainException(S.current.msg_error_device_not_found);
    }
    await HardwareChargeDeviceManager.instance
        .find(bind.deviceAddress)
        .connect(sn: bind.sn, userId: bind.userId, connectionKey: bind.key);
    getDevice(bind.deviceAddress).startSync(bind.deviceId);
  }

  @override
  Future<bool> requestCharge(String address, bool isCharge) async {
    final gun =
        await UserDatabase.instance.chargeDeviceGunDao.getGun(address, 1);
    if (gun == null) {
      throw DomainException(S.current.msg_error_gun_not_found);
    }
    return HardwareChargeDeviceManager.instance
        .find(address)
        .authCharge(connectorId: 1, isCharge: isCharge, current: gun.current);
  }

  _WrapperBluetoothDevice getDevice(String address) {
    _WrapperBluetoothDevice? exist = _deviceMap[address];
    if (exist == null) {
      exist = _WrapperBluetoothDevice(address);
      _deviceMap[address] = exist;
    }
    return exist;
  }

  @override
  Future disconnect(String address) =>
      HardwareChargeDeviceManager.instance.find(address).disconnect();

  @override
  Stream<GPChargeSynchroStatus?> watchSynchroStatus(String address) =>
      getDevice(address).synchroStatusProvider.stream;

  @override
  Stream<GPChargeSynchroData?> watchSynchroData(String address) =>
      getDevice(address).synchroDataProvider.stream;

  @override
  Future<List<ChargeRecordPO>> getChargeRecordList(
      {required String address,
      required int page,
      required int size,
      required int startTime,
      required int endTime}) {
    return UserDatabase.instance.chargeRecordDao.getChargeRecordList(
        startTime, endTime, address, size, (page - 1) * size);
  }

  @override
  Future<List<ChargeWarningReminderPO>> getReminderList(
          {required String address, required int page, required int size}) =>
      UserDatabase.instance.chargeWarningReminderDao
          .getWarningReminder(address, size, (page - 1) * size);

  @override
  Stream<HouseholdDeviceDetail?> watchDeviceDetail(String address) =>
      createDataStream(
          key: BeanMethodFetchKey(
              beanType: HouseholdDeviceCase,
              methodType: watchDeviceDetail.runtimeType,
              arguments: address),
          fetchData: () => UserDatabase.instance.chargeDeviceDao
              .findDeviceByAddress(address)
              .then((value) =>
                  value == null ? null : HouseholdDeviceDetail.fromPO(value)));

  @override
  Future reboot(String address) =>
      HardwareChargeDeviceManager.instance.find(address).reboot();

  @override
  Stream<ChargeDeviceGunPO?> watchDeviceGun(String address) => createDataStream(
      key: BeanMethodFetchKey(
          beanType: HouseholdDeviceCase,
          methodType: watchDeviceGun.runtimeType,
          arguments: address),
      where: (event) {
        if (event is ServiceDataChangedEvent &&
            event.dataType == DataType.gun) {
          return event.operateType != DataOperateType.insert &&
              (event.data == null ||
                  (event.data as ChargeDeviceGunPO).deviceAddress == address);
        }
        return false;
      },
      fetchData: () =>
          UserDatabase.instance.chargeDeviceGunDao.getGun(address, 1));

  @override
  Future updateGunCurrent(String address, int current) async {
    final gun =
        await UserDatabase.instance.chargeDeviceGunDao.getGun(address, 1);
    if (gun == null) {
      throw DomainException(S.current.msg_error_gun_not_found);
    }
    final updatedGun = gun.copyWith(current: current);
    UserDatabase.instance.chargeDeviceGunDao
        .updateGun(gun.copyWith(current: current));
    serviceEventBus.post(ServiceDataChangedEvent(
        DataType.gun, DataOperateType.update, updatedGun));
  }

  @override
  Future<List<ChargeRecordItemVO>> getTimerTaskList(int page, int size) async =>
      UserDatabase.instance.chargeTimerDao
          .getTimerListByUserId(
              await userStore.asyncGetValue<String>("userId") ?? "",
              size,
              (page - 1) * size)
          .then((value) => value.map(ChargeRecordItemVO.fromDB).toList());

  @override
  Future<ChargeDeviceGunPO?> getChargeGunById(int deviceId) =>
      UserDatabase.instance.chargeDeviceGunDao.getGunByDeviceId(deviceId, 1);

  @override
  Future insertOrUpdateTimer(ChargeTimeTaskPO task) async {
    checkTask(task);
    if (task.id == null) {
      await UserDatabase.instance.chargeTimerDao
          .insertTimer(task..updateUnique());
    } else {
      await UserDatabase.instance.chargeTimerDao
          .updateTimer(task..updateUnique());
    }
  }

  @override
  Future deleteReminderList(String address, Iterable<int> ids) =>
      UserDatabase.instance.chargeWarningReminderDao
          .deleteReminderInIds(address, ids);

  @override
  Future deleteTimer(int id) =>
      UserDatabase.instance.chargeTimerDao.deleteById(id);

  @override
  Future<ChargeTimeTaskPO?> getTimeById(int id) =>
      UserDatabase.instance.chargeTimerDao.findTimeById(id);

  Future checkTask(ChargeTimeTaskPO task, {bool filterOpen = false}) async {
    final List<ChargeTimeTaskPO> taskList;
    if (filterOpen) {
      taskList = await UserDatabase.instance.chargeTimerDao
          .getOpenTimeTaskListByDevice(task.deviceAddress);
    } else {
      taskList = await UserDatabase.instance.chargeTimerDao
          .getTimeTaskListByDevice(task.deviceAddress);
    }
    if (taskList.isEmpty) {
      return;
    }
    if (taskList.length == 1) {
      final one = taskList[0];
      if (one.id == task.id) {
        return;
      }
    }
    final schedule = _TimeTaskSchedule.create(
        startTaskDate: task.startDate,
        endTaskDate: task.endDate,
        startTaskTime: task.startTime,
        endTaskTime: task.endTime,
        loop: task.loop);

    _TimeTaskSchedule current;
    for (var item in taskList) {
      if (item.id == task.id) {
        continue;
      }
      current = _TimeTaskSchedule.create(
          startTaskDate: item.startDate,
          endTaskDate: item.endDate,
          startTaskTime: item.startTime,
          endTaskTime: item.endTime,
          loop: item.loop);

      for (var targetItem in schedule.items) {
        for (var currentItem in current.items) {
          if ((targetItem.startDateTime >= currentItem.startDateTime &&
                  targetItem.startDateTime <= currentItem.endDateTime) ||
              (targetItem.endDateTime >= currentItem.startDateTime &&
                  targetItem.endDateTime <= currentItem.endDateTime) ||
              (currentItem.startDateTime >= targetItem.startDateTime &&
                  currentItem.startDateTime <= targetItem.endDateTime) ||
              (currentItem.endDateTime >= targetItem.startDateTime &&
                  currentItem.endDateTime <= targetItem.endDateTime)) {
            throw DomainException(
                S.current.msg_error_time_task_time_exist(item.taskName));
          }
        }
      }
    }
  }

  @override
  Future<bool> openTimeTask(int id, bool open) async {
    final timer = await UserDatabase.instance.chargeTimerDao.findTimeById(id);
    if (timer == null) {
      return false;
    }
    if (open) {
      if (timer.loop.isEmpty) {
        final now = DateTime.now();
        final startDateTime = (timer.startDate == -1
                ? now
                    .copyWith(
                        hour: 0,
                        minute: 0,
                        second: 0,
                        millisecond: 0,
                        microsecond: 0)
                    .millisecondsSinceEpoch
                : timer.startDate) +
            timer.startTime * 1000;
        if (startDateTime <= now.millisecondsSinceEpoch) {
          throw DomainException(S.current.msg_error_time_task_time_low_now);
        }
      }
    }
    final result = await HardwareChargeDeviceManager.instance
        .find(timer.deviceAddress)
        .setSchedule(
            reservationId: 1,
            connectorId: timer.connectorId,
            scheduleList: [
              Schedule(
                  startDate: timer.startDate == -1
                      ? null
                      : DateTime.fromMillisecondsSinceEpoch(timer.startDate),
                  endDate: timer.endDate == -1
                      ? null
                      : DateTime.fromMillisecondsSinceEpoch(timer.endDate),
                  isRecurring: timer.loop,
                  startTime: Duration(seconds: timer.startTime),
                  endTime: Duration(seconds: timer.endTime),
                  current: timer.current)
            ],
            isCancel: !open);
    if (result) {
      timer.open = open ? 1 : 0;
      await UserDatabase.instance.chargeTimerDao.updateTimer(timer);
      return true;
    } else {
      if (!open) {
        timer.open = 0;
        await UserDatabase.instance.chargeTimerDao.updateTimer(timer);
        return true;
      }
      return false;
    }
  }

  @override
  Future unbind(String address) async {
    final userId = await userStore.asyncGetValue<String>("userId") ?? "";
    final userBinder = await UserDatabase.instance.userBindChargeDeviceDao
        .findByAddress(userId, address);
    if (userBinder == null) {
      return;
    }
    await UserDatabase.instance.userBindChargeDeviceDao.delete(userId, address);
    final device = HardwareChargeDeviceManager.instance.find(address);
    if (device.isConnected) {
      device.disconnect().catchError((e) {});
    }
    serviceEventBus.post(HardwareChargeEvent(
        operateType: DataOperateType.delete,
        chargePO: ChargeDevicePO()..id = userBinder.deviceId));
  }

  @override
  Future<ChargeStatisticsVO> getChargeStatistics() async =>
      UserDatabase.instance.chargeRecordDao.getChargeStatistics(
          await userStore.asyncGetValue<String>("userId") ?? "");

  @override
  Future<HouseholdDeviceDetail?> getDeviceDetail(String address) =>
      UserDatabase.instance.chargeDeviceDao.findDeviceByAddress(address).then(
          (value) =>
              value == null ? null : HouseholdDeviceDetail.fromPO(value));

  @override
  Future<List<ChargeStatisticsByDay>> getChartStatistics(
          DateTime start, DateTime end) async =>
      UserDatabase.instance.chargeRecordDao.getChargeStatisticsByDate(
          await userStore.asyncGetValue<String>("userId") ?? "",
          start.millisecondsSinceEpoch,
          end.millisecondsSinceEpoch);

  @override
  Future updateLog(String address) async {
    final device = await UserDatabase.instance.chargeDeviceDao
        .findDeviceByAddress(address);
    if (device == null) {
      throw DomainException(S.current.msg_error_device_not_found);
    }
    final cacheLogDir = await getTemporaryDirectory().then((value) async {
      final dir = Directory("${value.path}${Platform.pathSeparator}log");
      if (!(await dir.exists())) {
        await dir.create(recursive: true);
      }
      return dir;
    });
    final dateFormat = DateFormat("yyyyMMddHHmmss");
    final eepromFileName = "eeprom${dateFormat.format(DateTime.now())}.log";
    //final eepromFileName = "eeprom20240129103337.log";
    final eepromFile =
        File("${cacheLogDir.path}${Platform.pathSeparator}${eepromFileName}");

    // await getDevice(address).readDiagnosis(eepromFile);
    await httpClient.post("/file/uploadFile",
        data: FormData.fromMap({
          "devicesn": device.sn,
          "file":
              await MultipartFile.fromFile(eepromFile.path, filename: "file")
        }));
  }

  @override
  Future requestRecordSync(String address) =>
      getDevice(address).requestRecordSync();
}

class _TimeTaskSchedule {
  final List<_TimeTaskScheduleItem> items;

  _TimeTaskSchedule(this.items);

  factory _TimeTaskSchedule.create({
    required int startTaskDate,
    required int endTaskDate,
    required int startTaskTime,
    required int endTaskTime,
    required String loop,
  }) {
    const dayInSecond = 24 * 60 * 60;
    final now = DateTime.now();
    final startTime = startTaskTime * 1000;
    final int endTime;
    if (startTaskTime < endTaskTime) {
      endTime = endTaskTime * 1000;
    } else {
      endTime = (endTaskTime + dayInSecond) * 1000;
    }
    if (loop.isEmpty) {
      final List<_TimeTaskScheduleItem> items = [];
      if (startTaskDate == -1) {
        var start = now
            .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0)
            .millisecondsSinceEpoch;
        items.add(_TimeTaskScheduleItem(start + startTime, start + endTime));
      } else {
        final day = (endTaskDate - startTaskDate + dayInSecond * 1000) /
            (dayInSecond * 1000);
        int timeInMillis;
        for (var index = 0; index < day; index++) {
          timeInMillis = startTaskDate + index * dayInSecond * 1000;
          items.add(_TimeTaskScheduleItem(
              timeInMillis + startTime, timeInMillis + endTime));
        }
      }
      return _TimeTaskSchedule(items);
    } else {
      final loops = (loop == "8" ? "1,2,3,4,5,6,7" : loop)
          .split(",")
          .map((e) => int.parse(e));
      final List<_TimeTaskScheduleItem> items = [];
      if (startTaskDate != -1) {
        final loopSet = loops.toSet();
        final findSet = <int>{};
        final day = (endTaskDate - startTaskDate + dayInSecond * 1000) /
            (dayInSecond * 1000);
        int timeInMillis;
        DateTime dateTime;
        int week;
        for (var index = 0; index < day; index++) {
          timeInMillis = startTaskDate + index * dayInSecond * 1000;
          dateTime = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
          week = dateTime.weekday;
          if (loopSet.contains(week)) {
            items.add(_TimeTaskScheduleItem(
                timeInMillis + startTime, timeInMillis + endTime));
          }
          findSet.add(week);
        }
        if (loopSet.length != findSet.length) {
          throw "存在超出的时间";
        }
      } else {
        var start = _nowMonDay().millisecondsSinceEpoch;
        int timeInMillis;
        for (var loop in loops) {
          timeInMillis = start + (loop - 1) * dayInSecond * 1000;
          items.add(_TimeTaskScheduleItem(
              timeInMillis + startTime, timeInMillis + endTime));
        }
      }
      return _TimeTaskSchedule(items);
    }
  }

  static DateTime _nowMonDay() {
    DateTime dateTime =
        DateTime.now().copyWith(hour: 0, minute: 0, second: 0, millisecond: 0);
    final week = dateTime.weekday;
    if (week == 1) {
      return dateTime;
    }
    return dateTime.subtract(Duration(days: week - 1));
  }
}

class _TimeTaskScheduleItem {
  final int startDateTime;
  final int endDateTime;

  _TimeTaskScheduleItem(this.startDateTime, this.endDateTime);
}
