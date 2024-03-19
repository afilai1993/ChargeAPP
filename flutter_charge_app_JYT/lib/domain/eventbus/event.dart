part of 'eventbus.dart';

abstract class Event {}

enum DataOperateType {
  insert,
  update,
  delete,
}

enum DataType {
  hardwareChargeDevice,
  gun,
  deviceTimer,
}

class HardwareChargeEvent implements Event {
  final DataOperateType operateType;
  final ChargeDevicePO? chargePO;

  HardwareChargeEvent({
    required this.operateType,
    this.chargePO,
  });


}

class RefreshAllDataChangedEvent implements Event {
  const RefreshAllDataChangedEvent();
}

class ServiceDataChangedEvent implements Event {
  final DataType dataType;
  final DataOperateType operateType;
  final dynamic data;

  const ServiceDataChangedEvent(this.dataType, this.operateType, this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceDataChangedEvent &&
          runtimeType == other.runtimeType &&
          dataType == other.dataType &&
          operateType == other.operateType &&
          data == other.data;

  @override
  int get hashCode => dataType.hashCode ^ operateType.hashCode ^ data.hashCode;
}

class ServiceDataListChangedEvent implements Event {
  final List<DataOperate> operateList;

  const ServiceDataListChangedEvent(this.operateList);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceDataListChangedEvent &&
          runtimeType == other.runtimeType &&
          const DeepCollectionEquality().equals(operateList, other.operateList);

  @override
  int get hashCode => operateList.hashCode;
}

class DataOperate {
  final DataType dataType;
  final DataOperateType operateType;

  const DataOperate(this.dataType, this.operateType);
}
