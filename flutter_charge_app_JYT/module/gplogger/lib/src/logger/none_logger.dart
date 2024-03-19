import '../level/level.dart';
import 'logger.dart';

class NoneLogger implements Logger {
  const NoneLogger();

  @override
  void debug(message, [error, StackTrace? stackTrace]) {}

  @override
  void error(message, [error, StackTrace? stackTrace]) {}

  @override
  void info(message, [error, StackTrace? stackTrace]) {}

  @override
  void warn(message, [error, StackTrace? stackTrace]) {}

  @override
  bool get isErrorEnabled => false;

  @override
  bool get isWarnEnabled => false;

  @override
  bool get isInfoEnabled => false;

  @override
  bool get isDebugEnabled => false;

  @override
  Level get level => Level.none;

  @override
  String get name => "[NONE]";
}
