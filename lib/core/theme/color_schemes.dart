import 'package:flutter/material.dart';
import 'package:moneyflow/core/constants/app_constants.dart';

/// MoneyFlow App Color Schemes
/// ColorScheme만 정의 (ThemeData는 light_theme.dart에서)
class AppColorSchemes {
  AppColorSchemes._();

  /// Light Mode ColorScheme
  static const ColorScheme light = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primaryPink,
    onPrimary: AppColors.textWhite,
    primaryContainer: AppColors.primaryPinkLight,
    onPrimaryContainer: AppColors.textPrimary,
    secondary: AppColors.primaryPinkDark,
    onSecondary: AppColors.textWhite,
    secondaryContainer: AppColors.primaryPinkPale,
    onSecondaryContainer: AppColors.textPrimary,
    tertiary: AppColors.primaryPinkDark,
    onTertiary: AppColors.textWhite,
    tertiaryContainer: AppColors.primaryPinkLight,
    onTertiaryContainer: AppColors.textPrimary,
    error: AppColors.error,
    onError: AppColors.textWhite,
    errorContainer: Color(0xFFfecaca),
    onErrorContainer: Color(0xFF991b1b),
    surface: AppColors.backgroundWhite,
    onSurface: AppColors.textPrimary,
    surfaceContainerHighest: AppColors.backgroundGray,
    onSurfaceVariant: AppColors.textSecondary,
    outline: AppColors.border,
    outlineVariant: AppColors.divider,
    shadow: AppColors.shadow,
    scrim: Color(0x80000000),
    inverseSurface: AppColors.textPrimary,
    onInverseSurface: AppColors.textWhite,
    inversePrimary: AppColors.primaryPinkLight,
  );

  /// Dark Mode ColorScheme
  static const ColorScheme dark = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryPink,
    onPrimary: AppColors.textPrimary,
    primaryContainer: AppColors.primaryPinkDark,
    onPrimaryContainer: AppColors.textWhite,
    secondary: AppColors.primaryPinkLight,
    onSecondary: AppColors.textPrimary,
    secondaryContainer: AppColors.primaryPink,
    onSecondaryContainer: AppColors.textWhite,
    tertiary: AppColors.primaryPinkLight,
    onTertiary: AppColors.textPrimary,
    tertiaryContainer: AppColors.primaryPinkDark,
    onTertiaryContainer: AppColors.textWhite,
    error: Color(0xFFfca5a5),
    onError: AppColors.textPrimary,
    errorContainer: Color(0xFF7f1d1d),
    onErrorContainer: Color(0xFFfecaca),
    surface: Color(0xFF1a1a1a),
    onSurface: Color(0xFFe5e5e5),
    surfaceContainerHighest: Color(0xFF2a2a2a),
    onSurfaceVariant: Color(0xFFb3b3b3),
    outline: Color(0xFF404040),
    outlineVariant: Color(0xFF2a2a2a),
    shadow: Color(0x80000000),
    scrim: Color(0xCC000000),
    inverseSurface: Color(0xFFe5e5e5),
    onInverseSurface: Color(0xFF1a1a1a),
    inversePrimary: AppColors.primaryPinkDark,
  );
}
