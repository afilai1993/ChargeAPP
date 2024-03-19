import 'dart:io';

import 'package:chargestation/repository/contants.dart';
import 'package:path_provider/path_provider.dart';

import 'kv_store.dart';

final SettingsStore settingsStore = SettingsStore(JsonStore(() =>
    getApplicationSupportDirectory()
        .then((dir) => File("${dir.path}${Platform.pathSeparator}user.json"))));

class SettingsStore {
  final KVDataStore store;

  SettingsStore(this.store);

  set language(Language language) =>
      store.saveValue("language", language.value);

  Stream<Language> get watchLanguage => store
      .watchValue<int?>("language")
      .map((event) => Language.resolve(event ?? 0));

  Language get language =>
      Language.resolve(store.getValue<int?>("language") ?? 0);

  set themeType(ThemeType themeType) =>
      store.saveValue("themeType", themeType.value);

  Stream<ThemeType> get watchThemeType => store
      .watchValue<int?>("themeType")
      .map((event) => ThemeType.resolve(event ?? 0));

  Stream<AppWidgetSettings> get watchAppWidgetSettings =>
      store.watchValues(const ["language", "themeType"]).map((event) {
        return AppWidgetSettings(
            language: Language.resolve((event["language"] as int?) ?? -1),
            themeType: ThemeType.resolve((event["themeType"] as int?) ?? -1));
      });

  AppWidgetSettings get appWidgetSettings =>
      AppWidgetSettings(language: language, themeType: themeType);

  ThemeType get themeType =>
      ThemeType.resolve(store.getValue<int?>("themeType") ?? 0);
}
