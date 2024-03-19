import '../logger/logger.dart';

export 'none_logger_factory.dart';
export 'cache_logger_factory.dart';
export 'logger_factory_impl.dart';
abstract class LoggerFactory {
  Logger getLogger(String name);
}
