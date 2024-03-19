import 'package:chargestation/component/component.dart';
import 'package:chargestation/design.dart';

class GPFilledButton extends StatelessWidget {
  final Function()? onPressed;
  final bool isLoading;
  final String text;
  final bool enable;
  final ButtonStyle? style;

  const GPFilledButton(
      {this.text = "",
      super.key,
      this.style,
      required this.onPressed,
      this.enable = true,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    Widget child = Text(text);
    if (isLoading) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const GPLoadingWidget(),
          const SizedBox(
            width: 4,
          ),
          child
        ],
      );
    }
    final disable = isLoading || !enable;
    return FilledButton(
      onPressed: disable ? null : onPressed,
      style: style,
      child: child,
    );
  }
}

class GPTextButton extends StatelessWidget {
  final Function()? onPressed;
  final bool isLoading;
  final String text;
  final bool enable;
  final TextStyle? style;
  final Widget? icon;

  const GPTextButton(
      {this.text = "",
      super.key,
      this.style,
      this.icon,
      required this.onPressed,
      this.enable = true,
      this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    Widget child = Text(text, style: style);
    if (isLoading) {
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const GPLoadingWidget(),
          const SizedBox(
            width: 4,
          ),
          child
        ],
      );
    }else if(icon!=null){
      child = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(
            width: 4,
          ),
          child
        ],
      );
    }
    final disable = isLoading || !enable;
    return TextButton(onPressed: disable ? null : onPressed, child: child);
  }
}
