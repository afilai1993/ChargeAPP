class DeviceMatchException implements Exception {
  const DeviceMatchException();

  @override
  String toString() {
    return "DeviceMatchException";
  }
}

enum ConnectErrorType {
  bluetoothOff,
  notFoundService,
  notFoundWriteCharacteristic,
  notFoundNotifyCharacteristic,
  unknown
}

class DeviceConnectException implements Exception {
  final ConnectErrorType errorType;
  final dynamic e;
  const DeviceConnectException(this.errorType,{this.e});

  @override
  String toString() {
    return "DeviceConnectException:$errorType;$e";
  }
}

class DeviceRequestTimeoutException implements Exception {
  const DeviceRequestTimeoutException();

  @override
  String toString() {
    return "DeviceRequestTimeoutException";
  }
}

class DeviceUnconnectedException implements Exception {
  const DeviceUnconnectedException();

  @override
  String toString() {
    return "DeviceUnconnectedException";
  }
}
