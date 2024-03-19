import '../appender/appender.dart';
import '../event/logging_event.dart';
import '../level/level.dart';
import 'logger.dart';

class LoggerImpl implements Logger {
  @override
  final Level level;
  @override
  final String name;
  final List<Appender> appenderList;

  LoggerImpl(
      {required this.level, required this.name, required this.appenderList});

  @override
  void debug(message, [error, StackTrace? stackTrace]) {
    if (isDebugEnabled) {
      log(Level.debug, message, error, stackTrace);
    }
  }

  @override
  void info(message, [error, StackTrace? stackTrace]) {
    if (isInfoEnabled) {
      log(Level.info, message, error, stackTrace);
    }
  }

  @override
  void warn(message, [error, StackTrace? stackTrace]) {
    if (isWarnEnabled) {
      log(Level.warn, message, error, stackTrace);
    }
  }

  @override
  void error(message, [error, StackTrace? stackTrace]) {
    if (isErrorEnabled) {
      log(Level.error, message, error, stackTrace);
    }
  }

  @override
  bool get isDebugEnabled => level.index >= Level.debug.index;

  @override
  bool get isErrorEnabled => level.index >= Level.error.index;

  @override
  bool get isInfoEnabled => level.index >= Level.info.index;

  @override
  bool get isWarnEnabled => level.index >= Level.warn.index;

  void log(Level level, dynamic message,
      [dynamic error, StackTrace? stackTrace]) {
    if (appenderList.isEmpty) {
      return;
    }
    final logEvent = LoggingEvent(name, level, message, error, stackTrace);
    for (var appender in appenderList) {
      appender.doAppend(logEvent);
    }
  }
}
