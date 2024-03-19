import '../event/logging_event.dart';
export 'pretty_layout.dart';
export 'simple_layout.dart';

///日志布局
abstract class Layout {
  List<String> log(LoggingEvent event);
}
