import 'dart:ui';

import 'package:chargestation/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class Localization {
  final localizationsDelegates = [
    GlobalMaterialLocalizations.delegate, // 指定本地化的字符串和一些其他的值
    GlobalCupertinoLocalizations.delegate, // 对应的Cupertino风格
    GlobalWidgetsLocalizations.delegate, // 指定默认的文本排列方向, 由左到右或由右到左
    S.delegate, //intl
  ];

  List<Locale> get supportedLocales {
    return S.delegate.supportedLocales;
  }
}
