import 'dart:async';
import 'dart:collection';

import 'package:chargestation/domain/eventbus/eventbus.dart';
import 'package:chargestation/infrastructure/infrastructure.dart';

import 'cancellation.dart';

part 'fetch_data_stream.dart';

abstract class EventHandler {
  bool handle(Event event);
}

class BeanMethodFetchKey implements FetchDataKey {
  final Type beanType;
  final Type methodType;
  final dynamic arguments;

  BeanMethodFetchKey(
      {required this.beanType, required this.methodType, this.arguments});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BeanMethodFetchKey &&
          runtimeType == other.runtimeType &&
          beanType == other.beanType &&
          methodType == other.methodType &&
          arguments == other.arguments;

  @override
  int get hashCode =>
      beanType.hashCode ^ methodType.hashCode ^ arguments.hashCode;
}

class RepositoryDataFetchKey implements FetchDataKey {
  final FetchDataKey fetchDataKey;

  RepositoryDataFetchKey({required this.fetchDataKey});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepositoryDataFetchKey &&
          runtimeType == other.runtimeType &&
          fetchDataKey == other.fetchDataKey;

  @override
  int get hashCode => fetchDataKey.hashCode;
}

Stream<T> createDataStream<T>(
        {required FetchDataKey key,
        bool Function(Event event)? where,
        required Future<T> Function() fetchData}) =>
    Stream.multi(RepositoryDataFetch(
            fetchDataKey: key, fetchData: fetchData, where: where)
        .listener);

class RepositoryDataFetch<T> {
  final Future<T> Function() fetchData;
  final FetchDataKey fetchDataKey;
  final bool Function(Event event)? where;
  StreamSubscription<T>? _dataSubscription;
  StreamSubscription<dynamic>? _userSubscription;

  RepositoryDataFetch(
      {required this.fetchDataKey, required this.fetchData, this.where});

  void listener(MultiStreamController<T> controller) {
    _userSubscription = userStore.watchValue<String>("userId").listen((event) {
      _subscribeData(controller);
    });
    controller.onCancel = () {
      _userSubscription?.cancel();
      _dataSubscription?.cancel();
    };
  }

  void _subscribeData(MultiStreamController<T> controller) {
    _dataSubscription?.cancel();
    _dataSubscription = fetchDataStreamStore
        .registerStream(
            RepositoryDataFetchKey(
              fetchDataKey: fetchDataKey,
            ),
            fetchData: () => fetchData.call(),
            where: where)
        .listen((event) {
      controller.add(event);
    });
  }
}
