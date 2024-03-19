import 'package:chargestation/component/component.dart';
import 'package:chargestation/domain/domain.dart';
import 'package:chargestation/infrastructure/infrastructure.dart';
import 'package:chargestation/infrastructure/utils/string_extension.dart';

import '../../design.dart';
import 'auth_component.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late final TextEditingController emailEditingController;
  late final TextEditingController passwordEditingController;
  late final AuthVerificationController authCodeEditingController;
  final _formKey = GlobalKey<FormState>();
  final submitLoading = BoolStateRef();

  @override
  void initState() {
    super.initState();
    passwordEditingController = TextEditingController();
    emailEditingController = TextEditingController();
    authCodeEditingController = AuthVerificationController();
  }

  @override
  void dispose() {
    super.dispose();
    authCodeEditingController.stopTimeCount();
  }

  @override
  Widget build(BuildContext context) {
    return GPScaffold(
      appBar: GPAppbar(
        title: GPAppBarTitle(S.current.reset_password),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: context.isDarkMode? null: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: Image.asset("public/images/bg_auth.png").image),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: context.statusBarHeight,
              ),
              Center(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Card(
                      margin: const EdgeInsets.only(top: 24),
                      child: SizedBox(
                        width: context.screenWidth * 0.9,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 24,
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.symmetric(
                              //       horizontal: 16.0),
                              //   child: GeneralAuthTextField(
                              //     readOnly: true,
                              //     validator: (text) {
                              //       if (text == null || text.isBlank) {
                              //         return S.current.validate_input_email;
                              //       }
                              //       return null;
                              //     },
                              //     keyboardType: TextInputType.emailAddress,
                              //     controller: emailEditingController,
                              //     labelText: S.current.email,
                              //     textInputAction: TextInputAction.next,
                              //     prefixIcon: const Icon(Icons.email),
                              //   ),
                              // ),
                              // const SizedBox(
                              //   height: 8,
                              // ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: AuthPasswordTextField(
                                  passwordEditingController,
                                  validator: (text) {
                                    if (text == null || text.isBlank) {
                                      return S.current.validate_input_password;
                                    }
                                    return null;
                                  },
                                  textInputAction: TextInputAction.next,
                                  prefixIcon: const Icon(Icons.password),
                                  labelText: S.current.new_password,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: AuthVerificationTextField(
                                  authCodeEditingController,
                                  validator: (text) {
                                    if (text == null || text.isBlank) {
                                      return S.current
                                          .validate_input_verification_code;
                                    }
                                    return null;
                                  },
                                  textInputAction: TextInputAction.done,
                                  prefixIcon: const Icon(Icons.verified),
                                  labelText: S.current.verification_code,
                                  onRetrieve: retrieveAuthCode,
                                ),
                              ),
                              const SizedBox(
                                height: 24,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: RefProvider(
                                    submitLoading,
                                    builder: (_, ref, child) => GPFilledButton(
                                        text: S.current.register,
                                        isLoading: ref.value ?? false,
                                        onPressed: submit),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submit() {
    if (_formKey.currentState?.validate() == true) {
      uiTask
          .options(UITaskOption(loadingRef: submitLoading))
          .run(findCase<SecurityCase>().forgetPassword(
              email: emailEditingController.text,
              password: passwordEditingController.text,
              code: authCodeEditingController.editingController.text))
          .onSuccess((result) {
        showToast(S.current.success_operation);
        context.navigateBack();
      });
    }
  }

  void retrieveAuthCode() {
    final email = emailEditingController.text;
    if (email.isBlank) {
      showToast(S.current.validate_input_email);
      return;
    }
    uiTask.options(UITaskOption(onLoadingChanged: (loading) {
      authCodeEditingController.loading = loading;
    })).run(Future(() async {
      final email = await userStore.asyncGetValue<String>("email") ?? "";
      return findCase<EmailCase>().sendCode(email, SendEmailType.retrieve);
    })).onSuccess((result) {
      showToast(S.current.success_send);
      authCodeEditingController.startTimeCount();
    });

    ;
  }
}
