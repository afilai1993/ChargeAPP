import 'dart:io';

import 'package:chargestation/repository/store/kv_store.dart';
import 'package:path_provider/path_provider.dart';

final KVDataStore userStore = JsonStore(() => getApplicationSupportDirectory()
    .then((dir) => File("${dir.path}${Platform.pathSeparator}user.json")));

/// 观察登录
Stream<bool> get watchLogin => userStore
    .watchValue<String>("userId")
    .map((event) => event != null && event.isNotEmpty);
