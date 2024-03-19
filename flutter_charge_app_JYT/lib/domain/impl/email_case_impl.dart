part of '../email_case.dart';

class _EmailCaseImpl implements EmailCase {
  @override
  Future sendCode(String email, SendEmailType type) {
    return httpClient
        .get("/sendCode", queries: {"email": email, "type": type.value});
  }
}
