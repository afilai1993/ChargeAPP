import 'dart:async';
import 'dart:io';
import 'package:chargestation/infrastructure/infrastructure.dart';
import 'package:chargestation/repository/db/charge_device_gun_dao.dart';
import 'package:chargestation/repository/db/user_bind_charge_device_dao.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:sqflite/sqflite.dart' as sqflite;


export 'charge_device_dao.dart';
export 'user_bind_charge_device_dao.dart';
export 'charge_record_dao.dart';
export 'charge_warning_reminder_dao.dart';
export 'charge_timer_dao.dart';

class UserDatabase {
  final GPDatabase database = GPDatabase();
  ChargeDeviceDao? _chargeDeviceDao;
  UserBindChargeDeviceDao? _userBindChargeDeviceDao;
  ChargeDeviceGunDao? _chargeDeviceGunDao;
  ChargeRecordDao? _chargeRecordDao;
  ChargeWarningReminderDao? _chargeWarningReminderDao;
  ChargeTimerDao? _chargeTimerDao;
  static final UserDatabase instance = UserDatabase._();

  UserDatabase._();

  ChargeDeviceDao get chargeDeviceDao {
    final current = _chargeDeviceDao;
    if (current != null) {
      return current;
    }
    final created = ChargeDeviceDao(database);
    _chargeDeviceDao = created;
    return created;
  }

  UserBindChargeDeviceDao get userBindChargeDeviceDao {
    final current = _userBindChargeDeviceDao;
    if (current != null) {
      return current;
    }
    final created = UserBindChargeDeviceDao(database);
    _userBindChargeDeviceDao = created;
    return created;
  }

  ChargeDeviceGunDao get chargeDeviceGunDao {
    final current = _chargeDeviceGunDao;
    if (current != null) {
      return current;
    }
    final created = ChargeDeviceGunDao(database);
    _chargeDeviceGunDao = created;
    return created;
  }

  ChargeRecordDao get chargeRecordDao {
    final current = _chargeRecordDao;
    if (current != null) {
      return current;
    }
    final created = ChargeRecordDao(database);
    _chargeRecordDao = created;
    return created;
  }

  ChargeWarningReminderDao get chargeWarningReminderDao {
    final current = _chargeWarningReminderDao;
    if (current != null) {
      return current;
    }
    final created = ChargeWarningReminderDao(database);
    _chargeWarningReminderDao = created;
    return created;
  }

  ChargeTimerDao get chargeTimerDao {
    final current = _chargeTimerDao;
    if (current != null) {
      return current;
    }
    final created = ChargeTimerDao(database);
    _chargeTimerDao = created;
    return created;
  }
}

class GPDatabase {
  sqflite.Database? _database;
  Completer<sqflite.Database>? _completer;

  GPDatabase();

  Future<int> insert(String sql, [List<Object?>? arguments]) =>
      _getDatabase().then((value) => value.rawInsert(sql, arguments));

  Future<int> update(String sql, [List<Object?>? arguments]) =>
      _getDatabase().then((value) => value.rawUpdate(sql, arguments));

  Future<List<Map<String, Object?>>> query(String sql,
          [List<Object?>? arguments]) =>
      _getDatabase().then((value) => value.rawQuery(sql, arguments));


  Future<int> delete(String sql,
      [List<Object?>? arguments]) =>
      _getDatabase().then((value) => value.rawDelete(sql, arguments));

  Future<sqflite.Database> _getDatabase() async {
    final current = _database;
    if (current != null) {
      return current;
    }
    final asyncCurrent = _completer;
    if (asyncCurrent != null) {
      return asyncCurrent.future;
    }
    final asyncCreate = Completer<sqflite.Database>();
    _completer = asyncCreate;
    loadDatabase();
    return asyncCreate.future;
  }

  loadDatabase() async {
    final database = await sqflite.openDatabase("data.db",
        version: 1, onConfigure: _onConfigure, onCreate: _onCreate);
    _database = database;
    final Completer<sqflite.Database>? completer = _completer;
    if (completer != null) {
      completer.complete(database);
    }
  }

  FutureOr<void> _onConfigure(sqflite.Database db) async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      final sdkVersion = androidInfo.version.sdkInt;
      if (sdkVersion == 28) {
        //Android9.0默认使用wal模式，会导致无法与其他设备，所以主动设置为TRUNCATE
        await db.query("PRAGMA journal_mode=TRUNCATE;");
      }
    }
  }

  Future<void> _onCreate(sqflite.Database db, int version) async {
    final batch = db.batch();
    batch.execute(
        "CREATE TABLE IF NOT EXISTS `user_bind_charge_device` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `sn` TEXT NOT NULL, `user_id` TEXT NOT NULL, `device_id` INTEGER NOT NULL, `device_address` TEXT NOT NULL, `key` TEXT NOT NULL)");
    batch.execute(
        "CREATE TABLE IF NOT EXISTS `charge_device` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `sn` TEXT NOT NULL, `device_type` INTEGER NOT NULL, `address` TEXT NOT NULL, `charge_times` INTEGER NOT NULL, `cumulative_time` INTEGER NOT NULL, `total_power` INTEGER NOT NULL, `s_version` TEXT NOT NULL, `h_version` TEXT NOT NULL)");
    batch.execute(
        "CREATE TABLE IF NOT EXISTS `charge_device_gun` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `device_id` INTEGER NOT NULL, `device_address` TEXT NOT NULL, `current` INTEGER NOT NULL, `mini_current` INTEGER NOT NULL, `connector_id` INTEGER NOT NULL, `max_current` INTEGER NOT NULL, `pnc_status` INTEGER NOT NULL)");
    batch.execute(
        "CREATE TABLE IF NOT EXISTS `charge_time_task` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `task_name` TEXT NOT NULL, `device_id` INTEGER NOT NULL, `device_address` TEXT NOT NULL, `start_date` INTEGER NOT NULL, `end_date` INTEGER NOT NULL, `device_name` TEXT NOT NULL, `start_time` INTEGER NOT NULL, `end_time` INTEGER NOT NULL, `current` INTEGER NOT NULL, `loop` TEXT NOT NULL, `reminder` INTEGER NOT NULL, `open` INTEGER NOT NULL, `unique_no` TEXT NOT NULL, `connector_id` INTEGER NOT NULL, `version` INTEGER NOT NULL)");
    batch.execute(
        "CREATE TABLE IF NOT EXISTS `charge_record` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `device_id` INTEGER NOT NULL, `device_address` TEXT NOT NULL, `connector_id` INTEGER, `start_time` INTEGER NOT NULL, `end_time` INTEGER NOT NULL, `energy` REAL NOT NULL, `prices` TEXT NOT NULL, `stop_reason` TEXT NOT NULL)");
    batch.execute(
        "CREATE TABLE IF NOT EXISTS `charge_warning_reminder` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `device_id` INTEGER NOT NULL, `device_address` TEXT NOT NULL, `time` INTEGER NOT NULL, `connector_id` INTEGER NOT NULL, `status_code` INTEGER NOT NULL)");
    batch.execute(
        "CREATE TABLE IF NOT EXISTS room_master_table (id INTEGER PRIMARY KEY,identity_hash TEXT)");
    batch.execute(
        "INSERT OR REPLACE INTO room_master_table (id,identity_hash) VALUES(42, '450a4cd5049f35fbf60b23e955b2ddb8')");
    await batch.commit(noResult: true);
  }
}
