part of '../user_case.dart';

class _UserCaseImpl implements UserCase {
  @override
  Future updateNickname(String nickname) async {
    await updateUserInfo({"nickName": nickname});
    await userStore.saveValue("nickName", nickname);
  }

  Future updateUserInfo(dynamic info) =>
      httpClient.put("/system/user/profile/edit", data: info);

  @override
  Future updateAvatar(File file) async {
    final compressFile = await _compressImage(file, width: 150, height: 150);
    final result = await httpClient.post("/system/user/profile/avatar",
        data: FormData.fromMap({
          "avatarfile": MultipartFile.fromFile(compressFile.path,
              filename: compressFile.name)
        }));
  }

  @override
  Future logout() {
    serviceEventBus.post(const RefreshAllDataChangedEvent());
    return userStore.clear();
  }

  @override
  Future unregister() async {
    serviceEventBus.post(const RefreshAllDataChangedEvent());
    await httpClient.put(
      "/system/user/profile/delete",
    );
    return userStore.clear();
  }
}

Future<File> _compressImage(File source, {int? width, int? height}) async {
  final dirPath = await getTemporaryDirectory()
      .then((value) => "${value.path}${Platform.pathSeparator}/compress");
  final dir = Directory(dirPath);
  if (!(await dir.exists())) {
    await dir.create(recursive: true);
  }
  final compressFile = File(
      "${dir.path}${Platform.pathSeparator}${DateFormat("yyyyMMddHHmmss").format(DateTime.now())}.png");
  return FlutterImageCompress.compressAndGetFile(
    source.absolute.path,
    compressFile.path,
    minWidth: width ?? 200,
    minHeight: height ?? 200,
    // rotate: 180,
    format: CompressFormat.png,
  ).then((value) => source);
}
