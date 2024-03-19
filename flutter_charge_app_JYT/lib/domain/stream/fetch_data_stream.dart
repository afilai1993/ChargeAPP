part of 'fetch_data_stream_factory.dart';

abstract class FetchDataKey {}

final FetchDataStreamStore fetchDataStreamStore =
    FetchDataStreamStore(serviceEventBus);

class FetchDataStreamStore {
  final Map<FetchDataKey, FetchDataStream> _activeKeyStreams = {};
  final HashSet<FetchDataKey> _keysPendingRemoval = HashSet<FetchDataKey>();
  final EventBus eventBus;

  FetchDataStreamStore(this.eventBus);

  bool _isShuttingDown = false;

  // we track pending timers since Flutter throws an exception when timers
  // remain after a test run.
  final Set<Completer> _pendingTimers = {};

  /// Creates a new stream from the select statement.
  Stream<T> registerStream<T>(FetchDataKey key,
      {required Future<T> Function() fetchData,
      bool Function(Event event)? where}) {
    final cached = _activeKeyStreams[key];
    if (cached != null) {
      // _logger.debug("provider cache stream->$key");
      return cached.stream as Stream<T>;
    }
    // no cached instance found, create a new stream and register it so later
    // requests with the same key can be cached.
    final stream =
        FetchDataStream<T>(this, key, fetchData: fetchData, where: where);
    // todo this adds the stream to a map, where it will only be removed when
    // somebody listens to it and later calls .cancel(). Failing to do so will
    // cause a memory leak. Is there any way we can work around it? Perhaps a
    // weak reference with an Expando could help.
    markAsOpened(stream);
    //  _logger.debug("provider new stream->$key");
    return stream.stream;
  }

  void markAsOpened(FetchDataStream stream) {
    final key = stream.key;
    _keysPendingRemoval.remove(key);
    _activeKeyStreams[key] = stream;
  }

  void markAsClosed(FetchDataStream stream, Function() whenRemoved) {
    if (_isShuttingDown) return;

    final key = stream.key;
    _keysPendingRemoval.add(key);

    // sync because it's only triggered after the timer
    final completer = Completer<void>.sync();
    _pendingTimers.add(completer);

    // Hey there! If you're sent here because your Flutter tests fail, please
    // call and await Database.close() in your Flutter widget tests!
    // Drift uses timers internally so that after you stopped listening to a
    // stream, it can keep its cache just a bit longer. When you listen to
    // streams a lot, this helps reduce duplicate statements, especially with
    // Flutter's StreamBuilder.
    Timer.run(() {
      completer.complete();
      _pendingTimers.remove(completer);

      // if no other subscriber was found during this event iteration, remove
      // the stream from the cache.
      if (_keysPendingRemoval.contains(key)) {
        _keysPendingRemoval.remove(key);
        _activeKeyStreams.remove(key);
        whenRemoved();
      }
    });
  }
}

class FetchDataStream<T> {
  final FetchDataStreamStore store;
  final FetchDataKey key;
  final Future<T> Function() fetchData;
  final List<_StreamListener> listeners = [];
  final bool Function(Event event)? where;

  int pausedListeners = 0;

  int get _activeListeners => listeners.length - pausedListeners;
  bool isClosed = false;
  StreamSubscription? streamSubscription;
  T? lastData;
  final List<CancellationToken<T>> _runningOperations = [];

  FetchDataStream(this.store, this.key, {required this.fetchData, this.where});

  late final Stream<T> stream = Stream.multi(
    (listener) {
      final queryListener = _StreamListener(listener);

      if (isClosed) {
        listener.closeSync();
        return;
      }

      // When this callback is called we have a new listener, so invoke the
      // handler now.
      listeners.add(queryListener);
      onListenOrResume(queryListener);

      listener
        ..onPause = () {
          assert(!queryListener.isPaused);
          queryListener.isPaused = true;
          pausedListeners++;

          onCancelOrPause();
        }
        ..onCancel = () {
          if (queryListener.isPaused) {
            pausedListeners--;
          }

          listeners.remove(queryListener);
          onCancelOrPause();
        }
        ..onResume = () {
          assert(queryListener.isPaused);
          queryListener.isPaused = false;
          pausedListeners--;

          onListenOrResume(queryListener);
        };
    },
    isBroadcast: true,
  );

  void onListenOrResume(_StreamListener newListener) {
    // First listener, start fetching data
    store.markAsOpened(this);

    // fetch new data whenever any table referenced in this stream updates.
    // It could be that we have an outstanding subscription when the
    // stream was closed but another listener attached quickly enough. In that
    // case we don't have to re-send the query
    if (streamSubscription == null) {
      // first listener added, fetch query
      fetchAndEmitData();

      streamSubscription = store.eventBus.stream(where: where).listen((event) {
        lastData = null;
        // It could be that we have no active, but some paused listeners. In
        // that case, we still want to invalidate cached data but there's no
        // point in fetching new data now. We'll load the query again after
        // a listener unpauses.
        if (_activeListeners > 0) {
          //  _logger.debug("activeListeners=>stream new data");
          fetchAndEmitData();
        }
      });
    } else if (lastData == null) {
      if (_runningOperations.isEmpty) {
        // _logger.debug("_runningOperations => stream new data");
        // We have a new listener, no cached data and we're not in the process
        // of fetching data either. Let's run the query then!
        fetchAndEmitData();
      }
    } else {
      // _logger.debug("stream cache data");
      // Push the current snapshot of pending data to the listener
      newListener.add(lastData!);
    }
  }

  void onCancelOrPause() {
    if (listeners.isEmpty) {
      // Last listener has stopped listening properly (not just a pause)
      store.markAsClosed(this, () {
        streamSubscription?.cancel();

        // we don't listen for table updates anymore, and we're guaranteed to
        // re-fetch data after a new listener comes in. We can't know if the
        // table was updated in the meantime, but let's delete the cached data
        // just in case.
        lastData = null;
        streamSubscription = null;
        for (final op in _runningOperations) {
          op.cancel();
        }
      });
    }
  }

  Future<void> fetchAndEmitData() async {
    final operation = runCancellable<T>(fetchData);
    _runningOperations.add(operation);

    try {
      final data = await operation.resultOrNullIfCancelled;
      if (data == null) return;

      lastData = data;
      for (final listener in listeners) {
        if (!listener.isPaused) {
          listener.add(data);
        }
      }
    } catch (e, s) {
      for (final listener in listeners) {
        if (!listener.isPaused) {
          listener.controller.addError(e, s);
        }
      }
    } finally {
      _runningOperations.remove(operation);
    }
  }

  void close() {
    isClosed = true;
    for (final listener in listeners) {
      listener.controller.close();
    }
    listeners.clear();
  }
}

class _StreamListener<T> {
  final MultiStreamController<T> controller;

  T? lastEvent;
  bool isPaused = false;

  _StreamListener(this.controller);

  void add(T row) {
    // Don't emit events that have already been dispatched to this listener.
    if (!identical(row, lastEvent)) {
      lastEvent = row;
      controller.add(row);
    }
  }
}
