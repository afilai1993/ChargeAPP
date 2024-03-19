import 'package:chargestation/design.dart';

class GPAppbar extends AppBar {
  GPAppbar(
      {super.key,
      super.title,
      super.leading,
      super.automaticallyImplyLeading = true,
      super.actions});
}

class GPAppBarTitle extends StatelessWidget {
  final String title;

  const GPAppBarTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.appBarTitleStyle,
    );
  }
}
