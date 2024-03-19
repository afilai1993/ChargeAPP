

import '../event/logging_event.dart';

abstract class Filter {
  bool isFilter(LoggingEvent event);
}
