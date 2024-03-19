import 'package:chargestation/repository/http_client.dart';

part 'impl/security_case_impl.dart';

abstract class SecurityCase {
  factory SecurityCase() => _SecurityCaseImpl();

  Future forgetPassword(
      {required String password, required String email, required String code});

  Future resetPasswordPassword(
      {required String password, required String email, required String code});

  Future modifyEmail(
      {required String oldEmail,
      required String newEmail,
      required String code});

  Future determine(String code);


}
