import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:web_socket_channel/status.dart' as status;

void main() async {
  print("create Server");
  var handler = webSocketHandler((webSocket) {
    print(webSocket);
    webSocket.stream.listen((message) {
      print("server received:${message}");
      webSocket.sink.add("server echo");
    });
  });

  await shelf_io.serve(handler, 'localhost', 10000).then((server) {
    print('Serving at ws://${server.address.host}:${server.port}');
  });

  // print("create client");
  // final wsUrl = Uri.parse('ws://localhost:8080');
  // final channel = WebSocketChannel.connect(wsUrl);
  //
  // await channel.ready;
  // print("ready success");
  //
  // channel.sink.add("client request connect");
  // await for (var item in channel.stream) {
  //   print("client received:${item}");
  //   channel.sink.add("client echo");
  // }
  await Future.delayed(const Duration(days: 1));
}
