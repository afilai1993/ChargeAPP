import 'package:chargestation/repository/data/po.dart';

import 'database.dart';

class ChargeDeviceGunDao {
  final GPDatabase database;

  ChargeDeviceGunDao(this.database);

  Future<ChargeDeviceGunPO?> getGunByDeviceId(int id, int connectorId) =>
      database.query(
          "SELECT * FROM charge_device_gun WHERE device_id=? AND connector_id=?",
          [id, connectorId]).then((value) {
        final first = value.firstOrNull;
        if (first == null) {
          return null;
        }
        return ChargeDeviceGunPO.fromDB(first);
      });

  Future<ChargeDeviceGunPO?> getGun(String address, int connectorId) =>
      database.query(
          "SELECT * FROM charge_device_gun WHERE device_address=? AND connector_id=?",
          [address, connectorId]).then((value) {
        final first = value.firstOrNull;
        if (first == null) {
          return null;
        }
        return ChargeDeviceGunPO.fromDB(first);
      });

  Future insertGun(ChargeDeviceGunPO gun) => database.insert(
          "INSERT OR ABORT INTO `charge_device_gun` (`id`,`device_id`,`device_address`,`current`,`mini_current`,`connector_id`,`max_current`,`pnc_status`) VALUES (?,?,?,?,?,?,?,?)",
          [
            gun.id,
            gun.deviceId,
            gun.deviceAddress,
            gun.current,
            gun.miniCurrent,
            gun.connectorId,
            gun.maxCurrent,
            gun.pncStatus
          ]);

  Future updateGun(ChargeDeviceGunPO gun) => database.update(
          "UPDATE OR ABORT `charge_device_gun` SET `id` = ?,`device_id` = ?,`device_address` = ?,`current` = ?,`mini_current` = ?,`connector_id` = ?,`max_current` = ?,`pnc_status` = ? WHERE `id` = ?",
          [
            gun.id,
            gun.deviceId,
            gun.deviceAddress,
            gun.current,
            gun.miniCurrent,
            gun.connectorId,
            gun.maxCurrent,
            gun.pncStatus,
            gun.id
          ]);
}
