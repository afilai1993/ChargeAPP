import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../design.dart';

void showLoading(String message) {
  EasyLoading.show(status: message);
}

void hideLoading() {
  EasyLoading.dismiss();
}

class GPLoadingWidget extends StatelessWidget {
  final double size;

  const GPLoadingWidget({this.size = 10, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(
          strokeWidth: 2,
        ));
  }
}
