import 'package:chargestation/component/component.dart';
import 'package:chargestation/design.dart';

import '../generated/l10n.dart';

enum StatusPageType {
  none,
  refresh,
  empty,
  fail,
  success,
  other;

  const StatusPageType();
}

class GPEmptyStatusPage extends StatelessWidget {
  final String? text;
  final double? height;
  final Widget? action;

  const GPEmptyStatusPage({this.height, this.text, super.key, this.action});

  @override
  Widget build(BuildContext context) {
    Widget child = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const GPAssetImageWidget(
            "ic_page_empty.png",
            width: 200,
            height: 200,
          ),
          Text(text ?? S.current.empty_data),
          if (action != null) const SizedBox(height: 8),
          if (action != null) action!,
          const SizedBox(
            height: 150,
          )
        ],
      ),
    );
    if (height != null) {
      child = SizedBox(
        height: height,
        child: child,
      );
    }
    return child;
  }
}

class GPFailStatusPage extends StatelessWidget {
  final String? text;
  final VoidCallback onRefresh;

  const GPFailStatusPage({required this.onRefresh, this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text ?? S.current.request_fail),
          GPFilledButton(text: S.current.refresh, onPressed: onRefresh)
        ],
      ),
    );
  }
}

class GPRefreshStatusPage extends StatelessWidget {
  final String? text;

  const GPRefreshStatusPage({this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [GPLoadingWidget()],
      ),
    );
  }
}
