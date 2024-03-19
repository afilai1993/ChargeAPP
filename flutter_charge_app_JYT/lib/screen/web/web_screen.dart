import 'package:chargestation/component/component.dart';
import 'package:chargestation/design.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebScreen extends StatefulWidget {
  final String url;

  const WebScreen({super.key, required this.url});

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen> {
  late final WebViewController _webViewController;
  String title = "";

  @override
  void initState() {
    super.initState();
    const PlatformWebViewControllerCreationParams params =
        PlatformWebViewControllerCreationParams();
    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) {
          if (progress > 80) {
            controller.getTitle().then((value) {
              setState(() {
                title = value ?? "";
              });
              return value;
            });
          }
        },
      ))
      ..loadRequest(Uri.parse(widget.url));
    _webViewController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return GPScaffold(
      appBar: GPAppbar(
        title: GPAppBarTitle(title),
      ),
      body: WebViewWidget(
        controller: _webViewController,
      ),
    );
  }
}
