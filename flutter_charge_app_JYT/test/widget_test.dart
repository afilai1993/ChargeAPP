// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';
import 'dart:typed_data';

import 'package:chargestation/domain/device/data/device_transfer_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("测试字符串", () {
    print('\n'.codeUnits[0]);
    print('\r'.codeUnits[0]);
    print('#'.codeUnits[0]);
    //  print(const Utf8Encoder().convert("洪").map((e) => e.toRadixString(16)));
    // print("洪".codeUnits);
    print(DeviceTransferMethod.slave.value.deviceByteArray.toList());
    print(DeviceTransferMethod.master.value.deviceByteArray.toList());
    // print(
    //     TransferMethod.slave.value.codeUnits.map((e) => e.toRadixString(16)));
  });
  test("createTransferData", () {
    final unique = DeviceTransferUnique(
      serial: 11,
      property: DeviceTransferProperty.create(),
      msAddress: 1,
    );
    final byteList = List.generate(6, (index) => 0);
    unique.updateByteArray(byteList, 0);
    print(Uint8List.fromList(byteList)
        .map((e) => e.toRadixString(16).padLeft(2, '0').toUpperCase())
        .join(" "));
    var isRealValue=int.parse("0x00011D00000B");
    print(isRealValue);
    print(unique.value);
    print(unique.value.toRadixString(16));
    print(isRealValue.toRadixString(16));
    // final data =
    //     "{\"messageTypeId\":\"5\",\"uniqueId\":\"9999999999999\",\"action\":\"HandShake\",\"payload\":{\"userId\":\"1\",\"chargeBoxSN\":\"EVSE-XW7\",\"currentTime\":\"2023-10-09T11:47:40Z\",\"connectionKey\":\"GoPro\"}}#"
    //         .deviceByteArray;
    //
    // final transferData = DeviceTransferData(
    //     transferMethod: DeviceTransferMethod.master,
    //     unique: unique,
    //     currentLength: data.length,
    //     remainLength: 0,
    //     body: DeviceTransferBody(data));
    // final result = transferData.result;
    // print(result.join(' '));
    // print(Uint8List.fromList(result)
    //     .map((e) => e.toRadixString(16).padLeft(2, '0').toUpperCase())
    //     .join(" "));
    // final parseResult = DeviceTransferData.parse(result);
    // print(const Utf8Decoder().convert(parseResult.body.values));
  });

  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // // Build our app and trigger a frame.
  //   // await tester.pumpWidget(const MyApp());
  //   //
  //   // // Verify that our counter starts at 0.
  //   // expect(find.text('0'), findsOneWidget);
  //   // expect(find.text('1'), findsNothing);
  //   //
  //   // // Tap the '+' icon and trigger a frame.
  //   // await tester.tap(find.byIcon(Icons.add));
  //   // await tester.pump();
  //   //
  //   // // Verify that our counter has incremented.
  //   // expect(find.text('0'), findsNothing);
  //   // expect(find.text('1'), findsOneWidget);
  // });
}
