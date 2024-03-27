import 'package:chargestation/infrastructure/infrastructure.dart';
import 'package:chargestation/infrastructure/utils/iterables.dart';
import 'package:flutter/services.dart';

import '../design.dart';
import '../screen/screen.dart';

part 'route_table.dart';

///Flutter无context页面跳转及获取全局context
final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>(); //全局上下文

class RouterManager {
  final RouteTable routeTable =  RouteTable();

  List<Route<dynamic>> onGenerateInitialRoutes(String initialRoute) {
    final settings = RouteSettings(name: initialRoute);
    List<Route<dynamic>> list = [];
    if (initialRoute != "/") {
      const splashSetting = RouteSettings(name: "/");
      list.add(routeFactory(splashSetting)!);
    }
    list.add(routeFactory(settings)!);
    return list;
  }

  Route<dynamic>? routeFactory(RouteSettings settings) => createRoute(
      settings: settings,
      builder: (context) {
        final name = settings.name;
        final arguments = settings.arguments;
        if (name == null) {
          return _UnknownRouteWidget(name, arguments);
        }
        final routeInfo = routeTable.getRouterInfo(name);
        if (routeInfo == null) {
          return _UnknownRouteWidget(name, arguments);
        }
        if (routeInfo.isVerify && isNotVerified(arguments)) {
          return routeTable
              .getRouterInfo("/user/verification")!
              .builder(context, {
            "nextRoute": name,
            "arguments": arguments,
          });
        }
        if (routeInfo.needLogin &&
            (userStore.getValue<String>("userId") ?? "").isEmpty) {
          return routeTable.getRouterInfo("/login")!.builder(context, null);
        }

        return routeInfo.builder(context, settings.arguments);
      });

  bool isNotVerified(Object? arguments) {
    if (arguments == null) {
      return true;
    }
    if (arguments is Map) {
      return arguments["&verify"] != true;
    }
    return true;
  }

  Route<T> createRoute<T>({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) =>
      MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) {
            final child = builder.call(context);
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyles.current(context),
              child: child,
            );
          });
}

class _UnknownRouteWidget extends StatelessWidget {
  final String? name;
  final dynamic arguments;

  const _UnknownRouteWidget(this.name, this.arguments);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Text(
          "Not Found Route:$name \nArguments:$arguments",
          style: const TextStyle(fontSize: 28),
        ),
      ),
    );
  }
}
