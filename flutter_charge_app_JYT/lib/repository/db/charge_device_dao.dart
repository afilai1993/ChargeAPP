import 'package:chargestation/infrastructure/utils/iterables.dart';
import 'package:chargestation/repository/data/po.dart';

import 'database.dart';

class ChargeDeviceDao {
  final GPDatabase database;

  ChargeDeviceDao(this.database);

  Future<List<ChargeDevicePO>> findDeviceList(
          String userId, DeviceType deviceType) =>
      database.query(
          "SELECT charge_device.* FROM charge_device LEFT JOIN user_bind_charge_device on charge_device.id=user_bind_charge_device.device_id WHERE user_bind_charge_device.user_id=? AND charge_device.device_type=?",
          [
            userId,
            deviceType.value
          ]).then((value) => value.map(ChargeDevicePO.fromDB).toList());

  Future<ChargeDevicePO?> findDeviceByAddress(String address) => database
          .query("SELECT * FROM charge_device WHERE address=?", [address]).then(
              (value) {
        final first = value.firstOrNull();
        if (first != null) {
          return ChargeDevicePO.fromDB(first);
        }
        return null;
      });

  Future<int> insert(ChargeDevicePO chargeDevice) => database.insert(
          "INSERT OR ABORT INTO `charge_device` (`id`,`name`,`sn`,`device_type`,`address`,`charge_times`,`cumulative_time`,`total_power`,`s_version`,`h_version`) VALUES (?,?,?,?,?,?,?,?,?,?)",
          [
            chargeDevice.id,
            chargeDevice.name,
            chargeDevice.sn,
            chargeDevice.deviceType.value,
            chargeDevice.address,
            chargeDevice.chargeTimes,
            chargeDevice.cumulativeTime,
            chargeDevice.totalPower,
            chargeDevice.sVersion,
            chargeDevice.hVersion
          ]);

  Future<int> update(ChargeDevicePO chargeDevice) => database.insert(
          "UPDATE OR ABORT `charge_device` SET `id` = ?,`name` = ?,`sn` = ?,`device_type` = ?,`address` = ?,`charge_times` = ?,`cumulative_time` = ?,`total_power` = ?,`s_version` = ?,`h_version` = ? WHERE `id` = ?",
          [
            chargeDevice.id,
            chargeDevice.name,
            chargeDevice.sn,
            chargeDevice.deviceType.value,
            chargeDevice.address,
            chargeDevice.chargeTimes,
            chargeDevice.cumulativeTime,
            chargeDevice.totalPower,
            chargeDevice.sVersion,
            chargeDevice.hVersion,
            chargeDevice.id,
          ]);
}
