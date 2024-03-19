import '../event/logging_event.dart';
import '../filter/filter.dart';
import '../filter/composite_filter.dart';
import '../layout/layout.dart';
import 'appender.dart';

abstract class AbstractAppender extends Appender {
  final CompositeFilter filters = CompositeFilter();
  final Layout layout;

  AbstractAppender({required this.layout});

  @override
  void addFilter(Filter filter) {
    filters.addFilter(filter);
  }

  @override
  void doAppend(LoggingEvent event) {
    if (filters.isFilter(event)) {
      return;
    }
    doAppend0(event);
  }

  void doAppend0(LoggingEvent event);
}
