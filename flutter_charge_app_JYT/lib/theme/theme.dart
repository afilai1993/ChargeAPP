import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

part 'colors.dart';

const ColorScheme lightColorScheme = ColorScheme.light(
    background: LightColors.background,
    primaryContainer: LightColors.primaryContainer,
    onPrimaryContainer: LightColors.onPrimaryContainer,
    primary: LightColors.primary,
    onPrimary: LightColors.onPrimary,
    surface: LightColors.surface,
    onBackground: LightColors.onBackground,
    onSurface: LightColors.onSurface,
    onSurfaceVariant: LightColors.onSurfaceVariant,
    outline: LightColors.outline,
    inverseSurface: LightColors.inverseSurface,
    onInverseSurface: LightColors.onInverseSurface);
const ColorScheme darkColorScheme = ColorScheme.dark(
    background: DarkColors.background,
    primaryContainer: DarkColors.primaryContainer,
    onPrimaryContainer: DarkColors.onPrimaryContainer,
    primary: DarkColors.primary,
    onPrimary: DarkColors.onPrimary,
    surface: DarkColors.surface,
    onBackground: DarkColors.onBackground,
    onSurface: DarkColors.onSurface,
    onSurfaceVariant: DarkColors.onSurfaceVariant,
    outline: DarkColors.outline,
    inverseSurface: DarkColors.inverseSurface,
    onInverseSurface: DarkColors.onInverseSurface);

final lightTheme = ThemeData(extensions: const [
  GPThemeData(
      successColor: LightColors.success,
      warningColor: LightColors.warning,
      appBarTitleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))
], brightness: Brightness.light, colorScheme: lightColorScheme);

final darkTheme = ThemeData(extensions: const [
  GPThemeData(
      successColor: DarkColors.success,
      warningColor: DarkColors.warning,
      appBarTitleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700))
], brightness: Brightness.dark, colorScheme: darkColorScheme);

class SystemUiOverlayStyles {
  static const SystemUiOverlayStyle light = SystemUiOverlayStyle(
    systemNavigationBarColor: LightColors.background,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
  );

  static const SystemUiOverlayStyle dark = SystemUiOverlayStyle(
    systemNavigationBarColor: DarkColors.background,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
  );

  static SystemUiOverlayStyle current(BuildContext context) {
    return isDarkMode(context) ? dark : light;
  }

  static isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}

extension SizeExtension on BuildContext {
  double get statusBarHeight =>
      MediaQueryData.fromView(View.of(this)).padding.top;

  double get screenWidth => MediaQueryData.fromView(View.of(this)).size.width;
}

extension ThemeDataExtension on BuildContext {
  TextStyle get appBarTitleStyle =>
      Theme.of(this).extension<GPThemeData>()!.appBarTitleStyle;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get primaryColor => Theme.of(this).colorScheme.primary;

  Color get onPrimary => Theme.of(this).colorScheme.onPrimary;

  /// 背景色，用于滚动
  Color get backgroundColor => Theme.of(this).colorScheme.background;

  /// 在背景色上显示的元素
  Color get onBackgroundColor => Theme.of(this).colorScheme.onBackground;

  /// 表面色，用于放在滚动视图的列表项灯
  Color get surfaceColor => Theme.of(this).colorScheme.surface;

  /// 表面色之上的主元素
  Color get onSurface => Theme.of(this).colorScheme.onSurface;

  /// 表面色之上的二次元素
  Color get onSurfaceVariant => Theme.of(this).colorScheme.onSurfaceVariant;

  Color get primaryContainerColor =>
      Theme.of(this).colorScheme.primaryContainer;

  Color get onPrimaryContainer => Theme.of(this).colorScheme.onPrimaryContainer;

  Color get outlineColor => Theme.of(this).colorScheme.outline;
  /// snackBar or toast background
  Color get inverseSurface => Theme.of(this).colorScheme.inverseSurface;

  /// on snackBar or toast
  Color get onInverseSurface => Theme.of(this).colorScheme.onInverseSurface;

  Color get successColor =>
      Theme.of(this).extension<GPThemeData>()!.successColor;

  Color get warningColor =>
      Theme.of(this).extension<GPThemeData>()!.warningColor;
}

class GPThemeData extends ThemeExtension<GPThemeData> {
  final TextStyle appBarTitleStyle;
  final Color successColor;
  final Color warningColor;

  const GPThemeData(
      {required this.successColor,
      required this.warningColor,
      required this.appBarTitleStyle});

  @override
  ThemeExtension<GPThemeData> copyWith() {
    return this;
  }

  @override
  ThemeExtension<GPThemeData> lerp(
      covariant ThemeExtension<GPThemeData>? other, double t) {
    if (other is! GPThemeData) {
      return this;
    }
    return GPThemeData(
        successColor: successColor,
        warningColor: warningColor,
        appBarTitleStyle: appBarTitleStyle.copyWith(
            color: Color.lerp(
                appBarTitleStyle.color, other.appBarTitleStyle.color, t)));
  }
}
