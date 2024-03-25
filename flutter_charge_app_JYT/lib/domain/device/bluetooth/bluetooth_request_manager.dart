part of 'bluetooth_charge_device.dart';

class _DeviceTransferCall {
  final Completer<DeviceTransferData> completer;
  final _BluetoothRequest request;
  late Timer timer;

  _DeviceTransferCall(this.completer, this.request);
}

class _BluetoothRequestManager {
  final _BluetoothWriter writer;
  final Map<int, _DeviceTransferCall> callManager = {};

  _BluetoothRequestManager(this.writer);

  Future<DeviceTransferData> request(_BluetoothRequest request) {



    final serial = request.unique.serial;
    final call = _DeviceTransferCall(Completer(), request);
    callManager[serial] = call;
    final timer = Timer(const Duration(seconds: 10), () {
      final existCall = callManager.remove(serial);
      if (existCall != null && !existCall.completer.isCompleted) {
        existCall.completer
            .completeError(const DeviceRequestTimeoutException());
      }
    });
    call.timer = timer;
    writer.writeRequest(request).catchError((e) {
      final existCall = callManager.remove(serial);
      timer.cancel();
      if (existCall != null && !existCall.completer.isCompleted) {
        existCall.completer.completeError(e);
      }
    });
    return call.completer.future;
  }

  bool resumeData(DeviceTransferData data) {
    final call = callManager.remove(data.unique.serial);
    if (call != null && !call.completer.isCompleted) {
      //print("已消费:${call}");
      call.timer.cancel();
      call.completer.complete(data);
      return true;
    }
    return false;
  }
}
