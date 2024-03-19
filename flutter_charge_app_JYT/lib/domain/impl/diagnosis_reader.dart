part of '../household_device_case.dart';

class BluetoothDiagnosisReader {
  final HardwareChargeDevice device;
  final File file;
  Completer? _completer;
  Timer? _timer;
  final List<String> writeList = [];
  final startAddressList = <String>{};

  BluetoothDiagnosisReader(this.file, this.device);

  Future execute() {
    final completer = Completer();
    _completer = completer;
    _timer = Timer(const Duration(seconds: 20), () {
      finishOnError(const DeviceRequestTimeoutException());
    });
    device
        .requestSyncRecord(recordType: "Diagnosis", startAddress: "0")
        .catchError((e) {
      finishOnError(e);
    });
    return completer.future;
  }

  void finishOnError(e) {
    final current = _completer;
    if (current != null && !current.isCompleted) {
      current.completeError(e);
    }
    _timer?.cancel();
    _timer = null;
    _completer = null;
  }

  Future finish() async {
    for (var item in writeList) {
      await file.writeAsString(item, mode: FileMode.append);
    }
    final current = _completer;
    if (current != null && !current.isCompleted) {
      current.complete();
    }
  }

  void onReceive(DeviceTransferJsonBody data)  {
    final startAddress = data.payload["recordDetails"]["StartAddress"];
    if (startAddress == null) {
      return;
    }
    final diagnosisData = data.payload["recordDetails"]["Data"];
    if (diagnosisData == null) {
      return;
    }
    writeList.add(diagnosisData);
  }
}
