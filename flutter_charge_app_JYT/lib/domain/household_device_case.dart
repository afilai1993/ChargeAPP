import 'dart:async';
import 'dart:io';

import 'package:chargestation/design.dart';
import 'package:chargestation/domain/device/charge_device.dart';
import 'package:chargestation/domain/device/exception.dart';
import 'package:chargestation/domain/eventbus/eventbus.dart';
import 'package:chargestation/domain/exception.dart';
import 'package:chargestation/domain/stream/fetch_data_stream_factory.dart';
import 'package:chargestation/infrastructure/infrastructure.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../repository/data/vo.dart';
import 'data/charge_station_dto.dart';
import 'data/household_vo.dart';
import 'device/ValueStreamProvider.dart';

part 'impl/household_device_case_impl.dart';

part 'impl/household_device_wrapper.dart';

part 'impl/diagnosis_reader.dart';

abstract class HouseholdDeviceCase {
  factory HouseholdDeviceCase() => _HouseholdDeviceCaseImpl();

  Future saveDevice({
    required String address,
    required String sn,
    required String name,
    required String key,
  });

  Future disconnect(String address);

  Stream<List<HouseholdDeviceItemVO>> watchDeviceList(DeviceType deviceType);

  Stream<HouseholdChargeDeviceConnectState> watchConnectState(String address);

  Stream<GPChargeSynchroStatus?> watchSynchroStatus(String address);

  Stream<GPChargeSynchroData?> watchSynchroData(String address);

  Stream<HouseholdDeviceDetail?> watchDeviceDetail(String address);

  Future<HouseholdDeviceDetail?> getDeviceDetail(String address);

  Stream<ChargeDeviceGunPO?> watchDeviceGun(String address);

  Future<ChargeTimeTaskPO?> getTimeById(int id);

  Future<List<ChargeRecordItemVO>> getTimerTaskList(int page, int size);

  Future deleteTimer(int id);

  Future<ChargeDeviceGunPO?> getChargeGunById(int deviceId);

  Future updateGunCurrent(String address, int current);

  Future<List<ChargeRecordPO>> getChargeRecordList(
      {required String address,
      required int page,
      required int size,
      required int startTime,
      required int endTime});

  Future<List<ChargeWarningReminderPO>> getReminderList({
    required String address,
    required int page,
    required int size,
  });

  Future deleteReminderList(String address, Iterable<int> ids);

  Future insertOrUpdateTimer(ChargeTimeTaskPO task);

  Future<bool> openTimeTask(int id, bool open);

  Future requestConnect(String address);

  Future<bool> requestCharge(String address, bool isCharge);

  Future reboot(String address);

  Future unbind(String address);

  Future<ChargeStatisticsVO> getChargeStatistics();

  Future updateLog(String address);

  Future<List<ChargeStatisticsByDay>> getChartStatistics(
      DateTime start, DateTime end);

  /// 尝试触发同步
  Future requestRecordSync(String address);
}
