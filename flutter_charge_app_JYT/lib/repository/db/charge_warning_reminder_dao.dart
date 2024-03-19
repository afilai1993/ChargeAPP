import 'package:chargestation/infrastructure/infrastructure.dart';

class ChargeWarningReminderDao {
  final GPDatabase database;

  ChargeWarningReminderDao(this.database);

  Future<List<ChargeWarningReminderPO>> getWarningReminder(
          String address, int limit, int offset) =>
      database.query(
          "SELECT * FROM charge_warning_reminder WHERE device_address=? ORDER BY time DESC LIMIT ?,?",
          [
            address,
            offset,
            limit
          ]).then(
          (value) => value.map(ChargeWarningReminderPO.fromDB).toList());

  Future<ChargeWarningReminderPO?> findRecently(String address) =>
      database.query(
          "SELECT * FROM charge_warning_reminder WHERE device_address=? ORDER BY time DESC LIMIT 1",
          [address]).then((value) {
        final first = value.firstOrNull;
        if (first == null) {
          return null;
        }
        return ChargeWarningReminderPO.fromDB(first);
      });

  Future insertReminder(ChargeWarningReminderPO reminder) => database.insert(
          "INSERT OR ABORT INTO `charge_warning_reminder` (`id`,`device_id`,`device_address`,`time`,`connector_id`,`status_code`) VALUES (?,?,?,?,?,?)",
          [
            reminder.id,
            reminder.deviceId,
            reminder.deviceAddress,
            reminder.time,
            reminder.connectorId,
            reminder.statusCode
          ]);

  Future deleteReminderInIds(String address, Iterable<int> ids) => database.delete(
      "DELETE FROM charge_warning_reminder WHERE device_address=? AND id IN(?)",
      [address,ids.join(",")]);
}
