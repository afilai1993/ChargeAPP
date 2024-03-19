enum DeviceType {
  bluetooth(1),
  wifi(2);

  static final _map = {
    DeviceType.bluetooth.value: DeviceType.bluetooth,
    DeviceType.wifi.value: DeviceType.wifi,
  };
  final int value;

  const DeviceType(this.value);

  static DeviceType? valueOf(int value) => _map[value];
}

class UserBindChargeDevicePO {
  int? id;
  String sn = "";
  String userId = "";
  int deviceId = 0;
  String deviceAddress = "";
  String key = "";
}

class ChargeDevicePO {
  int? id;
  String name = "";
  String sn = "";
  DeviceType deviceType = DeviceType.bluetooth;
  String address = "";
  int chargeTimes = 0;
  int cumulativeTime = 0;
  int totalPower = 0;
  String sVersion = "";
  String hVersion = "";

  ChargeDevicePO();

  factory ChargeDevicePO.fromDB(Map<String, Object?> row) => ChargeDevicePO()
    ..id = row["id"] as int
    ..name = row["name"] as String
    ..sn = row["sn"] as String
    ..deviceType = DeviceType.valueOf(row["device_type"] as int)!
    ..address = row["address"] as String
    ..chargeTimes = row["charge_times"] as int
    ..cumulativeTime = row["cumulative_time"] as int
    ..totalPower = row["total_power"] as int
    ..sVersion = row["s_version"] as String
    ..hVersion = row["h_version"] as String;
}

class ChargeDeviceGunPO {
  final int? id;
  final int deviceId;

  final String deviceAddress;

  final int current;
  final int miniCurrent;

  final int connectorId;

  final int maxCurrent;
  final int pncStatus;

  const ChargeDeviceGunPO({
    this.id,
    this.deviceId = 0,
    this.deviceAddress = "",
    this.current = 20,
    this.miniCurrent = 0,
    this.connectorId = 1,
    this.maxCurrent = 30,
    this.pncStatus = 0,
  });

  factory ChargeDeviceGunPO.fromDB(Map<String, Object?> row) =>
      ChargeDeviceGunPO(
          id: row["id"] as int,
          deviceId: row["device_id"] as int,
          deviceAddress: row["device_address"] as String,
          current: row["current"] as int,
          miniCurrent: row["mini_current"] as int,
          connectorId: row["connector_id"] as int,
          maxCurrent: row["max_current"] as int,
          pncStatus: row["pnc_status"] as int);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChargeDeviceGunPO &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          deviceId == other.deviceId &&
          deviceAddress == other.deviceAddress &&
          current == other.current &&
          miniCurrent == other.miniCurrent &&
          connectorId == other.connectorId &&
          maxCurrent == other.maxCurrent &&
          pncStatus == other.pncStatus;

  @override
  int get hashCode =>
      id.hashCode ^
      deviceId.hashCode ^
      deviceAddress.hashCode ^
      current.hashCode ^
      miniCurrent.hashCode ^
      connectorId.hashCode ^
      maxCurrent.hashCode ^
      pncStatus.hashCode;

  ChargeDeviceGunPO copyWith({
    int? id,
    int? deviceId,
    String? deviceAddress,
    int? current,
    int? miniCurrent,
    int? connectorId,
    int? maxCurrent,
    int? pncStatus,
  }) {
    return ChargeDeviceGunPO(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      deviceAddress: deviceAddress ?? this.deviceAddress,
      current: current ?? this.current,
      miniCurrent: miniCurrent ?? this.miniCurrent,
      connectorId: connectorId ?? this.connectorId,
      maxCurrent: maxCurrent ?? this.maxCurrent,
      pncStatus: pncStatus ?? this.pncStatus,
    );
  }
}

class ChargeRecordPO {
  int? id;
  int deviceId = 0;
  String deviceAddress = "";
  int? connectorId;
  int startTime = -1;
  int endTime = -1;
  double energy = 0;
  String prices = "";
  String stopReason = "";

  ChargeRecordPO();

  factory ChargeRecordPO.fromDB(Map<String, Object?> row) => ChargeRecordPO()
    ..id = row["id"] as int
    ..deviceId = row["device_id"] as int
    ..deviceAddress = row["device_address"] as String
    ..connectorId = row["connector_id"] as int
    ..startTime = row["start_time"] as int
    ..endTime = row["end_time"] as int
    ..energy = row["energy"] as double
    ..prices = row["prices"] as String
    ..stopReason = row["stop_reason"] as String;
}

class ChargeWarningReminderPO {
  int? id;
  int deviceId = 0;
  String deviceAddress = "";
  int time = -1;
  int connectorId = 1;
  int statusCode = -1;

  ChargeWarningReminderPO();

  factory ChargeWarningReminderPO.fromDB(Map<String, Object?> row) =>
      ChargeWarningReminderPO()
        ..id = row["id"] as int
        ..deviceId = row["device_id"] as int
        ..deviceAddress = row["device_address"] as String
        ..time = row["time"] as int
        ..connectorId = row["connector_id"] as int
        ..statusCode = row["status_code"] as int;
}

class ChargeTimeTaskPO {
  int? id;
  String taskName = "";
  int deviceId = 0;
  String deviceAddress = "";
  int startDate = -1;
  int endDate = -1;
  String deviceName = "";
  int startTime = -1;
  int endTime = -1;
  int current = -1;
  String loop = "";
  int reminder = 0;
  int open = 0;
  String uniqueNo = "";
  int connectorId = 1;
  int version = 0;

  ChargeTimeTaskPO();

  factory ChargeTimeTaskPO.fromDB(Map<String, Object?> row) =>
      ChargeTimeTaskPO()
        ..id = row["id"] as int
        ..taskName = row["task_name"] as String
        ..deviceId = row["device_id"] as int
        ..deviceAddress = row["device_address"] as String
        ..startDate = row["start_date"] as int
        ..endDate = row["end_date"] as int
        ..deviceName = row["device_name"] as String
        ..startTime = row["start_time"] as int
        ..endTime = row["end_time"] as int
        ..current = row["current"] as int
        ..loop = row["loop"] as String
        ..reminder = row["reminder"] as int
        ..open = row["open"] as int
        ..uniqueNo = row["unique_no"] as String
        ..connectorId = row["connector_id"] as int
        ..version = row["version"] as int;

  void updateUnique() {
    uniqueNo = "${startDate}&${endDate}&${loop}&${startTime}${endTime}";
  }
}
