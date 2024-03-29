class ChargeStationItemDTO {
  final double lng;
  final double lat;
  final String chargePrice;
  final double distance;
  final String name;
  final String cscode;

  factory ChargeStationItemDTO.fromJson(Map<String, dynamic> json) =>
      ChargeStationItemDTO(
        lng: json["lon"],
        lat: json["lat"],
        chargePrice: json["chargePrice"].toString(),
        distance: json["distance"],
        name: json["name"],
        cscode: json["cscode"],
      );

  const ChargeStationItemDTO({
    required this.lng,
    required this.lat,
    required this.chargePrice,
    required this.distance,
    required this.name,
    required this.cscode,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChargeStationItemDTO &&
          runtimeType == other.runtimeType &&
          lng == other.lng &&
          lat == other.lat &&
          chargePrice == other.chargePrice &&
          distance == other.distance &&
          name == other.name &&
          cscode == other.cscode;

  @override
  int get hashCode =>
      lng.hashCode ^
      lat.hashCode ^
      chargePrice.hashCode ^
      distance.hashCode ^
      name.hashCode ^
      cscode.hashCode;
}

class GPChargeDeviceData {
  final String? chargeBoxSN;
  final String? sVersion;
  final String? hVersion;
  final int? chargeTimes;
  final int? cumulativeTime;
  final int? totalPower;
  final bool? isLoadbalance;
  final GPChargeDeviceDataConnector? connectorMain;

  const GPChargeDeviceData({
    this.chargeBoxSN,
    this.sVersion,
    this.hVersion,
    this.chargeTimes,
    this.cumulativeTime,
    this.totalPower,
    this.isLoadbalance,
    this.connectorMain,
  });

  factory GPChargeDeviceData.fromJson(dynamic json) => GPChargeDeviceData(
        chargeBoxSN: json["chargeBoxSN"],
        sVersion: json["sVersion"],
        hVersion: json["hVersion"],
        chargeTimes: json["chargeTimes"],
        cumulativeTime: json["cumulativeTime"],
        totalPower: json["totalPower"],
        isLoadbalance: json["isLoadbalance"],
        connectorMain:
            GPChargeDeviceDataConnector.fromJson(json["connectorMain"]),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GPChargeDeviceData &&
          runtimeType == other.runtimeType &&
          chargeBoxSN == other.chargeBoxSN &&
          sVersion == other.sVersion &&
          hVersion == other.hVersion &&
          chargeTimes == other.chargeTimes &&
          cumulativeTime == other.cumulativeTime &&
          totalPower == other.totalPower &&
          isLoadbalance == other.isLoadbalance &&
          connectorMain == other.connectorMain;

  @override
  int get hashCode =>
      chargeBoxSN.hashCode ^
      sVersion.hashCode ^
      hVersion.hashCode ^
      chargeTimes.hashCode ^
      cumulativeTime.hashCode ^
      totalPower.hashCode ^
      isLoadbalance.hashCode ^
      connectorMain.hashCode;
}

class GPChargeDeviceDataConnector {
  int? miniCurrent;
  int? maxCurrent;
  String? connectorStatus;
  int? pncStatus;

  factory GPChargeDeviceDataConnector.fromJson(dynamic json) =>
      GPChargeDeviceDataConnector(
        miniCurrent: json["miniCurrent"],
        maxCurrent: json["maxCurrent"],
        connectorStatus: json["connectorStatus"],
        pncStatus: json["PncStatus"],
      );

  GPChargeDeviceDataConnector({
    this.miniCurrent,
    this.maxCurrent,
    this.connectorStatus,
    this.pncStatus,
  });
}

class GPChargeSynchroStatus {
  final String? chargeBoxSN;
  final GPChargeSynchroStatusConnector? connectorMain;

  const GPChargeSynchroStatus({
    this.chargeBoxSN,
    this.connectorMain,
  });

  factory GPChargeSynchroStatus.fromJson(dynamic json) => GPChargeSynchroStatus(
      chargeBoxSN: json["chargeBoxSN"],
      connectorMain:
          GPChargeSynchroStatusConnector.fromJson(json["connectorMain"]));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GPChargeSynchroStatus &&
          runtimeType == other.runtimeType &&
          chargeBoxSN == other.chargeBoxSN &&
          connectorMain == other.connectorMain;

  @override
  int get hashCode => chargeBoxSN.hashCode ^ connectorMain.hashCode;
}

class GPChargeSynchroStatusConnector {
  final bool? connectionStatus;
  final String? chargeStatus;
  final int? statusCode;
  final String? startTime;
  final String? endTime;
  final int? reserveCurrent;

  const GPChargeSynchroStatusConnector({
    this.connectionStatus,
    this.chargeStatus,
    this.statusCode,
    this.startTime,
    this.endTime,
    this.reserveCurrent,
  });

  factory GPChargeSynchroStatusConnector.fromJson(dynamic json) =>
      GPChargeSynchroStatusConnector(
        connectionStatus: json["connectionStatus"],
        chargeStatus: json["chargeStatus"],
        statusCode: json["statusCode"],
        startTime: json["startTime"],
        reserveCurrent: json["reserveCurrent"],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GPChargeSynchroStatusConnector &&
          runtimeType == other.runtimeType &&
          connectionStatus == other.connectionStatus &&
          chargeStatus == other.chargeStatus &&
          statusCode == other.statusCode &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          reserveCurrent == other.reserveCurrent;

  @override
  int get hashCode =>
      connectionStatus.hashCode ^
      chargeStatus.hashCode ^
      statusCode.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      reserveCurrent.hashCode;
}

class GPChargeSynchroInfo {
  final String? chargeBoxSN;
  final GPChargeSynchroInfoConnector? connectorMain;
  final String? temperature1;
  final String? temperature2;

  const GPChargeSynchroInfo({
    this.chargeBoxSN,
    this.connectorMain,
    this.temperature1,
    this.temperature2,
  });

  factory GPChargeSynchroInfo.fromJson(dynamic json) => GPChargeSynchroInfo(
        chargeBoxSN: json["chargeBoxSN"],
        connectorMain: GPChargeSynchroInfoConnector.fromJson(json["connectorMain"]),
        temperature1: json["Temperature1"],
        temperature2: json["Temperature2"],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GPChargeSynchroInfo &&
          runtimeType == other.runtimeType &&
          chargeBoxSN == other.chargeBoxSN &&
          connectorMain == other.connectorMain &&
          temperature1 == other.temperature1 &&
          temperature2 == other.temperature2;

  @override
  int get hashCode =>
      chargeBoxSN.hashCode ^
      connectorMain.hashCode ^
      temperature1.hashCode ^
      temperature2.hashCode;
}

class GPChargeSynchroInfoConnector {
  final bool? connectionStatus;
  final String? chargeStatus;
  final int? statusCode;
  final String? startTime;
  final String? endTime;
  final String? reserveCurrent;
  final String? voltage;
  final String? current;
  final String? power;
  final String? electricWork;
  final String? chargingTime;

  const GPChargeSynchroInfoConnector({
    this.connectionStatus,
    this.chargeStatus,
    this.statusCode,
    this.startTime,
    this.endTime,
    this.reserveCurrent,
    this.voltage,
    this.current,
    this.power,
    this.electricWork,
    this.chargingTime,
  });

  factory GPChargeSynchroInfoConnector.fromJson(dynamic json) =>
      GPChargeSynchroInfoConnector(
        connectionStatus: json["connectionStatus"],
        chargeStatus: json["chargeStatus"],
        statusCode: json["statusCode"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        reserveCurrent: json["reserveCurrent"],
        voltage: json["voltage"],
        current: json["current"],
        power: json["power"],
        electricWork: json["electricWork"],
        chargingTime: json["chargingTime"],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GPChargeSynchroInfoConnector &&
          runtimeType == other.runtimeType &&
          connectionStatus == other.connectionStatus &&
          chargeStatus == other.chargeStatus &&
          statusCode == other.statusCode &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          reserveCurrent == other.reserveCurrent &&
          voltage == other.voltage &&
          current == other.current &&
          power == other.power &&
          electricWork == other.electricWork &&
          chargingTime == other.chargingTime;

  @override
  int get hashCode =>
      connectionStatus.hashCode ^
      chargeStatus.hashCode ^
      statusCode.hashCode ^
      startTime.hashCode ^
      endTime.hashCode ^
      reserveCurrent.hashCode ^
      voltage.hashCode ^
      current.hashCode ^
      power.hashCode ^
      electricWork.hashCode ^
      chargingTime.hashCode;
}

class GPChargeSynchroData {
  final String? chargeBoxSN;
  final GPChargeSynchroDataConnector? connectorMain;
  final String? temperature1;
  final String? temperature2;

  const GPChargeSynchroData({
    this.chargeBoxSN,
    this.connectorMain,
    this.temperature1,
    this.temperature2,
  });

  factory GPChargeSynchroData.fromJson(dynamic json) => GPChargeSynchroData(
        chargeBoxSN: json["chargeBoxSN"],
        connectorMain:
            GPChargeSynchroDataConnector.fromJson(json["connectorMain"]),
        temperature1: json["Temperature1"],
        temperature2: json["Temperature2"],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GPChargeSynchroData &&
          runtimeType == other.runtimeType &&
          chargeBoxSN == other.chargeBoxSN &&
          connectorMain == other.connectorMain &&
          temperature1 == other.temperature1 &&
          temperature2 == other.temperature2;

  @override
  int get hashCode =>
      chargeBoxSN.hashCode ^
      connectorMain.hashCode ^
      temperature1.hashCode ^
      temperature2.hashCode;
}

class GPChargeSynchroDataConnector {
  final String? voltage;
  final String? current;
  final String? power;
  final String? electricWork;
  final String? chargingTime;

  const GPChargeSynchroDataConnector({
    this.voltage,
    this.current,
    this.power,
    this.electricWork,
    this.chargingTime,
  });

  // static updateChargingTime(String time)
  // {
  //   GPChargeSynchroDataConnector(
  //     chargingTime: time,
  //   );
  // }

  factory GPChargeSynchroDataConnector.fromJson(dynamic json) =>
      GPChargeSynchroDataConnector(
        voltage: json["voltage"],
        current: json["current"],
        power: json["power"],
        electricWork: json["electricWork"],
        chargingTime: json["chargingTime"],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GPChargeSynchroDataConnector &&
          runtimeType == other.runtimeType &&
          voltage == other.voltage &&
          current == other.current &&
          power == other.power &&
          electricWork == other.electricWork &&
          chargingTime == other.chargingTime;

  @override
  int get hashCode =>
      voltage.hashCode ^
      current.hashCode ^
      power.hashCode ^
      electricWork.hashCode ^
      chargingTime.hashCode;
}
