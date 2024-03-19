import 'package:chargestation/component/button.dart';
import 'package:chargestation/infrastructure/infrastructure.dart';

import '../design.dart';

class GPActionBottomSheetTitle extends StatelessWidget {
  final BoolStateRef? loading;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GPTextButton(
            text: S.current.cancel,
            style: TextStyle(color: context.onSurface),
            onPressed: onCancel),
        Expanded(
            child: Text(
          title,
          textAlign: TextAlign.center,
        )),
        loading != null
            ? RefProvider(loading!,
                builder: (_, ref, child) => GPTextButton(
                      isLoading: ref.value ?? false,
                      text: S.current.confirm,
                      onPressed: onConfirm,
                    ))
            : GPTextButton(
                text: S.current.confirm,
                onPressed: onConfirm,
              )
      ],
    );
  }

  const GPActionBottomSheetTitle(
      {this.loading,
      required this.onCancel,
      required this.onConfirm,
      required this.title,
      super.key});
}
