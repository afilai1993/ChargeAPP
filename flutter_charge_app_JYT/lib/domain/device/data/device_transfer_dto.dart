import 'dart:convert';
// import 'dart:ffi';
import 'dart:typed_data';
// import 'package:fixnum/fixnum.dart';
extension DeviceTransferStringExtension on String {
  List<int> get deviceByteArray {
    return const Utf8Encoder().convert(this);
  }
}

extension TransferIntListExtension on List<int> {
  void downUpdateInt(int formIndex, int value, int size) {
    for (var index = 0; index < size; index++) {
      this[formIndex + index] = (value >> ((size - index - 1) * 8)) & 0xff;
    }
  }

  int _toInt(int offset, int size) {
    var result = 0;
    for (var index = 0; index < size; index++) {
      result += this[offset + index] << ((size - index - 1) * 8);
    }
    return result;
  }

  int _toLong(int offset) {
    var result = 0;
    for (var index = 0; index < 6; index++) {
      result += (result << 8) | (this[index + offset] & 0xff);
    }
    return result;
  }

  List<int> copyRange(
    int fromIndex,
    int toIndex,
  ) {
    return List.generate(
        toIndex - fromIndex, (index) => this[index + fromIndex]);
  }
}

enum DeviceTransferIdentify {
  start("\n", 10),
  close('\r', 13),
  dataClose('', 0);

  final String key;
  final int value;

  const DeviceTransferIdentify(this.key, this.value);
}

class DeviceTransferData {
  final DeviceTransferMethod transferMethod;
  final DeviceTransferUnique unique;
  final int currentLength;
  final int remainLength;
  final DeviceTransferBody body;

  static const _startIdentitySize = 1;
  static const _currentLengthSize = 3;
  static const _remainLengthSize = 3;
  static const _checkCodeSize = 2;
  static const _endIdentitySize = 1;

  const DeviceTransferData({
    required this.transferMethod,
    required this.unique,
    required this.currentLength,
    required this.remainLength,
    required this.body,
  });

  factory DeviceTransferData.parse(List<int> dataList) {
    final uint8List = Uint8List.fromList(dataList);
    // final DeviceTransferMethod method = DeviceTransferMethod.find(uint8List, 1);

    // return DeviceTransferData(
    //     transferMethod: method,
    //     unique: DeviceTransferUnique.parse(
    //         uint8List, _startIdentitySize + method.size),
    //     remainLength: uint8List._toInt(
    //         _startIdentitySize + method.size + DeviceTransferUnique.length,
    //         _remainLengthSize),
    //     currentLength: uint8List._toInt(
    //         _startIdentitySize +
    //             method.size +
    //             DeviceTransferUnique.length +
    //             _remainLengthSize,
    //         _currentLengthSize),
    //     body: DeviceTransferBody(uint8List.copyRange(
    //         _startIdentitySize +
    //             method.size +
    //             DeviceTransferUnique.length +
    //             _remainLengthSize +
    //             _currentLengthSize,
    //         uint8List.length - _endIdentitySize - _checkCodeSize)));

    String uidString=DeviceTransferBody(uint8List.copyRange(0, dataList.length)).toJsonBody().uniqueId;
    int uid = 0;
    uid=int.parse(uidString);
    var uidList=Uint8List.fromList([0x01,0x8E,0x1D,(uid>>16)&0xff,(uid>>8)&0xff,uid&0xff]);
    return DeviceTransferData(
        transferMethod: DeviceTransferMethod.slave,
        unique: DeviceTransferUnique.parse(uidList,0),
        remainLength: 0,
        currentLength: dataList.length,
        body: DeviceTransferBody(uint8List.copyRange(
            0,
            dataList.length)));
  }

