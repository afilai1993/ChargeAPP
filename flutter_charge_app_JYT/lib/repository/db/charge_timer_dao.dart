import 'package:chargestation/infrastructure/infrastructure.dart';

class ChargeTimerDao {
  final GPDatabase database;

  ChargeTimerDao(this.database);

  Future closeLowVersion(String address, int version) => database.update(
      "UPDATE  charge_time_task SET open=0 WHERE device_address=? AND version<? ",
      [address, version]);

  Future<ChargeTimeTaskPO?> getTimeTask(String address, String uniqueNo) =>
      database.query(
          "SELECT * FROM charge_time_task WHERE device_address=? AND  unique_no=? ",
          [address, uniqueNo]).then((value) {
        final first = value.firstOrNull;
        if (first == null) {
          return null;
        }
        return ChargeTimeTaskPO.fromDB(first);
      });

  Future<int?> getMaxVersion(String address) => database.query(
          "SELECT version FROM charge_time_task WHERE device_address=? ORDER BY version DESC LIMIT 1",
          [address]).then((value) {
        final first = value.firstOrNull;
        if (first == null) {
          return null;
        }
        return first["version"] as int?;
      });

  Future insertTimer(ChargeTimeTaskPO data) => database.insert(
          "INSERT OR ABORT INTO `charge_time_task` (`id`,`task_name`,`device_id`,`device_address`,`start_date`,`end_date`,`device_name`,`start_time`,`end_time`,`current`,`loop`,`reminder`,`open`,`unique_no`,`connector_id`,`version`) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
          [
            data.id,
            data.taskName,
            data.deviceId,
            data.deviceAddress,
            data.startDate,
            data.endDate,
            data.deviceName,
            data.startTime,
            data.endTime,
            data.current,
            data.loop,
            data.reminder,
            data.open,
            data.uniqueNo,
            data.connectorId,
            data.version
          ]);

  Future updateTimer(ChargeTimeTaskPO data) => database.update(
          "UPDATE OR ABORT `charge_time_task` SET `id` = ?,`task_name` = ?,`device_id` = ?,`device_address` = ?,`start_date` = ?,`end_date` = ?,`device_name` = ?,`start_time` = ?,`end_time` = ?,`current` = ?,`loop` = ?,`reminder` = ?,`open` = ?,`unique_no` = ?,`connector_id` = ?,`version` = ? WHERE `id` = ?",
          [
            data.id,
            data.taskName,
            data.deviceId,
            data.deviceAddress,
            data.startDate,
            data.endDate,
            data.deviceName,
            data.startTime,
            data.endTime,
            data.current,
            data.loop,
            data.reminder,
            data.open,
            data.uniqueNo,
            data.connectorId,
            data.version,
            data.id,
          ]);

  Future<List<ChargeTimeTaskPO>> getTimerListByUserId(
          String userId, int limit, int offset) =>
      database.query(
          "SELECT charge_time_task.* FROM charge_time_task LEFT JOIN user_bind_charge_device on charge_time_task.device_id=user_bind_charge_device.device_id  WHERE user_bind_charge_device.user_id=? ORDER BY open DESC,start_date DESC LIMIT ?,?",
          [
            userId,
            offset,
            limit
          ]).then((value) => value.map(ChargeTimeTaskPO.fromDB).toList());

  Future<ChargeTimeTaskPO?> findTimeById(int id) => database.query(
          "SELECT * FROM charge_time_task WHERE id=?", [id]).then((value) {
        final first = value.firstOrNull;
        if (first == null) {
          return null;
        }
        return ChargeTimeTaskPO.fromDB(first);
      });

  Future deleteById(int id) =>
      database.delete("DELETE FROM charge_time_task WHERE id=?", [id]);

  Future<List<ChargeTimeTaskPO>> getOpenTimeTaskListByDevice(
    String address,
  ) =>
      database.query(
          "SELECT * FROM charge_time_task WHERE device_address=? AND open=1", [
        address
      ]).then((value) => value.map(ChargeTimeTaskPO.fromDB).toList());

  Future<List<ChargeTimeTaskPO>> getTimeTaskListByDevice(
    String address,
  ) =>
      database.query("SELECT * FROM charge_time_task WHERE device_address=?", [
        address
      ]).then((value) => value.map(ChargeTimeTaskPO.fromDB).toList());
}
