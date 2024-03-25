part of 'bluetooth_charge_device.dart';

class _BluetoothRequest {
  final DeviceTransferUnique unique;
  final String action;
  final Object? payload;

  const _BluetoothRequest({
    required this.unique,
    required this.action,
    this.payload,
  });

  @override
  String toString() {
    return '_BluetoothRequest{unique: $unique, action: $action, payload: $payload}';
  }
}

class _RequestCompleter {
  final _BluetoothRequest request;
  final Completer completer;

  _RequestCompleter(this.request) : completer = Completer();
}

class _BluetoothWriter {
  final BluetoothCharacteristic characteristic;
  final Map<int, _RequestCompleter> _completerMap = {};
  Future? _runFuture;
  final _logger = loggerFactory.getLogger("BluetoothWriter");

  _BluetoothWriter(this.characteristic);

  Future writeRequest(_BluetoothRequest request) {
    final completer = _RequestCompleter(
      request,
    );
    _completerMap[request.unique.serial] = completer;
    _run();
    return completer.completer.future;
  }


  Future<void> sendHeartBeat() async
  {
    // {"messageTypeId":"6","uniqueId":"7","payload":{"chargeBoxSN":"11222"}}#
    int serial = 10;
    while (true) {
      // final completerList = List.of(_completerMap.values);
      //
      // for (var item in completerList) {
      //   // serial = item.request.unique.serial;
      //   // if (!_completerMap.containsKey(serial)) {
      //   //   continue;
      //   // }
      //   serial++;
      //   // String uid=(item.request.unique.value&0x000000ffffff).toString();
      //   String uid=(serial&0x000000ffffff).toString();
      //   String chargeBoxSN="2100102310200220";
      //   //{chargeBoxSN: 2100102310200220, userId: , requestedMessage: SynchroInfo}
      //   String payLoad="";
      //   payLoad=item.request.payload.toString().replaceAll("{chargeBoxSN: ", "").replaceAll(", userId: , requestedMessage: SynchroInfo}", "");
      //
      //   chargeBoxSN=payLoad;
      //   String body='{"messageTypeId":"6","uniqueId":"$uid","payload":{"chargeBoxSN":"$chargeBoxSN"}}';
      //   // final runFuture = _runFuture;
      //   // // if (runFuture != null) {
      //   // //   return;
      //   // // }
      //   // _runFuture =
      //
      //       // () async {
      //     await characteristic.write(
      //         Int8List.fromList(body.deviceByteArray),
      //         withoutResponse: true);
      //     sleep(const Duration(milliseconds: 200));
      //     await characteristic.write(
      //         Int8List.fromList([0x23]),
      //         withoutResponse: true);
      //     sleep(const Duration(milliseconds: 1500));
      //     _logger.debug("发送数据给充电桩:$body#");
      //   // };
      //
      // }
      serial++;
      String uid = (serial & 0x000000ffffff).toString();
      String chargeBoxSN = "2100102310200220";
      String body = '{"messageTypeId":"6","uniqueId":"$uid","payload":{"chargeBoxSN":"$chargeBoxSN"}}';
      await sendMessage(body);
    }
    // return Future.value();
  }
  void backgroundTask(dynamic message) async{
    // 在这里编写后台任务的逻辑
    int serial=1;
    while (true) {
      // 执行你的任务代码
      serial++;
      String uid = (serial & 0x000000ffffff).toString();
      String chargeBoxSN = "2100102310200220";
      String body = '{"messageTypeId":"6","uniqueId":"$uid","payload":{"chargeBoxSN":"$chargeBoxSN"}}';
      await sendMessage(body);
    }
  }
  Future<void> sendMessage(String data)
  async {
    await characteristic.write(
        Int8List.fromList(data.deviceByteArray),
        withoutResponse: true);
    sleep(const Duration(milliseconds: 200));
    await characteristic.write(
        Int8List.fromList([0x23]),
        withoutResponse: true);

    _logger.debug("发送数据给充电桩:$data#");
    sleep(const Duration(milliseconds: 1500));
  }

