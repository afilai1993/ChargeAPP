part of 'bluetooth_charge_device.dart';

class _BluetoothNotify {
  final BluetoothCharacteristic characteristic;
  StreamSubscription<List<int>>? _subscription;
  final _logger = loggerFactory.getLogger("BluetoothNotify");
  final _provider = ValueStreamProvider<Object?>(null);

  _BluetoothNotify._(this.characteristic);

  static Future<_BluetoothNotify> create(
    BluetoothCharacteristic characteristic,
  ) async {
    await characteristic.setNotifyValue(true);
    return _BluetoothNotify._(characteristic).._listen();
  }

  void cancel() {
    _subscription?.cancel();
  }

  Stream<Object?> get stream => _provider.createStream(currentGet: false);

  void _listen() {
    _subscription = characteristic.onValueReceived.listen((event) {
      try {
        final data = DeviceTransferData.parse(event);
        _provider.value = data;
        _logger.debug("解析:$data");
      } catch (e, st) {
        _logger.warn("解析失败;$event", e, st);
      }
    });
  }
}
