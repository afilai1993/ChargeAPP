part of '../kv_store.dart';

typedef _ValueObserver = Function(dynamic data);
typedef _ValuesObserver = Function(Map<String, dynamic> data);

class _ValueObserverProvider {
  dynamic value;

  _ValueObserverProvider(this.value);

  Set<_ValueObserver> observers = Set();

  void onChanged(dynamic value) {
    if (this.value != value) {
      this.value = value;
      observers.forEach((element) {
        element.call(value);
      });
    }
  }
}

class _ValuesProviderKey {
  final List<String> keys;

  const _ValuesProviderKey(this.keys);

  factory _ValuesProviderKey.fromList(List<String> keys) =>
      _ValuesProviderKey(List.from(keys)
        ..sort((a, b) {
          if (a.length > b.length) {
            return 1;
          } else if (a.length < b.length) {
            return -1;
          }
          for (var index = 0; index < a.length; index++) {
            final ca = a.codeUnitAt(index);
            final cb = b.codeUnitAt(index);
            if (ca > cb) {
              return 1;
            } else if (ca < cb) {
              return -1;
            }
          }
          return 0;
        }));

  @override
  int get hashCode => keys.join().hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ValuesProviderKey &&
          runtimeType == other.runtimeType &&
          _isEqualsList(keys, other.keys);

  static bool _isEqualsList(List<String> a, List<String> b) {
    if (a.length != b.length) {
      return false;
    }
    for (var index = 0; index < a.length; index++) {
      if (a[index] != b[index]) {
        return false;
      }
    }
    return true;
  }
}

class _ValuesObserverProvider {
  final List<String> keys;
  Map<String, dynamic> data = {};
  Set<_ValuesObserver> observers = Set();

  _ValuesObserverProvider(this.keys, this.data);

  void onChanged(Map<String, dynamic> value) {
    if (_isNotEqualsMap(value, data)) {
      this.data = value;
      observers.forEach((element) {
        element.call(value);
      });
    }
  }

  static bool _isNotEqualsMap(Map<String, dynamic> a, Map<String, dynamic> b) {
    if (a.length != b.length) {
      return true;
    }
    final keys = a.keys.iterator;
    while (keys.moveNext()) {
      final key = keys.current;
      if (a[key] != b[key]) {
        return true;
      }
    }
    return false;
  }

  bool containKey(String key) => keys.contains(key);
}

class JsonStore implements KVDataStore {
  Map<String, dynamic> _cache = {};
  final StoreFileProvider fileProvider;
  final _commandList = <_Command>[const _ReloadCommand()];
  Future? _runCommandFuture;
  final Map<String, _ValueObserverProvider> _observerMap = {};
  final Map<_ValuesProviderKey, _ValuesObserverProvider> _valuesObserverMap =
      {};

  JsonStore(this.fileProvider);

  @override
  Future<T?> asyncGetValue<T>(String key) async {
    await runCommand();
    return _cache[key];
  }

  @override
  Future batchSave(Map<String, dynamic> data) async {
    for (var item in data.entries) {
      _cache[item.key] = item.value;
      _notifyValue(item.key, item.value);
    }
    _commandList.add(_SaveCommand(data));
    await runCommand();
  }

  @override
  Future clear() {
    _cache.clear();
    _notifyAllValue();
    _commandList.add(const _ClearCommand());
    return runCommand();
  }

  @override
  T? getValue<T>(String key) => _cache[key];

  @override
  Map<String, dynamic> getValues(List<String> keys) {
    final result = <String, dynamic>{};
    for (var element in keys) {
      if (_cache[element] != null) {
        result[element] = _cache[element];
      }
    }
    return Map.unmodifiable(result);
  }

  @override
  Future init() {
    return runCommand();
  }

  @override
  Future reload() {
    _commandList.add(const _ReloadCommand());
    return runCommand();
  }

  @override
  Future saveAll(Map<String, dynamic> data) async {
    _cache = data;
    _notifyAllValue();
    _commandList.add(_SaveCommand(data, isBatch: false));
    await runCommand();
  }

  @override
  Future saveValue(String key, value) async {
    _cache[key] = value;
    _notifyValue(key, value);
    _commandList.add(_SaveCommand(<String, dynamic>{key: value}));
    await runCommand();
  }

  @override
  Stream<T?> watchValue<T>(String key) => Stream.multi((controller) {
        controller.add(_cache[key]);
        void onChanged(dynamic data) {
          controller.add(data);
        }

        _addValueObserver(key, onChanged);
        controller.onCancel = () {
          _removeValueObserver(key, onChanged);
        };
        runCommand();
      });

