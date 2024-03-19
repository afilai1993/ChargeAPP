import '../../gplogger.dart';
import '../logger/logger.dart';
import '../logger/none_logger.dart';
import 'logger_factory.dart';

class NoneLoggerFactory implements LoggerFactory {
  const NoneLoggerFactory();

  @override
  Logger getLogger(String name) => const NoneLogger();
}