  void _run() {
    final runFuture = _runFuture;
    if (runFuture != null) {
      return;
    }
    _runFuture = Future(() async {
      do {
        final completerList = List.of(_completerMap.values);
        int serial;
        for (var item in completerList) {
          serial = item.request.unique.serial;
          if (!_completerMap.containsKey(serial)) {
            continue;
          }
          final body = DeviceTransferJsonBody(
                  messageType: ChargeMessageType.req,
                  uniqueId: (item.request.unique.value&0x000000ffffff).toString(),
                  action: item.request.action,
                  payload: item.request.payload)
              .toDeviceTransferBody();
          final body1=[0x23];
          final String sendData=String.fromCharCodes(body.values+body1);

          try {

//{"messageTypeId":"5","uniqueId":"4781506590","action":"GetRecord","payload":{"chargeBoxSN":"A23-16","userId":"","recordType":"charge","startAddress":null,"startTime":"2024-03-05T15:41:00Z","endTime":"2024-03-07T09:04:12Z"}}#
//{"messageTypeId":"5","uniqueId":"1711088067494","action":"GetRecord","payload":{"userId":"1","chargeBoxSN":"2100102310200220","recordType":"charge","startTime":"2024-03-01","endTime":"2024-03-31"}}
            _logger.debug("发送数据给充电桩:$sendData");
            if(sendData.contains('SynchroInfo'))
            {
              String uid="";
              String chargeBoxSN="";
              uid=(item.request.unique.value&0x000000ffffff).toString();
              final json = const Utf8Decoder().convert(body.values, 0, body.values.length);
              final jsonObject = jsonDecode(json);
              chargeBoxSN=jsonObject['payload']['chargeBoxSN'];
              String jsonData1='{"messageTypeId":"6","uniqueId":"$uid","payload":{"chargeBoxSN":"$chargeBoxSN","status":"accept"}}#';
              String jsonData2='{"messageTypeId":"5","uniqueId":"16777215","action":"SynchroInfo","payload":{"chargeBoxSN":"$chargeBoxSN","connectorMain":{"connectionStatus":true,"chargeStatus":"wait","statusCode":0,"startTime":"-","endTime":"-","voltage":"220","current":"0.00","power":"0","electricWork":"0.00000","chargingTime":"0:0:0"},"Temperature1":"37.0","Temperature2":"21.9"}}#';
              try {
                List<int> jsonDataList1=[];
                jsonDataList1=Uint8List.fromList(jsonData1.deviceByteArray);
                final data = DeviceTransferData.parse(jsonDataList1);
                _logger.debug("模拟回复SynchroInfo解析:$data");
              } catch (e, st) {
                _logger.warn("模拟回复SynchroInfo解析失败;$jsonData1", e, st);
              }
              try {
                List<int> jsonDataList2=[];
                jsonDataList2=Uint8List.fromList(jsonData2.deviceByteArray);
                final data = DeviceTransferData.parse(jsonDataList2);
                _logger.debug("模拟回复SynchroInfo解析:$data");
              } catch (e, st) {
                _logger.warn("模拟回复SynchroInfo解析失败;$jsonData2", e, st);
              }
              sleep(const Duration(milliseconds: 500));
              await sendHeartBeat();
              // 创建一个新的Isolate，并传入后台任务函数
              // final isolate = await Isolate.spawn(backgroundTask, null);
              // 等待一段时间后终止Isolate
              // backgroundTask;
              // await Future.delayed(const Duration(seconds: 10));
              // isolate.kill(priority: Isolate.immediate);
            }
            else
              {
                await characteristic.write(
                    DeviceTransferData(
                        transferMethod: DeviceTransferMethod.master,
                        unique: item.request.unique,
                        currentLength: body.values.length,
                        remainLength: 0,
                        body: body)
                        .result,
                    // Int8List.fromList(body.values),

                    withoutResponse: true);

                sleep(const Duration(milliseconds: 200));
                await characteristic.write(
                    Int8List.fromList(body1),
                    withoutResponse: true);
                sleep(const Duration(milliseconds: 500));

              }
            final completer = _completerMap.remove(serial);
            if (completer != null && !completer.completer.isCompleted) {
              completer.completer.complete();
            }
          } catch (e, st) {
            _logger.error(e.toString(), e, st);
            final completer = _completerMap.remove(serial);
            if (completer != null && !completer.completer.isCompleted) {
              completer.completer.completeError(e, st);
            }
          }
        }
      } while (_completerMap.isNotEmpty);
      _runFuture = null;
    });
  }
}
