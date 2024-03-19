import '../design.dart';

class BottomMenu extends StatelessWidget {
  final List<Widget> children;

  const BottomMenu({this.children = const [], super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }
}

class BottomMenuItem extends StatelessWidget {
  final Function() onClick;
  final String name;

  const BottomMenuItem(this.name, {required this.onClick, super.key});

  @override
  Widget build(BuildContext context) {
    return Ink(
      child: InkWell(
        onTap: onClick,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [Text(name)],
          ),
        ),
      ),
    );
  }
}
