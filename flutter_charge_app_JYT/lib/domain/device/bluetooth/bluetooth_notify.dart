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
static List<int> ReceiveData=[];
  void _listen() {
    _subscription = characteristic.onValueReceived.listen((event) {
      ReceiveData+=event;
      var EndAddr=0;
      EndAddr=event.indexOf(0x23);
      if(EndAddr >= 0)//判断是否有#号结尾
        {
        List<int> JsonData=[];
        JsonData=ReceiveData;
          try {
            final data = DeviceTransferData.parse(ReceiveData);
            // final data = String.fromCharCodes(event);
            _provider.value = data;
            _logger.debug("解析:$data");
          } catch (e, st) {
            _logger.warn("解析失败;$ReceiveData", e, st);
            final String stringData=String.fromCharCodes(ReceiveData);
            _logger.debug("解析失败:$stringData");
          }
          ReceiveData=[];
        }
        else if(ReceiveData.length>512)
         {
           _logger.debug("数据长度超出最大值:$ReceiveData");

           final String stringData=String.fromCharCodes(ReceiveData);
           _logger.debug("数据长度超出最大值:$stringData");
           ReceiveData=[];
         }

    });
  }
}
