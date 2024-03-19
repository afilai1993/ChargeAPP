import 'dart:io';

import 'package:chargestation/infrastructure/infrastructure.dart';
import 'package:path_provider/path_provider.dart';

Future<Directory> getLogDir() {
  return getTemporaryDirectory().then((value) async {
    final dir = Directory("${value.path}${Platform.pathSeparator}log");
    if (!(await dir.exists())) {
      await dir.create(recursive: true);
    }
    return dir;
  });
}

Future<File> getShareLogFile() {
  return getTemporaryDirectory().then((value) async {
    final dir = Directory("${value.path}${Platform.pathSeparator}pack");
    if (!(await dir.exists())) {
      await dir.create(recursive: true);
    }
    File file = File(
        "${dir.path}${Platform.pathSeparator}share_log_${DateFormat("yyyyMMddHHmmss").format(DateTime.now())}.zip");
    if (!(await file.exists())) {
      file.createSync();
    }
    return file;
  });
}
