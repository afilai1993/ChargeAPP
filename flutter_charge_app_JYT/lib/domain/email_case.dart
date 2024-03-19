import 'package:chargestation/infrastructure/infrastructure.dart';
import 'package:chargestation/repository/http_client.dart';

part 'impl/email_case_impl.dart';

enum SendEmailType {
  register("register"),
  editEmail("editEmail"),
  retrieve("retrieve"),
  determine("determine");

  final String value;

  const SendEmailType(this.value);
}

abstract class EmailCase {
  factory EmailCase() => _EmailCaseImpl();

  ///获取验证码
  Future sendCode(String email, SendEmailType type);
}
