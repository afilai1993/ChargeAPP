

import '../event/logging_event.dart';
import '../level/level.dart';
import 'layout.dart';

class SimpleLayout implements Layout {
  @override
  List<String> log(LoggingEvent event) {
    final List<String> result = [];
    final StringBuffer sb = StringBuffer();
    sb.write(getTime());
    sb.write(" ");
    final name = event.name;
    if (name != null && name.isNotEmpty) {
      sb.write(name);
      sb.write(" ");
    }
    sb.write(_getLevelLabel(event));
    sb.write(" ");
    sb.write(event.message);
    result.add(sb.toString());
    if (event.error != null) {
      result.add(event.error.toString());
    }
    if (event.stackTrace != null) {
      sb.write(event.stackTrace.toString());
    }
    return result;
  }

  String getTime() {
    final date = DateTime.now();
    return "${date.year}-${date.month.toString().padLeft(2, "0")}-${date.day.toString().padLeft(2, "0")} ${date.hour.toString().padLeft(2, "0")}:${date.minute.toString().padLeft(2, "0")}:${date.second.toString().padLeft(2, "0")}:${date.millisecond.toString().padLeft(3, "0")}";
  }

  String _getLevelLabel(LoggingEvent event) {
    switch (event.level) {
      case Level.warn:
        return "[WARN]";
      case Level.error:
        return "[ERROR]";
      case Level.info:
        return "[INFO]";
      case Level.debug:
        return "[DEBUG]";
      case Level.none:
        return "";
    }
  }
}
