import 'package:chargestation/design.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GPAssetImageWidget extends StatelessWidget {
  final String name;
  final double? height;
  final double? width;

  const GPAssetImageWidget(this.name, {this.height, this.width, super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "public/images/$name",
      width: width,
      height: height,
    );
  }
}

class GPAssetSvgWidget extends StatelessWidget {
  final String name;
  final Color? color;
  final double? width;
  final double? height;

  const GPAssetSvgWidget(this.name,
      {this.width, this.height, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset("public/images/$name",
        width: width,
        height: height,
        colorFilter:
            color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn));
  }
}
