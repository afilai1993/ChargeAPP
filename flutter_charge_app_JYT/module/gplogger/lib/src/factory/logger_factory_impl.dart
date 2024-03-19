import '../appender/appender.dart';
import '../level/level.dart';
import '../logger/logger.dart';
import '../logger/logger_impl.dart';
import 'logger_factory.dart';

class LoggerFactoryImpl implements LoggerFactory {
  final List<Appender> appenderList;
  final Level level;

  LoggerFactoryImpl({
    required this.appenderList,
    this.level = Level.debug,
  });

  @override
  Logger getLogger(String name) {
    return LoggerImpl(name: name, level: level, appenderList: appenderList);
  }
}