  List<int> get result {
    // final length = _startIdentitySize +
    //     transferMethod.data.length +
    //     DeviceTransferUnique.length +
    //     _remainLengthSize +
    //     _currentLengthSize +
    //     body.values.length +
    //     _checkCodeSize +
    //     _endIdentitySize;
    // final result = Uint8List(length);
    // var pos = 0;
    // //开始符
    // result[0] = DeviceTransferIdentify.start.value;
    // pos++;
    // //传输方式
    // for (var item in transferMethod.data) {
    //   result[pos++] = item;
    // }
    // // uniqueId
    // unique.updateByteArray(result, pos);
    // pos += DeviceTransferUnique.length;
    // // 剩余发送长度
    // result.downUpdateInt(pos, remainLength, _remainLengthSize);
    // pos += _remainLengthSize;
    // // 当前发送长度
    // result.downUpdateInt(pos, currentLength, _currentLengthSize);
    // pos += _currentLengthSize;
    // // 内容
    // for (var item in body.values) {
    //   result[pos++] = item;
    // }
    // //校验码
    // final checkFromIndex = _startIdentitySize + transferMethod.value.length;
    // final checkEndIndex = checkFromIndex +
    //     DeviceTransferUnique.length +
    //     _remainLengthSize +
    //     _currentLengthSize +
    //     body.values.length -
    //     1;
    // var check1 = result[checkFromIndex];
    // var check2 = result[checkFromIndex];
    // for (var index = checkFromIndex + 1; index <= checkEndIndex; index++) {
    //   check1 = check1 ^ result[index];
    //   check2 += (result[index] & 0x00ff);
    // }
    // result[pos] = check1;
    // result[pos + 1] = check2;
    // pos += _checkCodeSize;
    // //结束符
    // result[pos] = DeviceTransferIdentify.close.value;
    final length = body.values.length;
    final result = Uint8List(length);
    var pos = 0;
    // 内容
    for (var item in body.values) {
      result[pos++] = item;
    }
    return Int8List.fromList(result);
  }

  @override
  String toString() {
    final Map<String, Object> map = {
      "transferMethod": transferMethod.value,
      "unique": {
        "serial": unique.serial,
        "property": {
          "reply": unique.property.isReplay,
          "broadcast": unique.property.isBroadcast,
          "requiredHeart": unique.property.requiredHeart,
          "restartSend": unique.property.isRestartSend,
          "offlineSend": unique.property.isOfflineSend,
          "level": unique.property.level
        },
        "msAddress": unique.msAddress,
        "version": unique.version
      },
      "currentLength": currentLength,
      "remainLength": remainLength,
      "body": const Utf8Decoder().convert(body.values),
    };

    return 'DeviceTransferData:${jsonEncode(map)}';
  }
}

enum DeviceTransferMethod {
  master("Master", [77, 97, 115, 116, 101, 114]),
  slave("Slave", [83, 108, 97, 118, 101]);

  final String value;
  final List<int> data;

  // final List<int> bytes;

  const DeviceTransferMethod(
    this.value,
    this.data,
    //this.bytes
  );

  int get size => data.length;

  static DeviceTransferMethod find(List<int> dataList, int offset) {
    final first = dataList[offset];
    if (first == DeviceTransferMethod.master.data[0]) {
      _checkEquals(DeviceTransferMethod.master, dataList, offset);
      return DeviceTransferMethod.master;
    } else if (first == DeviceTransferMethod.slave.data[0]) {
      _checkEquals(DeviceTransferMethod.slave, dataList, offset);
      return DeviceTransferMethod.slave;
    } else {
      throw "Not found DeviceTransferMethod";
    }
  }

  static void _checkEquals(
      DeviceTransferMethod method, List<int> dataList, int offset) {
    for (var index = 1; index < method.size; index++) {
      if (dataList[offset + index] != method.data[index]) {
        throw "Not found DeviceTransferMethod";
      }
    }
  }
}

class DeviceTransferUnique {
  final int serial;
  final DeviceTransferProperty property;
  final int msAddress;
  final int version;

  static const length = 6;

  const DeviceTransferUnique({
    required this.serial,
    this.property = const DeviceTransferProperty(),
    this.msAddress = 0x8E,
    this.version = 1,
  });

  int get value {
    final list = List.generate(length, (index) => 0);
    updateByteArray(list, 0);
    return int.parse(
        "0x${Uint8List.fromList(list).map((e) => e.toRadixString(16).padLeft(2, '0').toUpperCase()).join("")}");
  }

  void updateByteArray(List<int> dest, int fromIndex) {
    dest[fromIndex] = version;
    dest[fromIndex + 1] = msAddress;
    dest[fromIndex + 2] = property.value;
    dest.downUpdateInt(fromIndex + 3, serial, 3);
  }

