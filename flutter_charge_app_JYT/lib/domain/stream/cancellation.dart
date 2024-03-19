import 'dart:async';

const _key = #weimu.framework.runtime.cancellation;

CancellationToken<T> runCancellable<T>(
    Future<T> Function() operation,
    ) {
  final token = CancellationToken<T>();
  runZonedGuarded(
        () => operation().then(token._resultCompleter.complete),
    token._resultCompleter.completeError,
    zoneValues: {_key: token},
  );

  return token;
}

class CancellationException implements Exception {
  /// Default const constructor
  const CancellationException();

  @override
  String toString() {
    return 'Operation was cancelled';
  }
}

extension NonNullableCancellationExtension<T>
on CancellationToken<T> {
  /// Wait for the result, or return `null` if the operation was cancelled.
  ///
  /// To avoid situations where `null` could be a valid result from an async
  /// operation, this getter is only available on non-nullable operations. This
  /// avoids ambiguity.
  ///
  /// The future will still complete with an error if anything but a
  /// [CancellationException] is thrown in [result].
  Future<T?> get resultOrNullIfCancelled async {
    try {
      return await result;
    } on CancellationException {
      return null;
    }
  }
}

class CancellationToken<T> {
  final Completer<T> _resultCompleter = Completer.sync();
  final List<void Function()> _cancellationCallbacks = [];
  bool _cancellationRequested = false;

  /// Loads the result for the cancellable operation.
  ///
  /// When a cancellation has been requested and was honored, the future will
  /// complete with a [CancellationException].
  Future<T> get result => _resultCompleter.future;

  /// Requests the inner asynchronous operation to be cancelled.
  void cancel() {
    if (_cancellationRequested) return;

    for (final callback in _cancellationCallbacks) {
      callback();
    }
    _cancellationRequested = true;
  }
}
