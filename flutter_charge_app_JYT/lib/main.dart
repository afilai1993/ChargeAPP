import 'package:chargestation/app.dart';
import 'package:chargestation/infrastructure/infrastructure.dart';
import 'package:flutter/material.dart';
void main() async {
  /// 初始化
  ///

  WidgetsFlutterBinding.ensureInitialized();
  await userStore.init();
  runApp(AppWidget());
  // httpClient.get("/common/getIpAddress");
  // print(await WiFiForIoTPlugin.getIP());
  //
  // var handler = webSocketHandler((webSocket) {
  //   webSocket.stream.listen((message) {
  //     print("server received:${message}");
  //     webSocket.sink.add("server echo");
  //   });
  // });
  //
  // await shelf_io.serve(handler, '192.168.1.114', 15479).then((server) {
  //   print('Serving at ws://${server.address.host}:${server.port}');
  // });
}
