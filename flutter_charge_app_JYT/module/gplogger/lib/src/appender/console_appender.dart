import '../event/logging_event.dart';
import '../filter/filter.dart';
import '../filter/composite_filter.dart';
import '../layout/layout.dart';
import 'abstract_appender.dart';
import 'appender.dart';

class ConsoleAppender extends AbstractAppender {
  ConsoleAppender({required Layout layout}) : super(layout: layout);

  @override
  void doAppend0(LoggingEvent event) {
    // ignore: avoid_print
    layout.log(event).forEach(print);
  }
}
