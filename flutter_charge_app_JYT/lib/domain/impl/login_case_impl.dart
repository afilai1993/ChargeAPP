part of '../login_case.dart';

class _LoginCaseImpl implements LoginCase {
  @override
  Future login(String email, String password) async {
    final result = await httpClient
        .post("/login", data: {"email": email, "password": password});
    final Map<String, dynamic> saveData = {};
    saveData["token"] = result["token"];
    if (result["UserInformation"] == null) {
      final userInfo = await httpClient.get("/getInfo", headers: {
        HttpClient.authorizationHeader: result["token"],
      });
      saveData["userId"] = userInfo["user"]["userId"].toString();
      saveData["email"] = userInfo["user"]["email"];
      saveData["avatar"] = userInfo["user"]["avatar"];
      saveData["nickName"] = userInfo["user"]["nickName"];
    } else {
      saveData["userId"] =
          result["UserInformation"]["user"]["userId"].toString();
      saveData["email"] = result["UserInformation"]["user"]["email"];
      saveData["avatar"] = result["UserInformation"]["user"]["avatar"];
      saveData["nickName"] = result["UserInformation"]["user"]["nickName"];
    }
    await userStore.saveAll(saveData);
  }

  @override
  Future register(
          {required String username,
          required String email,
          required String password,
          required String code}) =>
      httpClient.post("/register", data: {
        "username": username,
        "password": password,
        "email": email,
        "code": code
      });
}
