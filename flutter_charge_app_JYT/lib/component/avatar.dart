import 'package:chargestation/component/component.dart';
import 'package:chargestation/infrastructure/infrastructure.dart';
import 'package:extended_image/extended_image.dart';

import '../design.dart';

class GPAvatar extends StatelessWidget {
  final double iconSize;
  final String url;

  const GPAvatar(this.url, {required this.iconSize, super.key});

  @override
  Widget build(BuildContext context) {
    final String innerUrl = url.fullUrl();
    return SizedBox(
        width: iconSize,
        height: iconSize,
        child: Center(
          child: ClipOval(
            child: innerUrl.isEmpty
                ? const GPAssetImageWidget("ic_avatar_default.png")
                : ExtendedImage.network(
                    innerUrl,
                    fit: BoxFit.cover,
                    width: iconSize,
                    height: iconSize,
                    loadStateChanged: (state) =>
                        const GPAssetImageWidget("ic_avatar_default.png"),
                  ),
          ),
        ));
  }
}
