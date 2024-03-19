import 'package:chargestation/repository/db/database.dart';
import 'package:chargestation/infrastructure/utils/iterables.dart';
import '../data/po.dart';

class UserBindChargeDeviceDao {
  final GPDatabase database;

  UserBindChargeDeviceDao(this.database);

  Future<bool> exist(String userId, int deviceId) => database.query(
      "SELECT * FROM user_bind_charge_device WHERE user_id=? AND device_id=?",
      [userId, deviceId]).then((value) => value.firstOrNull() != null);

  Future delete(String userId, String address) => database.delete(
      "DELETE FROM user_bind_charge_device WHERE user_id=? AND device_address=?",
      [userId, address]);

  Future<UserBindChargeDevicePO?> findByAddress(
          String userId, String address) =>
      database.query(
          "SELECT * FROM user_bind_charge_device WHERE user_id=? AND device_address=?",
          [userId, address]).then((value) {
        final first = value.firstOrNull();
        if (first == null) {
          return null;
        }
        return UserBindChargeDevicePO()
          ..id = first["id"] as int
          ..sn = first["sn"] as String
          ..userId = first["user_id"] as String
          ..deviceId = first["device_id"] as int
          ..deviceAddress = first["device_address"] as String
          ..key = first["key"] as String;
      });

  Future insert(UserBindChargeDevicePO po) {
    return database.insert(
        "INSERT OR ABORT INTO `user_bind_charge_device` (`id`,`sn`,`user_id`,`device_id`,`device_address`,`key`) VALUES (?,?,?,?,?,?)",
        [po.id, po.sn, po.userId, po.deviceId, po.deviceAddress, po.key]);
  }
}
