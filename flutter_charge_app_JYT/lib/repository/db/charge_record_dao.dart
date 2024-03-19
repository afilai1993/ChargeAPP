import 'package:chargestation/infrastructure/infrastructure.dart';

import '../data/vo.dart';

class ChargeRecordDao {
  final GPDatabase database;

  ChargeRecordDao(this.database);

  Future<ChargeStatisticsVO> getChargeStatistics(String userId) =>
      database.query(
          "SELECT COUNT(charge_record.id) as charge_times,  SUM(charge_record.end_time-charge_record.start_time) as cumulative_time,SUM(charge_record.energy) as total_power FROM charge_record LEFT JOIN user_bind_charge_device on charge_record.device_id=user_bind_charge_device.device_id  WHERE user_bind_charge_device.user_id=? AND charge_record.end_time-charge_record.start_time>=0 ",
          [userId]).then((value) {
        final first = value.firstOrNull;
        if (first == null) {
          return const ChargeStatisticsVO(
              chargeTimes: 0, cumulativeTime: 0, totalPower: 0);
        }
        return ChargeStatisticsVO(
            chargeTimes: first["charge_times"] as int,
            cumulativeTime: (first["cumulative_time"] as int?) ?? 0,
            totalPower: (first["total_power"] as double?) ?? 0);
      });

  Future insertChargeRecord(ChargeRecordPO record) => database.insert(
          "INSERT OR ABORT INTO `charge_record` (`id`,`device_id`,`device_address`,`connector_id`,`start_time`,`end_time`,`energy`,`prices`,`stop_reason`) VALUES (?,?,?,?,?,?,?,?,?)",
          [
            record.id,
            record.deviceId,
            record.deviceAddress,
            record.connectorId,
            record.startTime,
            record.endTime,
            record.energy,
            record.prices,
            record.stopReason
          ]);

  Future<List<ChargeRecordPO>> getChargeRecordList(
          int startTime, int endTime, String address, int limit, int offset) =>
      database.query(
          "SELECT * FROM charge_record WHERE  device_address=? AND start_time>=? AND end_time<=? ORDER by start_time DESC LIMIT ?,?",
          [
            address,
            startTime,
            endTime,
            offset,
            limit,
          ]).then((value) => value.map(ChargeRecordPO.fromDB).toList());

  Future<bool> existChargeRecord(int deviceId, int startTime, int endTime) =>
      database.query(
          "SELECT id FROM charge_record WHERE  device_id=? AND start_time=? AND end_time=?",
          [deviceId, startTime, endTime]).then((value) {
        final first = value.firstOrNull;
        if (first == null) {
          return false;
        }
        return first["id"] != null;
      });

  Future<int?> getRecentlyStartTime(int deviceId) => database.query(
          "SELECT start_time FROM charge_record WHERE  device_id=? ORDER BY start_time DESC LIMIT 1",
          [deviceId]).then((value) {
        final first = value.firstOrNull;
        if (first == null) {
          return null;
        }
        return first["start_time"] as int?;
      });

  Future<int?> getRecentlyEndTime(int deviceId) => database.query(
          "SELECT end_time FROM charge_record WHERE device_id=? ORDER BY end_time DESC LIMIT 1",
          [deviceId]).then((value) {
        final first = value.firstOrNull;
        if (first == null) {
          return null;
        }
        return first["end_time"] as int?;
      });

  Future<List<ChargeStatisticsByDay>> getChargeStatisticsByDate(
    String userId,
    int startTime,
    int endTime,
  ) =>
      database.query(
          "SELECT strftime('%Y-%m-%d', datetime(charge_record.start_time / 1000, 'unixepoch')) AS date_time,SUM(charge_record.energy) as total_power FROM charge_record LEFT JOIN user_bind_charge_device on charge_record.device_id=user_bind_charge_device.device_id  WHERE user_bind_charge_device.user_id=? AND charge_record.start_time>=? AND charge_record.end_time<=? AND charge_record.end_time-charge_record.start_time>=0  GROUP BY date_time",
          [
            userId,
            startTime,
            endTime
          ]).then((value) => value
          .map((e) => ChargeStatisticsByDay((e["date_time"] as String?) ?? "",
              (e["total_power"] as double?) ?? 0))
          .toList());
}
