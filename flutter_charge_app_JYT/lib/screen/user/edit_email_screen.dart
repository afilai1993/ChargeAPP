import 'package:chargestation/component/component.dart';
import 'package:chargestation/design.dart';
import 'package:chargestation/domain/domain.dart';
import 'package:chargestation/infrastructure/infrastructure.dart';
import 'package:chargestation/infrastructure/ref/verification_code_ref.dart';
import 'package:chargestation/infrastructure/utils/string_extension.dart';

class EditEmailScreen extends StatefulWidget {
  const EditEmailScreen({super.key});

  @override
  State<EditEmailScreen> createState() => _EditEmailScreenState();
}

class _EditEmailScreenState extends State<EditEmailScreen> {
  final newEmailTextEditingController = TextEditingController();
  final codeTextEditingController = TextEditingController();
  final verificationCodeRef = VerificationCodeRef();
  final confirmLoading = BoolStateRef();

  @override
  Widget build(BuildContext context) {
    return GPScaffold(
      appBar: GPAppbar(
        title: GPAppBarTitle(S.current.modify_email),
      ),
      body: Column(
        children: [
          _EmailEditItem(
            label: S.current.new_email,
            body: TextField(
              maxLines: 1,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration:
                  InputDecoration.collapsed(hintText: S.current.new_email),
              controller: newEmailTextEditingController,
            ),
          ),
          _EmailEditItem(
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
                  confirmLoading,
                  builder: (_, ref, child) => GPFilledButton(
                      isLoading: ref.value ?? false,
                      text: S.current.verification,
                      onPressed: confirm),
                )),
          )
        ],
      ),
    );
  }

  void getCode() {
    uiTask
        .options(UITaskOption(onLoadingChanged: (loading) {
          verificationCodeRef.loading = loading;
        }))
        .run(findCase<EmailCase>().sendCode(
            userStore.getValue<String>("email") ?? "", SendEmailType.editEmail))
        .onSuccess((result) {
          verificationCodeRef.startTimeCount();
        });
  }

  void confirm() {
    final newEmail = newEmailTextEditingController.text;
    if (newEmail.isBlank) {
      showToast(S.current.validate_input_email);
      return;
    }
    final code = codeTextEditingController.text;
    if (newEmail.isBlank) {
      showToast(S.current.validate_input_verification_code);
      return;
    }
    uiTask
        .options(UITaskOption(onLoadingChanged: (loading) {
          verificationCodeRef.loading = loading;
        }))
        .run(findCase<SecurityCase>().modifyEmail(
            oldEmail: userStore.getValue<String>("email") ?? "",
            newEmail: newEmail,
            code: code))
        .onSuccess((result) {
          showToast(S.current.success_update);
          context.navigateBack();
        });
  }
}

class _EmailEditItem extends StatefulWidget {
  final String label;
  final Widget body;
  final Widget? rightWidget;

  const _EmailEditItem(
      {super.key, required this.label, required this.body, this.rightWidget});

  @override
  State<_EmailEditItem> createState() => _EmailEditItemState();
}

class _EmailEditItemState extends State<_EmailEditItem> {
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
