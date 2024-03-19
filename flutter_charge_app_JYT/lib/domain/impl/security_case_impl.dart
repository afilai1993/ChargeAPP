part of '../security_case.dart';

class _SecurityCaseImpl implements SecurityCase {
  @override
  Future determine(String code) =>
      httpClient.get("/system/user/profile/determine", queries: {"code": code});

  @override
  Future forgetPassword(
          {required String password,
          required String email,
          required String code}) =>
      httpClient.put("/system/user/profile/forgetPwd", queries: {
        "password": password,
        "email": email,
        "code": code,
      });

  @override
  Future modifyEmail(
          {required String oldEmail,
          required String newEmail,
          required String code}) =>
      httpClient.put("/system/user/profile/editEmail", queries: {
        "oldEmail": oldEmail,
        "newEmail": newEmail,
        "code": code,
      });

  @override
  Future resetPasswordPassword(
          {required String password,
          required String email,
          required String code}) =>
      httpClient.put("/system/user/profile/resetPwd", queries: {
        "password": password,
        "email": email,
        "code": code,
      });
}
