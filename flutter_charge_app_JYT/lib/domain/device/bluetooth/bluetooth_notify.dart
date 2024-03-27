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
          if(ReceiveData[0]==123)
            {
              String jsonData="";
              jsonData=String.fromCharCodes(ReceiveData);
              try {
                if(jsonData.contains(",\"chargingTime\":\""))
                  {
                    jsonData=jsonData.replaceAll("}}}#", '},"Temperature1":"37.0","Temperature2":"37.0"}}#');
                  }
                jsonData=jsonData.replaceAll("AT+CWJAP?", "");
                jsonData=jsonData.replaceAll("\",\"recordType\":\"charge\",\"recordDetails\":{\"chargeId\":", "\",\"recordType\":\"Charge\",\"recordDetails\":{\"chargeId\":");
                jsonData=jsonData.replaceAll(",\"duration\":0,\"energy\":\"0.00\",\"stopreason\":\"local\",\"errorCode\":0}}}", ',"endTime":"2024-03-21T09:04:08Z","energy":"0.00000","prices":"0USD","stopReason":"app"}}}');
                jsonData=jsonData.replaceAll("\"connectorStatus\":0", "\"connectorStatus\":\"wait\"");
                jsonData=jsonData.replaceAll("\"PncStatus\":false", "\"PncStatus\":4");
                jsonData=jsonData.replaceAll("\"loadbalance\":0", "\"loadbalance\":false");
                jsonData=jsonData.replaceAll("\"evseType\":\"NA\"", "\"evseType\":\"-\"");
                jsonData=jsonData.replaceAll("\"result\":true,\"items\":7}}", "\"result\":true}}");
                List<int> jsonDataList=[];
                jsonDataList=Uint8List.fromList(jsonData.deviceByteArray);

                final data = DeviceTransferData.parse(jsonDataList);
                // final data = String.fromCharCodes(event);
                _provider.value = data;
                _logger.debug("解析:$data");
              } catch (e, st) {
                _logger.warn("解析失败;$ReceiveData", e, st);
                final String stringData=String.fromCharCodes(ReceiveData);
                _logger.debug("解析失败:$stringData");
              }
            }
          else
            {
              _logger.debug("数据开头格式不对:$ReceiveData");
              final String stringData=String.fromCharCodes(ReceiveData);
              _logger.debug("数据开头格式不对:$stringData");
              ReceiveData=[];
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