  @override
  Stream<Map<String, dynamic>> watchValues<T>(List<String> keys) =>
      Stream.multi((controller) {
        void onChanged(dynamic data) {
          controller.add(data);
        }

        controller.add(getValues(keys));
        final key = _ValuesProviderKey.fromList(keys);
        _addValuesObserver(key, onChanged);
        controller.onCancel = () {
          _removeValuesObserver(key, onChanged);
        };
        runCommand();
        ;
      });

  Future runCommand() async {
    final runCommandFuture = _runCommandFuture;
    if (runCommandFuture != null) {
      return runCommandFuture;
    }
    return _runCommandFuture = Future(() async {
      var data = Map.of(_cache);
      var reload = false;
      do {
        final actions = List.of(_commandList);
        _commandList.clear();
        if (actions.isNotEmpty) {
          bool commitSave = false;

          for (var command in actions) {
            if (command.type == _CommandType.reload) {
              if (!reload) {
                reload = true;
                data = await _getDiskData();
              }
            } else if (command.type == _CommandType.clear) {
              await _clearDiskData();
              data = {};
              commitSave = false;
            } else if (command is _SaveCommand) {
              commitSave = true;
              if (command.isBatch) {
                for (var entity in command.data.entries) {
                  data[entity.key] = entity.value;
                }
              } else {
                data = command.data;
              }
            }
          }
          if (commitSave) {
            await _saveDataToDisk(data);
          }
        }
      } while (_commandList.isNotEmpty);
      _cache = data;
      if (reload) {
        _notifyAllValue();
      }
      _runCommandFuture = null;
    });
  }

  Future<Map<String, dynamic>> _getDiskData() async {
    final file = await fileProvider();
    if (await file.exists()) {
      final data = await file.readAsString();
      if (data.isEmpty) {
        return {};
      }
      try {
        return json.decode(data);
      } catch (e) {
        return {};
      }
    }
    return {};
  }

  Future _saveDataToDisk(Map<String, dynamic> data) async {
    final file = await fileProvider();
    await file.writeAsString(json.encode(data), flush: true);
  }

  Future _clearDiskData() async {
    final file = await fileProvider();
    if (await file.exists()) {
      await file.writeAsString("{}", flush: true);
    }
  }

  void _notifyValue(String key, dynamic value) {
    _observerMap[key]?.onChanged(_cache[key]);
    _valuesObserverMap.forEach((_, provider) {
      if (provider.containKey(key)) {
        provider.onChanged(getValues(provider.keys));
      }
    });
  }

  void _notifyAllValue() {
    _observerMap.forEach((key, provider) {
      provider.onChanged(_cache[key]);
    });
    _valuesObserverMap.forEach((key, provider) {
      provider.onChanged(getValues(provider.keys));
    });
  }

  void _addValuesObserver(_ValuesProviderKey key, _ValuesObserver observer) {
    final _ValuesObserverProvider provider;
    final cacheProvider = _valuesObserverMap[key];
    if (cacheProvider == null) {
      provider = _ValuesObserverProvider(key.keys, getValues(key.keys));
      _valuesObserverMap[key] = provider;
    } else {
      provider = cacheProvider;
    }
    if (!provider.observers.contains(observer)) {
      provider.observers.add(observer);
    }
  }

  void _removeValuesObserver(_ValuesProviderKey key, _ValuesObserver observer) {
    final provider = _valuesObserverMap[key];
    if (provider == null || provider.observers.isEmpty) {
      return;
    }
    provider.observers.remove(observer);
  }

  void _addValueObserver(String key, _ValueObserver observer) {
    final _ValueObserverProvider provider;
    final cacheProvider = _observerMap[key];
    if (cacheProvider == null) {
      provider = _ValueObserverProvider(_cache[key]);
      _observerMap[key] = provider;
    } else {
      provider = cacheProvider;
    }
    if (!provider.observers.contains(observer)) {
      provider.observers.add(observer);
    }
  }

  void _removeValueObserver(String key, _ValueObserver observer) {
    final provider = _observerMap[key];
    if (provider == null || provider.observers.isEmpty) {
      return;
    }
    provider.observers.remove(observer);
  }
}

enum _CommandType {
  reload,
  clear,
  save,
}

abstract class _Command {
  _CommandType get type;
}

class _ReloadCommand implements _Command {
  @override
  final _CommandType type = _CommandType.reload;

  const _ReloadCommand();
}

class _ClearCommand implements _Command {
  @override
  final _CommandType type = _CommandType.clear;

  const _ClearCommand();
}

class _SaveCommand implements _Command {
  @override
  final _CommandType type = _CommandType.save;
  final Map<String, dynamic> data;
  final bool isBatch;

  _SaveCommand(this.data, {this.isBatch = true});
}
