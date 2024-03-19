import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  PermissionUtils._();

  static Future<bool> checkPermissions(List<Permission> permissionList) async {
    for (var item in permissionList) {
      if (!(await item.isGranted)) {
        return false;
      }
    }
    return true;
  }

  static Future<bool> requestPermissions(List<Permission> permissionList) async {
    final result = await permissionList.request();
    for (var item in result.values) {
      if (item != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }
}
