import 'package:chargestation/infrastructure/localization.dart';
import 'package:chargestation/repository/store/settings_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'component/toast.dart';
import 'design.dart';
import 'generated/l10n.dart';
import 'infrastructure/app_locale.dart';
import 'route/router.dart';

class AppWidget extends StatelessWidget {
  final RouterManager routerManager = RouterManager();
  final Localization localization = Localization();

  AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: settingsStore.watchAppWidgetSettings,
        builder: (_, snapShot) {
          final settings = snapShot.data ?? settingsStore.appWidgetSettings;
          return MaterialApp(
            onGenerateTitle: (context) => S.current.app_name,
            builder: EasyLoading.init(builder:toastBuilder()),
            debugShowCheckedModeBanner: !kReleaseMode,
            themeMode: settings.themeType.themeMode,
            //风格
            theme: lightTheme,
            darkTheme: darkTheme,
            //路由配置
            initialRoute: "/",
            //initialRoute: "/household/home",
            onGenerateInitialRoutes: routerManager.onGenerateInitialRoutes,
            navigatorKey: navigatorKey,
            onGenerateRoute: routerManager.routeFactory,
            //国际化
            supportedLocales: localization.supportedLocales,
            localizationsDelegates: localization.localizationsDelegates,
            localeResolutionCallback: (currentLocale, supportedLocales) {
              appLocale.initDeviceLocale(currentLocale);
              return appLocale.getLocale(settings.language);
            },
            //showPerformanceOverlay: true,
            locale: appLocale.getLocale(settings.language),
          );
        });
  }
}
