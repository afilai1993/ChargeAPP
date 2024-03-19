import 'package:chargestation/design.dart';

class GPDivider extends StatelessWidget {
  const GPDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.outlineColor,
      height: 0.2,
      width: double.infinity,
    );
  }
}
