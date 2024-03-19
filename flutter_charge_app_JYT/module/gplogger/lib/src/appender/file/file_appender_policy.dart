part of 'file_appender.dart';

abstract class FileAppenderPolicy {
  Future handle(Directory dir, File current);
}

class TimeFileAppenderPolicy implements FileAppenderPolicy {
  final int maxHistory;

  TimeFileAppenderPolicy(this.maxHistory);

  @override
  Future handle(Directory dir, File current) {
    final minTime = DateTime.now().millisecondsSinceEpoch - maxHistory;
    return Future.wait((dir.listSync()
      ..removeWhere((element) => element is! File))
        .cast<File>()
        .map((e) async {
      final time = (await e.lastModified()).millisecondsSinceEpoch;
      if (time < minTime) {
        await e.delete();
      }
    }));
  }
}