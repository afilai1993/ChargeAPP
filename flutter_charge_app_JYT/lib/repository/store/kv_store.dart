import 'dart:convert';
import 'dart:io';

part 'impl/json_kv_store.dart';


typedef StoreFileProvider = Future<File> Function();

abstract class KVDataStore {
  ///保存值
  Future saveValue(String key, dynamic value);

  ///获取缓存值
  T? getValue<T>(String key);

  ///异步获取缓存值
  Future<T?> asyncGetValue<T>(String key);

  /// 观察某个值
  Stream<T?> watchValue<T>(String key);

  /// 获取指定的keys的值
  Map<String, dynamic> getValues(List<String> keys);

  /// 观察指定的keys的值
  Stream<Map<String, dynamic>> watchValues<T>(List<String> keys);

  /// 清空
  Future clear();

  /// 保存所有的数据
  Future saveAll(Map<String, dynamic> data);

  /// 差量更新数据
  Future batchSave(Map<String, dynamic> data);

  /// 初始化缓存
  Future init();

  /// 重载数据
  Future reload();
}
