import 'dart:ui';

import 'package:chargestation/design.dart';
import 'package:chargestation/infrastructure/infrastructure.dart';

class AppWidgetSettings {
  final Language language;
  final ThemeType themeType;

  const AppWidgetSettings(
      {required this.language,
        required this.themeType,});
}

enum ThemeType {
  ///跟随系统
  followSystem(0, themeMode: ThemeMode.system, i18n: "setting_theme_system"),

  /// 亮色
  light(1, themeMode: ThemeMode.light, i18n: "setting_theme_light"),

  /// 暗色
  dark(2, themeMode: ThemeMode.dark, i18n: "setting_theme_dark"),
  ;

  const ThemeType(this.value, {required this.themeMode, required this.i18n});

  final int value;
  final ThemeMode themeMode;
  final String i18n;
  static final _theme = {
    followSystem.value: followSystem,
    light.value: light,
    dark.value: dark,
  };

  static ThemeType resolve(int value) => _theme[value] ?? followSystem;

  static List<ThemeType> get supportThemeList =>
      const [followSystem, light, dark];

  String get name => Intl.message(
        i18n,
        name: i18n,
        desc: '',
        args: null,
      );
}

enum Language {
  ///跟随系统
  followSystem(0, i18n: "setting_locale_system"),

  ///简体中文
  simplifiedChinese(1,
      locale: Locale("zh"), i18n: "setting_locale_zh_simple"),

  /// 英文
  english(2, locale: Locale("en"), i18n: "setting_locale_en"),
  ;

  const Language(this.value, {this.locale, required this.i18n});

  final int value;
  final Locale? locale;
  final String i18n;
  static final _language = {
    followSystem.value: followSystem,
    simplifiedChinese.value: simplifiedChinese,
    english.value: english,
  };

  static Language resolve(int value) => _language[value] ?? followSystem;

  static List<Language> get supportLanguageList =>
      const [followSystem, simplifiedChinese, english];

  String get name => Intl.message(
        i18n,
        name: i18n,
        desc: '',
        args: null,
      );
}
