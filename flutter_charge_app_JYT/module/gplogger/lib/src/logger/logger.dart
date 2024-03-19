import '../level/level.dart';
export 'logger_impl.dart';

abstract class Logger {
  Level get level;

  ///Log a message at the DEBUG level.
  void debug(dynamic message, [dynamic error, StackTrace? stackTrace]);

  ///Log a message at the INFO level.
  void info(dynamic message, [dynamic error, StackTrace? stackTrace]);

  ///Log a message at the WARN level.
  void warn(dynamic message, [dynamic error, StackTrace? stackTrace]);

  ///Log a message at the ERROR level.
  void error(dynamic message, [dynamic error, StackTrace? stackTrace]);

  /// Is the logger instance enabled for the DEBUG level?
  bool get isDebugEnabled;

  ///Is the logger instance enabled for the ERROR level?
  bool get isInfoEnabled;

  ///Is the logger instance enabled for the WARN level?
  bool get isWarnEnabled;

  ///Is the logger instance enabled for the ERROR level?
  bool get isErrorEnabled;

  String get name;
}