  factory DeviceTransferUnique.parse(List<int> dataList, int offset) {
    return DeviceTransferUnique(
        serial: dataList[offset + 5] +
            (dataList[offset + 4] << 8) +
            (dataList[offset + 3] << 16),
        property: DeviceTransferProperty(value: dataList[offset + 2]),
        msAddress: dataList[offset + 1],
        version: dataList[offset]);
  }
}

class DeviceTransferBody {
  final List<int> values;

  const DeviceTransferBody(this.values);

  DeviceTransferJsonBody toJsonBody() {
    final json = const Utf8Decoder().convert(values, 0, values.length - 1);
    final jsonObject = jsonDecode(json);
    return DeviceTransferJsonBody(
        messageType: ChargeMessageType.valueOf(jsonObject["messageTypeId"]),
        uniqueId: jsonObject["uniqueId"],
        action: jsonObject["action"],
        payload: jsonObject["payload"]);
  }
}

class DeviceTransferProperty {
  final int value;

  /// 回复标识
  static const replyFlag = 0x01;

  /// 广播标识
  static const broadcastFlag = 0x02;

  /// 心跳包标识
  static const requiredHeartFlag = 0x04;

  /// 重启继续执行
  static const restartSendFlag = 0x08;

  /// 重启继续执行
  static const offlineSendFlag = 0x10;

  static const levelPos = 7 << 5;

  static const _defaultValue =
      (replyFlag | requiredHeartFlag | restartSendFlag | offlineSendFlag) +
          (0 << 5);

  const DeviceTransferProperty({this.value = _defaultValue});

  factory DeviceTransferProperty.create({
    bool isReplay = true,
    bool isBroadcast = false,
    bool requiredHeart = true,
    bool isRestartSend = true,
    bool isOfflineSend = true,
    int level = 0,
  }) {
    var result = 0;
    if (isReplay) {
      result = result | replyFlag;
    }
    if (isBroadcast) {
      result = result | broadcastFlag;
    }
    if (requiredHeart) {
      result = result | requiredHeartFlag;
    }
    if (isRestartSend) {
      result = result | restartSendFlag;
    }
    if (isOfflineSend) {
      result = result | offlineSendFlag;
    }
    result += level << 5;
    return DeviceTransferProperty(value: result);
  }

  bool get isReplay => value & replyFlag == replyFlag;

  bool get isBroadcast => value & broadcastFlag == broadcastFlag;

  bool get requiredHeart => value & requiredHeartFlag == requiredHeartFlag;

  bool get isRestartSend => value & restartSendFlag == restartSendFlag;

  bool get isOfflineSend => value & offlineSendFlag == offlineSendFlag;

  int get level => (value & levelPos) >> 5;

  @override
  String toString() {
    return "回复标识:$isReplay.广播标识:$isBroadcast.心跳包:$requiredHeart.重启继续执行:$isRestartSend.重启继续执行:$isOfflineSend.等级:$level ";
  }
}

enum ChargeMessageType {
  req("5"),
  rcv("6");

  static final _map = {
    ChargeMessageType.req.value: req,
    ChargeMessageType.rcv.value: rcv,
  };
  final String value;

  const ChargeMessageType(this.value);

  static ChargeMessageType? valueOf(String value) => _map[value];
}

class DeviceTransferJsonBody {
  final ChargeMessageType? messageType;
  final String? action;
  final dynamic payload;
  final String uniqueId;

  const DeviceTransferJsonBody({
    required this.messageType,
    this.action,
    this.payload,
    required this.uniqueId,
  });

  // List<int> get result => ("${jsonEncode({
  //           "messageTypeId": messageType?.value,
  //           "uniqueId": uniqueId,
  //           "action": action,
  //           "payload": payload
  //         })}${DeviceTransferIdentify.dataClose.key}")
  //         .deviceByteArray;
  List<int> get result => ("${jsonEncode({
    "messageTypeId": messageType?.value,
    "uniqueId": uniqueId,
    "action": action,
    "payload": payload
  })}${DeviceTransferIdentify.dataClose.key}")
      .deviceByteArray;


  DeviceTransferBody toDeviceTransferBody() {
    return DeviceTransferBody(result);
  }
}
