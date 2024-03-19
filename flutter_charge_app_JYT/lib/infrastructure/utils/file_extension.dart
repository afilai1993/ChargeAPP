import 'dart:convert';
import 'dart:io';

extension FileExtension on File {
  /// 获取文件的名字
  String get name {
    final path = this.path;
    final pathParts = path.split(Platform.pathSeparator);
    if (pathParts.isNotEmpty) {
      return pathParts[pathParts.length - 1];
    }
    return path;
  }

  /// 获取扩展名
  String get ext {
    final nameParts = path.split(".");
    if (nameParts.isNotEmpty) {
      return nameParts[nameParts.length - 1];
    }
    return "";
  }

  /// 是否不存在
  Future<bool> isNotExist() => exists().then((value) => !value);

  Future<bool> anyDelete({bool recursive = false}) async {
    if (await exists()) {
      await delete(recursive: recursive);
      return true;
    }
    return false;
  }

  ///读取json字符串
  Future<T> readJson<T>(T Function(dynamic json) jsonConvertor) async {
    if (await exists()) {
      final data = await readAsString();
      if (data.isEmpty) {
        return jsonConvertor(null);
      }
      return jsonConvertor(json.decode(data));
    }
    return jsonConvertor(null);
  }
}

extension AsyncFileExtension on Future<File> {
  /// 是否不存在
  Future<bool> isNotExist() => then((value) => value.isNotExist());

  /// 删除文件
  Future<bool> delete({bool recursive = false}) =>
      then((value) => value.anyDelete(recursive: recursive));

  ///读取json字符串
  Future<T> readJson<T>(T Function(dynamic json) jsonConvertor) =>
      then((value) => value.readJson(jsonConvertor));
}