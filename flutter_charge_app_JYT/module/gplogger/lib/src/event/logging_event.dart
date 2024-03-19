



import '../level/level.dart';

class LoggingEvent {
  final String? name;
  final Level level;
  final dynamic message;
  final dynamic error;
  final StackTrace? stackTrace;

  LoggingEvent(this.name, this.level, this.message, this.error, this.stackTrace);
}