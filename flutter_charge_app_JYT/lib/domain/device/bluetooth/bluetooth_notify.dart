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
  String addMinutesToDateTime(String originalDateTime, int minutesToAdd) {
    _logger.debug("修改addMinutesToDateTime");
    DateTime parsedDateTime = DateTime.parse(originalDateTime);
    Duration durationToAdd = Duration(minutes: minutesToAdd);
    DateTime newDateTime = parsedDateTime.add(durationToAdd);
    String newDateTimeString = newDateTime.toIso8601String();
    newDateTimeString=newDateTimeString.substring(0,originalDateTime.length-1);
    newDateTimeString+='Z';
    return newDateTimeString;
  }
  Stream<Object?> get stream => _provider.createStream(currentGet: false);
  static List<int> ReceiveData=[];
  void _listen() async{
    _subscription = characteristic.onValueReceived.listen((event) async{
      try {
      ReceiveData+=event;
      int endAddrFirst=0;
      endAddrFirst=event.indexOf(0x23);
      if(endAddrFirst >= 0)//判断是否有#号结尾
        {
          if(ReceiveData[0]==123)
            {
              String jsonData="";
              jsonData=String.fromCharCodes(ReceiveData);
              _logger.debug("修改前的数据为$jsonData");
                jsonData = jsonData.replaceAll("AT+CWJAP?", "");
                jsonData = jsonData.replaceAll("AT+CWJAP?\r\n", "");
                jsonData = jsonData.replaceAll('"r"charge"', "\"recordType\":\"Charge\"");
                jsonData = jsonData.replaceAll("\"connectorStatus\":0", "\"connectorStatus\":\"wait\"");
                jsonData = jsonData.replaceAll("\"PncStatus\":false", "\"PncStatus\":4");
                jsonData = jsonData.replaceAll("\"loadbalance\":0", "\"loadbalance\":false");
                jsonData = jsonData.replaceAll("\"evseType\":\"NA\"", "\"evseType\":\"-\"");
                if (jsonData.contains("\",\"action\":\"SynchroData\",\"")) {
                  jsonData = jsonData.replaceAll("}}}", '},"Temperature1":"37.0","Temperature2":"37.0"}}');
                }
                if(jsonData.contains("\"result\":true,\"items\":"))
                {
                  jsonData=jsonData.substring(0,jsonData.indexOf(',"items":'))+"}}#";
                }
                if(jsonData.contains("\"action\":\"UploadRecord\""))
                {
                  _logger.debug("修改UploadRecord");
                  List<int> dataList=Uint8List.fromList(jsonData.deviceByteArray);
                  final json = const Utf8Decoder().convert(dataList, 0, dataList.length-1);
                  final jsonObject = jsonDecode(json);
                  int duration=jsonObject['payload']['recordDetails']['duration'] as int;
                  String uniqueId=jsonObject['uniqueId'] as String;
                  BluetoothWriter.receiveUid=uniqueId;
                  int uniqueIdNumber=0x018E1D000000+int.parse(uniqueId);
                  jsonData = jsonData.substring(jsonData.indexOf(',"action":'),jsonData.length-1);
                  jsonData = '{"messageTypeId":"5","uniqueId":"$uniqueIdNumber"$jsonData';
                  String startTime=jsonObject['payload']['recordDetails']['startTime'] as String;
                  String endTime=addMinutesToDateTime(startTime,duration);
                  String energy=jsonObject['payload']['recordDetails']['energy'] as String;
                  // String stopreason=jsonObject['payload']['recordDetails']['stopreason'] as String;
                  jsonData = jsonData.replaceAll("\",\"recordType\":\"charge\",", "\",\"recordType\":\"Charge\",");
                  jsonData = jsonData.substring(0,jsonData.indexOf(',"duration"'));
                  // jsonData+=',"endTime":"$endTime","energy":"${energy}0000","prices":"0USD","stopReason":"$stopreason"}}}#';
                  jsonData+=',"endTime":"$endTime","energy":"${energy}0000","prices":"0USD","stopReason":"APP"}}}#';
                  jsonData = jsonData.replaceAll("\"connectorId\":0", "\"connectorId\":1");
                }
                List<int> jsonDataList=Uint8List.fromList(jsonData.deviceByteArray);
                final data = DeviceTransferData.parse(jsonDataList);
                _provider.value = data;
                _logger.debug("解析:$data");
                if((!(jsonData.contains("\",\"result\":")||jsonData.contains("\",\"status\":")))&&!jsonData.contains("\"action\":\"UploadRecord\"")) {
                  String uid="";
                  final json = const Utf8Decoder().convert(jsonDataList, 0, jsonDataList.length-1);
                  final jsonObject = jsonDecode(json);
                  uid=jsonObject['uniqueId'];
                  BluetoothWriter.receiveUid=uid;
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
      } catch (e, st) {
        _logger.warn("解析失败;$ReceiveData", e, st);
        final String stringData=String.fromCharCodes(ReceiveData);
        _logger.debug("解析失败:$stringData");
      }
    });
  }
}
