import 'dart:io';

import 'package:chargestation/infrastructure/file_factory.dart';
import 'package:chargestation/infrastructure/infrastructure.dart';
import 'package:flutter/foundation.dart';
import 'package:gplogger/gplogger.dart';
import 'package:path_provider/path_provider.dart';

export 'package:gplogger/gplogger.dart';

LoggerFactory loggerFactory = _create();
DateFormat _dataFormat = DateFormat("yyyyMMddHHmmss");

LoggerFactory _create() {
  if (kReleaseMode) {
    return CacheLoggerFactory(
        LoggerFactoryImpl(appenderList: [createFileAppender()]));
  } else {
    return CacheLoggerFactory(LoggerFactoryImpl(
      level: Level.debug,
      appenderList: [
        ConsoleAppender(
            layout: SimpleLayout()),
        createFileAppender()
      ],
    ));
  }
}

Appender createFileAppender() {
  return FileAppender(
      fileNamedGenerator: () {
        return "${_dataFormat.format(DateTime.now())}.log";
      },
      policyList: [
        TimeFileAppenderPolicy(const Duration(days: 3).inMilliseconds)
      ],
      directoryProvider: () => getLogDir(),
      layout: SimpleLayout());
}
