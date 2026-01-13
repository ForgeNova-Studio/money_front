import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'MoneyFlow';
  static const String appSlogan = '';
  static const String appLogo = '';
  static const String appVersion = '1.0.0';
}

/// MoneyFlow App Color Constants
/// Palette only: avoid direct UI usage. Prefer Theme.of(context).colorScheme
/// or AppThemeColors (context.appColors) for screen widgets.
/// 브랜드 단색 (진한 톤) - #e88a9d → #f8bac8
class AppColors {
  AppColors._();

  // Primary Colors - Butter Glow (Monochrome)
  static const Color primary = Color(0xFFf2d35e); // 메인 버터
  static const Color primaryDark = Color(0xFFcfa52b); // 진한 버터
  static const Color primaryLight = Color(0xFFffe8a3); // 밝은 버터
  static const Color primaryPale = Color(0xFFfff5d1); // 매우 밝은 버터

  // Secondary Colors - 보조 색상 (버터 계열)
  static const Color secondary = Color(0xFFf7dd83);
  static const Color secondaryDark = Color(0xFFcfa52b);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primaryLight],
  );

  static const LinearGradient primaryGradientReverse = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primaryDark],
  );

  static const LinearGradient softGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient deepGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primary],
  );

  // Background Colors
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundGray = Color(0xFFF8F9FA);
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundAccentTint = Color(0xFFFFF9E8); // 버터 배경

  // Text Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textAccent = primaryDark; // 버터 텍스트

  // UI Element Colors
  static const Color divider = Color(0xFFF0F0F0);
  static const Color border = Color(0xFFEEEEEE);
  static const Color borderAccent = Color(0xFFffe8a3); // 버터 보더
  static const Color shadow = Color(0x1A000000); // 10% black
  static const Color shadowAccent = Color(0x1Acfa52b); // 버터 그림자

  // Status Colors
  static const Color success = Color(0xFF10b981);
  static const Color error = Color(0xFFef4444);
  static const Color warning = Color(0xFFf59e0b);
  static const Color info = Color(0xFF3b82f6);

  // Calendar & Budget Colors
  static const Color calendarToday = primary;
  static const Color budgetPositive = success;
  static const Color budgetNegative = error;

  // Accent Colors (버터 톤 변형)
  static const Color accent1 = Color(0xFFffe09a);
  static const Color accent2 = Color(0xFFffedbf);
  static const Color accent3 = Color(0xFFfff5dc);

  // Black Scale
  static const Color black = Colors.black;
  static const Color black87 = Colors.black87;
  static const Color black54 = Colors.black54;
  static const Color black38 = Colors.black38;
  static const Color black26 = Colors.black26;
  static const Color black12 = Colors.black12;

  // Grey Scale
  static const Color gray900 = Color(0xFF1A1A1A);
  static const Color gray800 = Color(0xFF2A2A2A);
  static const Color gray700 = Color(0xFF3A3A3A);
  static const Color gray600 = Color(0xFF4A4A4A);
  static const Color gray500 = Color(0xFF6B6B6B);
  static const Color gray400 = Color(0xFF8A8A8A);
  static const Color gray300 = Color(0xFFAAAAAA);
  static const Color gray200 = Color(0xFFCCCCCC);
  static const Color gray100 = Color(0xFFEEEEEE);
  static const Color gray50 = Color(0xFFFAFAFA);

  // White Scale
  static const Color white = Colors.white;
  static const Color white70 = Colors.white70;
  static const Color white60 = Colors.white60;
  static const Color white54 = Colors.white54;
  static const Color white38 = Colors.white38;
  static const Color white30 = Colors.white30;
  static const Color white24 = Colors.white24;
  static const Color white12 = Colors.white12;
  static const Color white10 = Colors.white10;

  // Semantic aliases
  static const Color background = backgroundGray;
  static const Color surface = backgroundWhite;
  static const Color textHint = textTertiary;
  static const Color borderLight = divider;
  static const Color income = success; // 수입 색상은 success(녹색) 사용
  static const Color expense = error; // 지출 색상은 error(빨강) 사용
}

