import 'package:chargestation/design.dart';

import 'image.dart';

class RightArrowIcon extends StatelessWidget {
  const RightArrowIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.arrow_forward_ios_rounded,
      size: 15,
    );
  }
}

class MenuIconContainer extends StatelessWidget {
  final Widget child;

  const MenuIconContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        color: context.onPrimaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Center(
        child: SizedBox(
          width: 18,
          height: 18,
          child: child,
        ),
      ),
    );
  }
}

class SvgMenuIcon extends StatelessWidget {
  final String iconName;
  final Color? iconColor;

  const SvgMenuIcon({required this.iconName, this.iconColor, super.key});

  @override
  Widget build(BuildContext context) {
    return MenuIconContainer(
      child: GPAssetSvgWidget(
        iconName,
        color: iconColor,
      ),
    );
  }
}
