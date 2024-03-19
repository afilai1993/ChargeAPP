import 'dart:convert';
import 'dart:io';



import '../../../gplogger.dart';
import '../abstract_appender.dart';

part 'file_appender_policy.dart';

typedef FileNamedGenerator = String Function();
typedef DirectoryProvider = Future<Directory> Function();

class FileAppender extends AbstractAppender {
  final List<FileAppenderPolicy> policyList;
  final FileNamedGenerator fileNamedGenerator;
  final DirectoryProvider directoryProvider;
  final List<LoggingEvent> _messageList = [];
  File? _file;
  bool _writing = false;
  final int filePieceSize;

  FileAppender(
      {required this.fileNamedGenerator,
        required this.directoryProvider,
        required Layout layout,
         this.policyList=const [],
      this.filePieceSize = 10 * 1024 * 1024})
      : super(layout: layout);

  @override
  void doAppend0(LoggingEvent event) {
    _messageList.add(event);
    Future(() async {
      if (_writing) {
        return;
      }
      _writing = true;
      try {
        List<LoggingEvent> writeMessageList;
        do {
          writeMessageList = List.of(_messageList, growable: false);
          _messageList.clear();

          for (var msg in writeMessageList) {
            final logMsg=layout.log(msg).join("\n");
            int spaceSize=utf8.encode(logMsg).length;
            final file = await _getWriteFile(spaceSize);
            for(var p in policyList){
              await p.handle( await directoryProvider.call(), file);
            }
            await file.writeAsString(logMsg, mode: FileMode.append, flush: true);
          }
        } while (_messageList.isNotEmpty);
      } catch (e) {
        print(e);
        //ignore
      } finally {
        _writing = false;
      }


    });
  }

  Future<File> _getWriteFile(int writeLength) async {
    final cacheFile = _file;
    if (cacheFile != null && filePieceSize > 0) {
      final size = await cacheFile.length();
      if (size + writeLength < filePieceSize) {
        return cacheFile;
      }
    }
    final dir = await directoryProvider.call();
    if (!(await dir.exists())) {
      await dir.create(recursive: true);
    }
    _file =
        File("${dir.path}${Platform.pathSeparator}${fileNamedGenerator.call()}");
    return _file!;
  }
}
