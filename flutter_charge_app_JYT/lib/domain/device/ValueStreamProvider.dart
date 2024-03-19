
class ValueStreamProvider<T> {
  T _value;

  final List<Function()> _listeners = [];

  ValueStreamProvider(this._value);

  T get value => _value;

  set value(T value) {
    if (_value != value) {
      _value = value;
      _notifyListeners();
    }
  }

  void _notifyListeners() {
    for (var item in _listeners) {
      item();
    }
  }

  Stream<T> get stream => createStream();

  Stream<T> createStream({bool currentGet = true}) =>
      Stream.multi((controller) {
        if (currentGet) {
          controller.add(_value);
        }
        void onChanged() {
          controller.add(_value);
        }

        if (!_listeners.contains(onChanged)) {
          _listeners.add(onChanged);
        }

        controller.onCancel = () {
          _listeners.remove(onChanged);
        };
      });
}
