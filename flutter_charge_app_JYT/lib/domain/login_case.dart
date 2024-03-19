import 'package:chargestation/repository/http_client.dart';
import 'package:chargestation/infrastructure/infrastructure.dart';

part 'impl/login_case_impl.dart';

abstract class LoginCase {
  factory LoginCase() => _LoginCaseImpl();

  Future login(String email, String password);

  Future register(
      {required String username,
      required String email,
      required String password,
      required String code});
}