class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.primaryPale,
    required this.secondary,
    required this.secondaryDark,
    required this.primaryGradient,
    required this.primaryGradientReverse,
    required this.softGradient,
    required this.deepGradient,
    required this.backgroundWhite,
    required this.backgroundGray,
    required this.backgroundLight,
    required this.backgroundAccentTint,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textWhite,
    required this.textAccent,
    required this.divider,
    required this.border,
    required this.borderAccent,
    required this.shadow,
    required this.shadowAccent,
    required this.success,
    required this.error,
    required this.warning,
    required this.info,
    required this.calendarToday,
    required this.budgetPositive,
    required this.budgetNegative,
    required this.accent1,
    required this.accent2,
    required this.accent3,
    required this.black,
    required this.black87,
    required this.black54,
    required this.black38,
    required this.black26,
    required this.black12,
    required this.gray900,
    required this.gray800,
    required this.gray700,
    required this.gray600,
    required this.gray500,
    required this.gray400,
    required this.gray300,
    required this.gray200,
    required this.gray100,
    required this.gray50,
    required this.white,
    required this.white70,
    required this.white60,
    required this.white54,
    required this.white38,
    required this.white30,
    required this.white24,
    required this.white12,
    required this.white10,
    required this.background,
    required this.surface,
    required this.textHint,
    required this.borderLight,
    required this.income,
    required this.expense,
  });

  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color primaryPale;
  final Color secondary;
  final Color secondaryDark;
  final LinearGradient primaryGradient;
  final LinearGradient primaryGradientReverse;
  final LinearGradient softGradient;
  final LinearGradient deepGradient;
  final Color backgroundWhite;
  final Color backgroundGray;
  final Color backgroundLight;
  final Color backgroundAccentTint;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textWhite;
  final Color textAccent;
  final Color divider;
  final Color border;
  final Color borderAccent;
  final Color shadow;
  final Color shadowAccent;
  final Color success;
  final Color error;
  final Color warning;
  final Color info;
  final Color calendarToday;
  final Color budgetPositive;
  final Color budgetNegative;
  final Color accent1;
  final Color accent2;
  final Color accent3;
  final Color black;
  final Color black87;
  final Color black54;
  final Color black38;
  final Color black26;
  final Color black12;
  final Color gray900;
  final Color gray800;
  final Color gray700;
  final Color gray600;
  final Color gray500;
  final Color gray400;
  final Color gray300;
  final Color gray200;
  final Color gray100;
  final Color gray50;
  final Color white;
  final Color white70;
  final Color white60;
  final Color white54;
  final Color white38;
  final Color white30;
  final Color white24;
  final Color white12;
  final Color white10;
  final Color background;
  final Color surface;
  final Color textHint;
  final Color borderLight;
  final Color income;
  final Color expense;

  static const AppThemeColors light = AppThemeColors(
    primary: AppColors.primary,
    primaryDark: AppColors.primaryDark,
    primaryLight: AppColors.primaryLight,
    primaryPale: AppColors.primaryPale,
    secondary: AppColors.secondary,
    secondaryDark: AppColors.secondaryDark,
    primaryGradient: AppColors.primaryGradient,
    primaryGradientReverse: AppColors.primaryGradientReverse,
    softGradient: AppColors.softGradient,
    deepGradient: AppColors.deepGradient,
    backgroundWhite: AppColors.backgroundWhite,
    backgroundGray: AppColors.backgroundGray,
    backgroundLight: AppColors.backgroundLight,
    backgroundAccentTint: AppColors.backgroundAccentTint,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textTertiary: AppColors.textTertiary,
    textWhite: AppColors.textWhite,
    textAccent: AppColors.textAccent,
    divider: AppColors.divider,
    border: AppColors.border,
    borderAccent: AppColors.borderAccent,
    shadow: AppColors.shadow,
    shadowAccent: AppColors.shadowAccent,
    success: AppColors.success,
    error: AppColors.error,
    warning: AppColors.warning,
    info: AppColors.info,
    calendarToday: AppColors.calendarToday,
    budgetPositive: AppColors.budgetPositive,
    budgetNegative: AppColors.budgetNegative,
    accent1: AppColors.accent1,
    accent2: AppColors.accent2,
    accent3: AppColors.accent3,
    black: AppColors.black,
    black87: AppColors.black87,
    black54: AppColors.black54,
    black38: AppColors.black38,
    black26: AppColors.black26,
    black12: AppColors.black12,
    gray900: AppColors.gray900,
    gray800: AppColors.gray800,
    gray700: AppColors.gray700,
    gray600: AppColors.gray600,
    gray500: AppColors.gray500,
    gray400: AppColors.gray400,
    gray300: AppColors.gray300,
    gray200: AppColors.gray200,
    gray100: AppColors.gray100,
    gray50: AppColors.gray50,
    white: AppColors.white,
    white70: AppColors.white70,
    white60: AppColors.white60,
    white54: AppColors.white54,
    white38: AppColors.white38,
    white30: AppColors.white30,
    white24: AppColors.white24,
    white12: AppColors.white12,
    white10: AppColors.white10,
    background: AppColors.background,
    surface: AppColors.surface,
    textHint: AppColors.textHint,
    borderLight: AppColors.borderLight,
    income: AppColors.income,
    expense: AppColors.expense,
  );

  static const AppThemeColors dark = light;

  @override
  AppThemeColors copyWith({
    Color? primary,
    Color? primaryDark,
    Color? primaryLight,
    Color? primaryPale,
    Color? secondary,
    Color? secondaryDark,
    LinearGradient? primaryGradient,
    LinearGradient? primaryGradientReverse,
    LinearGradient? softGradient,
    LinearGradient? deepGradient,
    Color? backgroundWhite,
    Color? backgroundGray,
    Color? backgroundLight,
    Color? backgroundAccentTint,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textWhite,
    Color? textAccent,
    Color? divider,
    Color? border,
    Color? borderAccent,
    Color? shadow,
    Color? shadowAccent,
    Color? success,
    Color? error,
    Color? warning,
    Color? info,
    Color? calendarToday,
    Color? budgetPositive,
    Color? budgetNegative,
    Color? accent1,
    Color? accent2,
    Color? accent3,
    Color? black,
    Color? black87,
    Color? black54,
    Color? black38,
    Color? black26,
    Color? black12,
    Color? gray900,
    Color? gray800,
    Color? gray700,
    Color? gray600,
    Color? gray500,
    Color? gray400,
    Color? gray300,
    Color? gray200,
    Color? gray100,
    Color? gray50,
    Color? white,
    Color? white70,
    Color? white60,
    Color? white54,
    Color? white38,
    Color? white30,
    Color? white24,
    Color? white12,
    Color? white10,
    Color? background,
    Color? surface,
    Color? textHint,
    Color? borderLight,
    Color? income,
    Color? expense,
  }) {
    return AppThemeColors(
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryPale: primaryPale ?? this.primaryPale,
      secondary: secondary ?? this.secondary,
      secondaryDark: secondaryDark ?? this.secondaryDark,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      primaryGradientReverse:
          primaryGradientReverse ?? this.primaryGradientReverse,
      softGradient: softGradient ?? this.softGradient,
      deepGradient: deepGradient ?? this.deepGradient,
      backgroundWhite: backgroundWhite ?? this.backgroundWhite,
      backgroundGray: backgroundGray ?? this.backgroundGray,
      backgroundLight: backgroundLight ?? this.backgroundLight,
      backgroundAccentTint: backgroundAccentTint ?? this.backgroundAccentTint,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textWhite: textWhite ?? this.textWhite,
      textAccent: textAccent ?? this.textAccent,
      divider: divider ?? this.divider,
      border: border ?? this.border,
      borderAccent: borderAccent ?? this.borderAccent,
      shadow: shadow ?? this.shadow,
      shadowAccent: shadowAccent ?? this.shadowAccent,
      success: success ?? this.success,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      calendarToday: calendarToday ?? this.calendarToday,
      budgetPositive: budgetPositive ?? this.budgetPositive,
      budgetNegative: budgetNegative ?? this.budgetNegative,
      accent1: accent1 ?? this.accent1,
      accent2: accent2 ?? this.accent2,
      accent3: accent3 ?? this.accent3,
      black: black ?? this.black,
      black87: black87 ?? this.black87,
      black54: black54 ?? this.black54,
      black38: black38 ?? this.black38,
      black26: black26 ?? this.black26,
      black12: black12 ?? this.black12,
      gray900: gray900 ?? this.gray900,
      gray800: gray800 ?? this.gray800,
      gray700: gray700 ?? this.gray700,
      gray600: gray600 ?? this.gray600,
      gray500: gray500 ?? this.gray500,
      gray400: gray400 ?? this.gray400,
      gray300: gray300 ?? this.gray300,
      gray200: gray200 ?? this.gray200,
      gray100: gray100 ?? this.gray100,
      gray50: gray50 ?? this.gray50,
      white: white ?? this.white,
      white70: white70 ?? this.white70,
      white60: white60 ?? this.white60,
      white54: white54 ?? this.white54,
      white38: white38 ?? this.white38,
      white30: white30 ?? this.white30,
      white24: white24 ?? this.white24,
      white12: white12 ?? this.white12,
      white10: white10 ?? this.white10,
      background: background ?? this.background,
      surface: surface ?? this.surface,
      textHint: textHint ?? this.textHint,
      borderLight: borderLight ?? this.borderLight,
      income: income ?? this.income,
      expense: expense ?? this.expense,
    );
  }

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) {
      return this;
    }
    return AppThemeColors(
      primary: Color.lerp(primary, other.primary, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primaryLight:
          Color.lerp(primaryLight, other.primaryLight, t)!,
      primaryPale: Color.lerp(primaryPale, other.primaryPale, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      secondaryDark:
          Color.lerp(secondaryDark, other.secondaryDark, t)!,
      primaryGradient:
          LinearGradient.lerp(primaryGradient, other.primaryGradient, t)!,
      primaryGradientReverse: LinearGradient.lerp(
        primaryGradientReverse,
        other.primaryGradientReverse,
        t,
      )!,
      softGradient: LinearGradient.lerp(softGradient, other.softGradient, t)!,
      deepGradient: LinearGradient.lerp(deepGradient, other.deepGradient, t)!,
      backgroundWhite: Color.lerp(backgroundWhite, other.backgroundWhite, t)!,
      backgroundGray: Color.lerp(backgroundGray, other.backgroundGray, t)!,
      backgroundLight: Color.lerp(backgroundLight, other.backgroundLight, t)!,
      backgroundAccentTint:
          Color.lerp(backgroundAccentTint, other.backgroundAccentTint, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textWhite: Color.lerp(textWhite, other.textWhite, t)!,
      textAccent: Color.lerp(textAccent, other.textAccent, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderAccent: Color.lerp(borderAccent, other.borderAccent, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      shadowAccent: Color.lerp(shadowAccent, other.shadowAccent, t)!,
      success: Color.lerp(success, other.success, t)!,
      error: Color.lerp(error, other.error, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      calendarToday: Color.lerp(calendarToday, other.calendarToday, t)!,
      budgetPositive: Color.lerp(budgetPositive, other.budgetPositive, t)!,
      budgetNegative: Color.lerp(budgetNegative, other.budgetNegative, t)!,
      accent1: Color.lerp(accent1, other.accent1, t)!,
      accent2: Color.lerp(accent2, other.accent2, t)!,
      accent3: Color.lerp(accent3, other.accent3, t)!,
      black: Color.lerp(black, other.black, t)!,
      black87: Color.lerp(black87, other.black87, t)!,
      black54: Color.lerp(black54, other.black54, t)!,
      black38: Color.lerp(black38, other.black38, t)!,
      black26: Color.lerp(black26, other.black26, t)!,
      black12: Color.lerp(black12, other.black12, t)!,
      gray900: Color.lerp(gray900, other.gray900, t)!,
      gray800: Color.lerp(gray800, other.gray800, t)!,
      gray700: Color.lerp(gray700, other.gray700, t)!,
      gray600: Color.lerp(gray600, other.gray600, t)!,
      gray500: Color.lerp(gray500, other.gray500, t)!,
      gray400: Color.lerp(gray400, other.gray400, t)!,
      gray300: Color.lerp(gray300, other.gray300, t)!,
      gray200: Color.lerp(gray200, other.gray200, t)!,
      gray100: Color.lerp(gray100, other.gray100, t)!,
      gray50: Color.lerp(gray50, other.gray50, t)!,
      white: Color.lerp(white, other.white, t)!,
      white70: Color.lerp(white70, other.white70, t)!,
      white60: Color.lerp(white60, other.white60, t)!,
      white54: Color.lerp(white54, other.white54, t)!,
      white38: Color.lerp(white38, other.white38, t)!,
      white30: Color.lerp(white30, other.white30, t)!,
      white24: Color.lerp(white24, other.white24, t)!,
      white12: Color.lerp(white12, other.white12, t)!,
      white10: Color.lerp(white10, other.white10, t)!,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      borderLight: Color.lerp(borderLight, other.borderLight, t)!,
      income: Color.lerp(income, other.income, t)!,
      expense: Color.lerp(expense, other.expense, t)!,
    );
  }
}

extension AppThemeColorsX on BuildContext {
  AppThemeColors get appColors {
    return Theme.of(this).extension<AppThemeColors>() ?? AppThemeColors.light;
  }
}
