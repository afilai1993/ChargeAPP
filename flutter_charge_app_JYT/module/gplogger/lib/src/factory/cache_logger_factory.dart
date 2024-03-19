
import '../logger/logger.dart';
import 'logger_factory.dart';

class CacheLoggerFactory implements LoggerFactory {
  final LoggerFactory loggerFactory;
  final _cacheMap = <String, Logger>{};

  CacheLoggerFactory(this.loggerFactory);

  @override
  Logger getLogger(String name) {
    final cache = _cacheMap[name];
    if (cache != null) {
      return cache;
    }
    final created = loggerFactory.getLogger(name);
    _cacheMap[name] = created;
    return created;
  }
}
