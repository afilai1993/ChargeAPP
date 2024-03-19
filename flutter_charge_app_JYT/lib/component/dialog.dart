import 'package:chargestation/design.dart';
import 'package:chargestation/infrastructure/infrastructure.dart';
import 'package:provider/provider.dart';

import 'button.dart';

enum DialogButtonType {
  confirm,
  cancel,
}

class DialogResult<T> {
  final DialogButtonType type;
  final T? data;

  const DialogResult(this.type, {this.data});
}

class GPAlertDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final bool showCancel;
  final BoolStateRef? loading;
  final Function()? onConfirm;
  final Function()? onCancel;

  const GPAlertDialog(
      {super.key,
      this.title,
      this.content,
      this.showCancel = true,
      this.loading,
      this.onConfirm,
      this.onCancel});

  @override
  Widget build(BuildContext context) {
    final Widget confirmWidget;
    if (loading != null) {
      confirmWidget = RefProvider(loading,
          builder: (_, ref, child) => GPTextButton(
              text: S.current.confirm,
              isLoading: ref?.value ?? false,
              onPressed: onConfirm));
    } else {
      confirmWidget =
          GPTextButton(text: S.current.confirm, onPressed: onConfirm);
    }

    return AlertDialog.adaptive(
      title: title,
      content: content,
      actions: [
        if (showCancel)
          GPTextButton(text: S.current.cancel, onPressed: onCancel),
        confirmWidget
      ],
    );
  }
}

class GPMessageDialog extends StatelessWidget {
  final String? title;
  final String message;
  final bool showCancel;
  final BoolStateRef? loading;
  final Function()? onConfirm;
  final Function()? onCancel;

  const GPMessageDialog(
      {super.key,
      this.title,
      required this.message,
      this.showCancel = true,
      this.loading,
      this.onCancel,
      this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return GPAlertDialog(
      title: title != null ? GPDialogTitle(title ?? "") : null,
      content: Text(message),
      showCancel: showCancel,
      loading: loading,
      onCancel: onCancel,
      onConfirm: onConfirm,
    );
  }
}

class GPDialogTitle extends StatelessWidget {
  final String name;

  const GPDialogTitle(this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(name);
  }
}
