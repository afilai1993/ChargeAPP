import '../event/logging_event.dart';
import '../filter/filter.dart';

export 'console_appender.dart';
export 'file/file_appender.dart';
/// 日志载入
abstract class Appender {
  ///过滤器
  void addFilter(Filter filter);

  /// 执行事件
  void doAppend(LoggingEvent event);
}
