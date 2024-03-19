import 'dart:async';

import 'package:chargestation/design.dart';

abstract class AutoDispose {
  T addDispose<T extends Disposable>(T dispose);

  void removeDispose(Disposable dispose);
}

abstract class Disposable {
  void dispose();
}

class AutoDisposeDelegate implements AutoDispose {
  final List<Disposable> _disposedList = [];

  @override
  T addDispose<T extends Disposable>(T dispose) {
    if (!_disposedList.contains(dispose)) {
      _disposedList.add(dispose);
    }
    return dispose;
  }

  @override
  void removeDispose(Disposable dispose) {
    dispose.dispose();
    _disposedList.remove(dispose);
  }

  void dispose() {
    for (final dispose in _disposedList) {
      dispose.dispose();
    }
    _disposedList.clear();
  }
}

mixin StateAutoDisposeOwner<T extends StatefulWidget> on State<T>
    implements AutoDispose {
  final AutoDisposeDelegate _autoDisposeDelegate = AutoDisposeDelegate();

  @override
  D addDispose<D extends Disposable>(D dispose) =>
      _autoDisposeDelegate.addDispose(dispose);

  @override
  void removeDispose(Disposable dispose) {
    _autoDisposeDelegate.removeDispose(dispose);
  }

  @mustCallSuper
  @override
  void dispose() {
    _autoDisposeDelegate.dispose();
    super.dispose();
  }
}

extension ListenableExtension on Listenable {
  addListenerInDispose(AutoDispose dispose, VoidCallback callback) {
    addListener(callback);
    dispose.addDispose(_ListenableDisposable(this, callback));
  }
}

extension StreamSubscriptionExtension<T> on StreamSubscription<T> {
  bind(AutoDispose dispose) {
    dispose.addDispose(_StreamSubscriptionDisposable(this));
    return this;
  }
}

extension TapGestureRecognizerExtension on TapGestureRecognizer {
  TapGestureRecognizer autoDispose(AutoDispose dispose) {
    dispose.addDispose(_AnyDisposable(this));
    return this;
  }
}

class _StreamSubscriptionDisposable<T> implements Disposable {
  final StreamSubscription<T> streamSubscription;

  _StreamSubscriptionDisposable(this.streamSubscription);

  @override
  void dispose() {
    streamSubscription.cancel();
  }
}

class _ListenableDisposable implements Disposable {
  final VoidCallback callback;
  final Listenable listenable;

  _ListenableDisposable(this.listenable, this.callback);

  @override
  void dispose() {
    listenable.removeListener(callback);
  }
}

class _AnyDisposable implements Disposable {
  final dynamic any;

  _AnyDisposable(this.any);

  @override
  void dispose() {
    any.dispose();
  }
}
