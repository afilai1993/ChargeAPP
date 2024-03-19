
import '../event/logging_event.dart';
import 'filter.dart';

class CompositeFilter implements Filter {
  final List<Filter> filters = [];

  void addFilter(Filter filter) {
    filters.add(filter);
  }

  @override
  bool isFilter(LoggingEvent event) {
    if (filters.isEmpty) {
      return false;
    }
    for (var f in filters) {
      if (f.isFilter(event)) {
        return true;
      }
    }
    return false;
  }
}
