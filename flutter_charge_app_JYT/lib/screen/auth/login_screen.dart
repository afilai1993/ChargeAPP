import 'package:chargestation/component/component.dart';
import 'package:chargestation/design.dart';
import 'package:chargestation/domain/domain.dart';
import 'package:chargestation/domain/login_case.dart';
import 'package:chargestation/infrastructure/dispose.dart';
import 'package:chargestation/infrastructure/infrastructure.dart';
import 'package:chargestation/infrastructure/utils/string_extension.dart';

import 'auth_component.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with StateAutoDisposeOwner {
  late final TapGestureRecognizer userAgreementRecognizer;
  late final TapGestureRecognizer privacyPolicyRecognizer;
  late final TextEditingController emailEditingController;
  late final TextEditingController passwordEditingController;
  late BoolStateRef loginLoading = BoolStateRef();
  final _formKey = GlobalKey<FormState>();
  final isCheckAgreement = BoolStateRef();
  static const policyUrl =
      "https://www.goproled.com/policy/privacyPolicy/index.html";

  @override
  void initState() {
    super.initState();
    userAgreementRecognizer = TapGestureRecognizer().autoDispose(this)
      ..onTap = () {
        context.navigateTo("/web", arguments: {"url": policyUrl});
      };
    privacyPolicyRecognizer = TapGestureRecognizer().autoDispose(this)
      ..onTap = () {
        context.navigateTo("/web", arguments: {"url": policyUrl});
      };
    passwordEditingController = TextEditingController();
    emailEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return GPScaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: context.isDarkMode
            ? null
            : BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: Image.asset("public/images/bg_auth.png").image),
              ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: context.statusBarHeight + 10,
              ),
              SizedBox(
                width: context.screenWidth * 0.88,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.current.hello,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 24),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(S.current.welcome,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18)),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Card(
                      margin: const EdgeInsets.only(top: 35),
                      child: SizedBox(
                        width: context.screenWidth * 0.88,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 48,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: GeneralAuthTextField(
                                  autofocus: true,
                                  validator: (text) {
                                    if (text == null || text.isBlank) {
                                      return S.current.validate_input_email;
                                    }
                                    return null;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  controller: emailEditingController,
                                  labelText: S.current.email,
                                  textInputAction: TextInputAction.next,
                                  prefixIcon: const Icon(Icons.email),
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                child: AuthPasswordTextField(
                                  validator: (text) {
                                    if (text == null || text.isBlank) {
                                      return S.current.validate_input_password;
                                    }
                                    return null;
                                  },
                                  passwordEditingController,
                                  textInputAction: TextInputAction.next,
                                  prefixIcon: const Icon(Icons.password),
                                  labelText: S.current.password,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: RefProvider(
                                    loginLoading,
                                    builder: (_, ref, child) => GPFilledButton(
                                        text: S.current.login,
                                        isLoading: ref.value ?? false,
                                        onPressed: login),
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  RefProvider(isCheckAgreement,
                                      builder: (_, ref, child) => Checkbox(
                                          value: ref.value,
                                          onChanged: (isChecked) {
                                            ref.value = isChecked;
                                          })),
                                  Expanded(
                                    child: Text.rich(TextSpan(children: [
                                      TextSpan(text: S.current.agree),
                                      const TextSpan(text: " "),
                                      TextSpan(
                                          recognizer: userAgreementRecognizer,
                                          text: S.current.user_agreement,
                                          style: TextStyle(
                                              color: context.primaryColor)),
                                      const TextSpan(text: " "),
                                      TextSpan(text: S.current.and),
                                      const TextSpan(text: " "),
                                      TextSpan(
                                          recognizer: privacyPolicyRecognizer,
                                          text: S.current.privacy_policy,
                                          style: TextStyle(
                                              color: context.primaryColor)),
                                    ])),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        context.navigateTo("/register");
                                      },
                                      child: Text(S.current.register)),
                                  const Expanded(child: SizedBox()),
                                  TextButton(
                                      onPressed: () {
                                        context.navigateTo("/forgotPassword");
                                      },
                                      child: Text(S.current.forget_password)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const GPAssetImageWidget(
                      "ic_logo.png",
                      width: 70,
                      height: 70,
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

  void login() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState?.validate() == true) {
      if (!(isCheckAgreement.value ?? false)) {
        showToast(S.current.validate_check_agreement);
        return;
      }
      uiTask
          .options(UITaskOption(loadingRef: loginLoading))
          .run(findCase<LoginCase>().login(
              emailEditingController.text, passwordEditingController.text))
          .onSuccess((result) {
        showToast(S.current.success_login);
        context.navigateBack();
      });
    }
  }
}
