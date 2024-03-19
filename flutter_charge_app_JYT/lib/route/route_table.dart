part of 'router.dart';

typedef RouterWidgetBuilder = Widget Function(
    BuildContext context, dynamic arguments);

class RouteInfo {
  final String path;
  final bool needLogin;
  final bool isVerify;
  final RouterWidgetBuilder builder;

  RouteInfo(this.path, this.builder,
      {this.needLogin = false, this.isVerify = false});
}

class RouteTable {
  final Map<String, RouteInfo> _routes = <RouteInfo>[
    RouteInfo("/web", (context, arguments) => WebScreen(url: arguments["url"])),
    RouteInfo("/", (context, arguments) => HomeScreen()),
    //RouteInfo("/", (context, arguments) =>  HouseholdHomeScreen()),
    RouteInfo("/login", (context, arguments) => const LoginScreen()),
    RouteInfo("/profile", (context, arguments) => const UserProfileScreen(),
        needLogin: true),
    RouteInfo("/register", (context, arguments) => const RegisterScreen()),
    RouteInfo("/forgotPassword",
        (context, arguments) => const ForgotPasswordScreen()),
    RouteInfo(
        "/resetPassword", (context, arguments) => const ResetPasswordScreen(),
        needLogin: true),
    RouteInfo("/scan", (context, arguments) => const ScanScreen()),
    RouteInfo(
        "/scan/bluetooth", (context, arguments) => const ScanBluetoothScreen()),
    // RouteInfo(
    //     "/scan/bluetooth", (context, arguments) => const ScanWifiScreen()),
    RouteInfo(
        "/household/device",
        (context, arguments) =>
            HouseholdDeviceDetailScreen(address: arguments["address"])),
    RouteInfo("/household/task/editor",
        (context, arguments) => HouseHoldTaskEditorScreen(id: arguments["id"])),
    RouteInfo("/household/statistic",
        (context, arguments) => const ChargeStatisticScreen()),
    RouteInfo(
        "/user/verification",
        (context, arguments) => VerificationUserScreen(
              arguments: arguments,
            )),
    RouteInfo(
        "/user/editEmail",
        isVerify: true,
        (context, arguments) => const EditEmailScreen()),
    RouteInfo("/settings", (context, arguments) => const SettingsScreen())
  ].associateBy((item) => item.path);

  RouteTable();

  RouteInfo? getRouterInfo(String path) {
    return _routes[path];
  }
}
