import 'dart:async';
import 'dart:ui';

import 'package:chargestation/repository/contants.dart';
import 'package:chargestation/repository/store/settings_store.dart';

final AppLocale appLocale = AppLocale(settingsStore);

class AppLocale {
  Completer<Locale?> _completer = Completer<Locale?>();
  Locale? _deviceLocale;

  final SettingsStore settings;

  AppLocale(this.settings);

  void initDeviceLocale(Locale? locale) {
    if (_deviceLocale == null) {
      // 只有第一次才是最准确的
      _deviceLocale = locale;
      if (!_completer.isCompleted) {
        _completer.complete(locale);
      }
    }
  }

  Future<Locale> getCurrentLocale() async {
    final settingsLocale = (await settings.language).locale;
    if (settingsLocale != null) {
      return settingsLocale;
    }
    Locale? locale = _deviceLocale;
    locale ??= await _completer.future;
    if (locale == null) {
      return Language.english.locale!;
    }
    final code = locale.languageCode;
    if (code == "zh") {
      return Language.simplifiedChinese.locale!;
    } else {
      return Language.english.locale!;
    }
  }

  Locale getLocale(Language language) {
    final settingsLocale = language.locale;
    if (settingsLocale != null) {
      return settingsLocale;
    }
    final locale = _deviceLocale;
    if (locale == null) {
      return Language.english.locale!;
    }
    final code = locale.languageCode;
    if (code == "zh") {
      return Language.simplifiedChinese.locale!;
    } else {
      return Language.english.locale!;
    }
  }
}
