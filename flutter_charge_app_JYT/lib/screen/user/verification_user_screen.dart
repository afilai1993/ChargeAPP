import 'package:chargestation/component/component.dart';
import 'package:chargestation/design.dart';
import 'package:chargestation/domain/domain.dart';
import 'package:chargestation/generated/l10n.dart';
import 'package:chargestation/infrastructure/infrastructure.dart';
import 'package:chargestation/infrastructure/ref/verification_code_ref.dart';
import 'package:chargestation/infrastructure/utils/string_extension.dart';

class VerificationUserScreen extends StatefulWidget {
  final dynamic arguments;

  const VerificationUserScreen({this.arguments, super.key});

  @override
  State<VerificationUserScreen> createState() => _VerificationUserScreenState();
}

class _VerificationUserScreenState extends State<VerificationUserScreen> {
  final codeTextEditingController = TextEditingController();
  final verificationCodeRef = VerificationCodeRef();
  final verificationLoading = BoolStateRef();

  @override
  Widget build(BuildContext context) {
    return GPScaffold(
      appBar: GPAppbar(
        title: GPAppBarTitle(S.current.verification),
      ),
      body: Column(
        children: [
          _VerificationEditItem(
            label: S.current.email,
            body: StreamBuilder(
              stream: userStore.watchValue<String>("email"),
              builder: (_, snapShot) => Text(snapShot.data ?? ""),
            ),
          ),
          _VerificationEditItem(
            label: S.current.verification,
            body: TextField(
              maxLines: 1,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration:
                  InputDecoration.collapsed(hintText: S.current.verification),
              controller: codeTextEditingController,
            ),
            rightWidget: RefProvider(
              verificationCodeRef,
              builder: (_, ref, child) => GPFilledButton(
                style: ButtonStyle(
                    visualDensity: const VisualDensity(
                        horizontal: VisualDensity.minimumDensity,
                        vertical: VisualDensity.minimumDensity),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 25, horizontal: 10))),
                text: ref.countDown > 0
                    ? S.current.count_second(ref.countDown)
                    : S.current.retrieve,
                isLoading: ref.loading,
                onPressed: ref.countDown > 0 ? null : getCode,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(
                width: double.infinity,
                child: RefProvider(
                  verificationLoading,
                  builder: (_, ref, child) => GPFilledButton(
                      isLoading: ref.value ?? false,
                      text: S.current.verification,
                      onPressed: verification),
                )),
          )
        ],
      ),
    );
  }

  void verification() {
    final current = codeTextEditingController.text;
    if (current.isBlank) {
      showToast(S.current.validate_input_verification_code);
      return;
    }
    uiTask
        .options(UITaskOption(loadingRef: verificationLoading))
        .run(findCase<SecurityCase>().determine(codeTextEditingController.text))
        .onSuccess((result) {
      context.redirectTo(widget.arguments["nextRoute"] ?? "",
          arguments: {"&verify": true});
    });
  }

  void getCode() {
    uiTask
        .options(UITaskOption(onLoadingChanged: (loading) {
          verificationCodeRef.loading = loading;
        }))
        .run(findCase<EmailCase>().sendCode(
            userStore.getValue<String>("email") ?? "", SendEmailType.determine))
        .onSuccess((result) {
          verificationCodeRef.startTimeCount();
        });
  }

  @override
  void dispose() {
    super.dispose();
    verificationCodeRef.stopTimeCount();
  }
}

class _VerificationEditItem extends StatefulWidget {
  final String label;
  final Widget body;
  final Widget? rightWidget;

  const _VerificationEditItem(
      {super.key, required this.label, required this.body, this.rightWidget});

  @override
  State<_VerificationEditItem> createState() => _VerificationEditItemState();
}

class _VerificationEditItemState extends State<_VerificationEditItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(widget.label),
              const SizedBox(width: 8),
              Expanded(child: widget.body),
              if (widget.rightWidget != null) const SizedBox(width: 8),
              if (widget.rightWidget != null) widget.rightWidget!
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          const GPDivider()
        ],
      ),
    );
  }
}
