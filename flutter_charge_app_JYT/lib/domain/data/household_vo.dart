import 'package:chargestation/repository/data/po.dart';

class HouseholdDeviceItemVO {
  final int? id;
  final String name;
  final String address;
  final DeviceType deviceType;

  const HouseholdDeviceItemVO({
    this.id,
    required this.name,
    required this.address,
    required this.deviceType,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HouseholdDeviceItemVO &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          deviceType == other.deviceType;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ deviceType.hashCode;
}

class HouseholdDeviceDetail {
  int? id;
  String name;
  String sn;
  DeviceType deviceType;
  String address;
  int totalPower;
  String sVersion;

  String hVersion;

  HouseholdDeviceDetail({
    required this.id,
    required this.name,
    required this.sn,
    required this.deviceType,
    required this.address,
    required this.totalPower,
    required this.sVersion,
    required this.hVersion,
  });

  factory HouseholdDeviceDetail.fromPO(ChargeDevicePO device) =>
      HouseholdDeviceDetail(
        id: device.id,
        name: device.name,
        sn: device.sn,
        deviceType: device.deviceType,
        address: device.address,
        totalPower: device.totalPower,
        sVersion: device.sVersion,
        hVersion: device.hVersion,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HouseholdDeviceDetail &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          sn == other.sn &&
          deviceType == other.deviceType &&
          address == other.address &&
          totalPower == other.totalPower &&
          sVersion == other.sVersion &&
          hVersion == other.hVersion;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      sn.hashCode ^
      deviceType.hashCode ^
      address.hashCode ^
      totalPower.hashCode ^
      sVersion.hashCode ^
      hVersion.hashCode;
}

class ChargeRecordItemVO {
  final int? id;
  final String taskName;

  final DateTime? startDate;

  final DateTime? endDate;

  final String deviceName;

  final Duration? startTime;

  final Duration? endTime;

  final int current;

  final String loop;

  final int reminder;

  final int open;

  final int connectorId;

  const ChargeRecordItemVO({
    this.id,
    this.taskName = "",
    this.startDate,
    this.endDate,
    this.deviceName = "",
    this.startTime,
    this.endTime,
    this.current = 20,
    this.loop = "",
    this.reminder = 0,
    this.open = 0,
    this.connectorId = 1,
  });

  factory ChargeRecordItemVO.fromDB(ChargeTimeTaskPO po) => ChargeRecordItemVO(
        id: po.id,
        taskName: po.taskName,
        startDate: po.startDate == -1
            ? null
            : DateTime.fromMillisecondsSinceEpoch(po.startDate),
        endDate: po.startDate == -1
            ? null
            : DateTime.fromMillisecondsSinceEpoch(po.endDate),
        deviceName: po.deviceName,
        startTime: po.startTime == -1 ? null : Duration(seconds: po.startTime),
        endTime: po.endTime == -1 ? null : Duration(seconds: po.endTime),
        current: po.current,
        loop: po.loop,
        reminder: po.reminder,
        open: po.open,
        connectorId: po.connectorId,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChargeRecordItemVO &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          taskName == other.taskName &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          deviceName == other.deviceName &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          current == other.current &&
          loop == other.loop &&
          reminder == other.reminder &&
          open == other.open &&
          connectorId == other.connectorId;

  @override
  int get hashCode =>
      id.hashCode ^
      taskName.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      deviceName.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      current.hashCode ^
      loop.hashCode ^
      reminder.hashCode ^
      open.hashCode ^
      connectorId.hashCode;

  ChargeRecordItemVO copyWith({
    int? id,
    String? taskName,
    DateTime? startDate,
    DateTime? endDate,
    String? deviceName,
    Duration? startTime,
    Duration? endTime,
    int? current,
    String? loop,
    int? reminder,
    int? open,
    int? connectorId,
  }) {
    return ChargeRecordItemVO(
      id: id ?? this.id,
      taskName: taskName ?? this.taskName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      deviceName: deviceName ?? this.deviceName,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      current: current ?? this.current,
      loop: loop ?? this.loop,
      reminder: reminder ?? this.reminder,
      open: open ?? this.open,
      connectorId: connectorId ?? this.connectorId,
    );
  }

  @override
  String toString() {
    return 'ChargeRecordItemVO{id: $id, taskName: $taskName, startDate: $startDate, endDate: $endDate, deviceName: $deviceName, startTime: $startTime, endTime: $endTime, current: $current, loop: $loop, reminder: $reminder, open: $open, connectorId: $connectorId}';
  }
}
