import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'MoneyFlow';
  static const String appSlogan = '';
  static const String appLogo = '';
  static const String appVersion = '1.0.0';
}

/// MoneyFlow App Color Constants
/// 핑크 단색 (진한 톤) - #e88a9d → #f8bac8
class AppColors {
  AppColors._();

  // Primary Colors - Pink Tones (Monochrome)
  static const Color primaryPink = Color(0xFFf5a4b3); // 메인 핑크
  static const Color primaryPinkDark = Color(0xFFe88a9d); // 진한 핑크
  static const Color primaryPinkLight = Color(0xFFf8bac8); // 밝은 핑크
  static const Color primaryPinkPale = Color(0xFFfcd2da); // 매우 밝은 핑크

  // Secondary Colors - 보조 색상 (핑크 계열)
  static const Color secondaryPink = Color(0xFFf5a4b3);
  static const Color secondaryPinkDark = Color(0xFFe88a9d);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPinkDark, primaryPinkLight],
  );

  static const LinearGradient primaryGradientReverse = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPinkLight, primaryPinkDark],
  );

  static const LinearGradient softGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPink, primaryPinkLight],
  );

  static const LinearGradient deepGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPinkDark, primaryPink],
  );

  // Background Colors
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundGray = Color(0xFFF8F9FA);
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color backgroundPinkTint = Color(0xFFFFF5F7); // 핑크 배경

  // Text Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textPink = primaryPinkDark; // 핑크 텍스트

  // UI Element Colors
  static const Color divider = Color(0xFFF0F0F0);
  static const Color border = Color(0xFFEEEEEE);
  static const Color borderPink = Color(0xFFf8bac8); // 핑크 보더
  static const Color shadow = Color(0x1A000000); // 10% black
  static const Color shadowPink = Color(0x1Ae88a9d); // 핑크 그림자

  // Status Colors
  static const Color success = Color(0xFF10b981);
  static const Color error = Color(0xFFef4444);
  static const Color warning = Color(0xFFf59e0b);
  static const Color info = Color(0xFF3b82f6);

  // Calendar & Budget Colors
  static const Color calendarToday = primaryPink;
  static const Color budgetPositive = success;
  static const Color budgetNegative = error;

  // Accent Colors (핑크 톤 변형)
  static const Color accentPink1 = Color(0xFFffb3c1);
  static const Color accentPink2 = Color(0xFFffc9d6);
  static const Color accentPink3 = Color(0xFFffe0e9);

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

  // Backward Compatibility Aliases
  static const Color primary = primaryPink;
  static const Color primaryDark = primaryPinkDark;
  static const Color primaryLight = primaryPinkLight;
  static const Color secondary = success; // 보조 색상은 success 색상 사용
  static const Color background = backgroundGray;
  static const Color surface = backgroundWhite;
  static const Color textHint = textTertiary;
  static const Color borderLight = divider;
  static const Color income = success; // 수입 색상은 success(녹색) 사용
  static const Color expense = error; // 지출 색상은 error(빨강) 사용
}

class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.primaryPink,
    required this.primaryPinkDark,
    required this.primaryPinkLight,
    required this.primaryPinkPale,
    required this.secondaryPink,
    required this.secondaryPinkDark,
    required this.primaryGradient,
    required this.primaryGradientReverse,
    required this.softGradient,
    required this.deepGradient,
    required this.backgroundWhite,
    required this.backgroundGray,
    required this.backgroundLight,
    required this.backgroundPinkTint,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textWhite,
    required this.textPink,
    required this.divider,
    required this.border,
    required this.borderPink,
    required this.shadow,
    required this.shadowPink,
    required this.success,
    required this.error,
    required this.warning,
    required this.info,
    required this.calendarToday,
    required this.budgetPositive,
    required this.budgetNegative,
    required this.accentPink1,
    required this.accentPink2,
    required this.accentPink3,
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
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.textHint,
    required this.borderLight,
    required this.income,
    required this.expense,
  });

  final Color primaryPink;
  final Color primaryPinkDark;
  final Color primaryPinkLight;
  final Color primaryPinkPale;
  final Color secondaryPink;
  final Color secondaryPinkDark;
  final LinearGradient primaryGradient;
  final LinearGradient primaryGradientReverse;
  final LinearGradient softGradient;
  final LinearGradient deepGradient;
  final Color backgroundWhite;
  final Color backgroundGray;
  final Color backgroundLight;
  final Color backgroundPinkTint;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textWhite;
  final Color textPink;
  final Color divider;
  final Color border;
  final Color borderPink;
  final Color shadow;
  final Color shadowPink;
  final Color success;
  final Color error;
  final Color warning;
  final Color info;
  final Color calendarToday;
  final Color budgetPositive;
  final Color budgetNegative;
  final Color accentPink1;
  final Color accentPink2;
  final Color accentPink3;
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
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color secondary;
  final Color background;
  final Color surface;
  final Color textHint;
  final Color borderLight;
  final Color income;
  final Color expense;

  static const AppThemeColors light = AppThemeColors(
    primaryPink: AppColors.primaryPink,
    primaryPinkDark: AppColors.primaryPinkDark,
    primaryPinkLight: AppColors.primaryPinkLight,
    primaryPinkPale: AppColors.primaryPinkPale,
    secondaryPink: AppColors.secondaryPink,
    secondaryPinkDark: AppColors.secondaryPinkDark,
    primaryGradient: AppColors.primaryGradient,
    primaryGradientReverse: AppColors.primaryGradientReverse,
    softGradient: AppColors.softGradient,
    deepGradient: AppColors.deepGradient,
    backgroundWhite: AppColors.backgroundWhite,
    backgroundGray: AppColors.backgroundGray,
    backgroundLight: AppColors.backgroundLight,
    backgroundPinkTint: AppColors.backgroundPinkTint,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textTertiary: AppColors.textTertiary,
    textWhite: AppColors.textWhite,
    textPink: AppColors.textPink,
    divider: AppColors.divider,
    border: AppColors.border,
    borderPink: AppColors.borderPink,
    shadow: AppColors.shadow,
    shadowPink: AppColors.shadowPink,
    success: AppColors.success,
    error: AppColors.error,
    warning: AppColors.warning,
    info: AppColors.info,
    calendarToday: AppColors.calendarToday,
    budgetPositive: AppColors.budgetPositive,
    budgetNegative: AppColors.budgetNegative,
    accentPink1: AppColors.accentPink1,
    accentPink2: AppColors.accentPink2,
    accentPink3: AppColors.accentPink3,
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
    primary: AppColors.primary,
    primaryDark: AppColors.primaryDark,
    primaryLight: AppColors.primaryLight,
    secondary: AppColors.secondary,
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
    Color? primaryPink,
    Color? primaryPinkDark,
    Color? primaryPinkLight,
    Color? primaryPinkPale,
    Color? secondaryPink,
    Color? secondaryPinkDark,
    LinearGradient? primaryGradient,
    LinearGradient? primaryGradientReverse,
    LinearGradient? softGradient,
    LinearGradient? deepGradient,
    Color? backgroundWhite,
    Color? backgroundGray,
    Color? backgroundLight,
    Color? backgroundPinkTint,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textWhite,
    Color? textPink,
    Color? divider,
    Color? border,
    Color? borderPink,
    Color? shadow,
    Color? shadowPink,
    Color? success,
    Color? error,
    Color? warning,
    Color? info,
    Color? calendarToday,
    Color? budgetPositive,
    Color? budgetNegative,
    Color? accentPink1,
    Color? accentPink2,
    Color? accentPink3,
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
    Color? primary,
    Color? primaryDark,
    Color? primaryLight,
    Color? secondary,
    Color? background,
    Color? surface,
    Color? textHint,
    Color? borderLight,
    Color? income,
    Color? expense,
  }) {
    return AppThemeColors(
      primaryPink: primaryPink ?? this.primaryPink,
      primaryPinkDark: primaryPinkDark ?? this.primaryPinkDark,
      primaryPinkLight: primaryPinkLight ?? this.primaryPinkLight,
      primaryPinkPale: primaryPinkPale ?? this.primaryPinkPale,
      secondaryPink: secondaryPink ?? this.secondaryPink,
      secondaryPinkDark: secondaryPinkDark ?? this.secondaryPinkDark,
      primaryGradient: primaryGradient ?? this.primaryGradient,
      primaryGradientReverse:
          primaryGradientReverse ?? this.primaryGradientReverse,
      softGradient: softGradient ?? this.softGradient,
      deepGradient: deepGradient ?? this.deepGradient,
      backgroundWhite: backgroundWhite ?? this.backgroundWhite,
      backgroundGray: backgroundGray ?? this.backgroundGray,
      backgroundLight: backgroundLight ?? this.backgroundLight,
      backgroundPinkTint: backgroundPinkTint ?? this.backgroundPinkTint,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textWhite: textWhite ?? this.textWhite,
      textPink: textPink ?? this.textPink,
      divider: divider ?? this.divider,
      border: border ?? this.border,
      borderPink: borderPink ?? this.borderPink,
      shadow: shadow ?? this.shadow,
      shadowPink: shadowPink ?? this.shadowPink,
      success: success ?? this.success,
      error: error ?? this.error,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      calendarToday: calendarToday ?? this.calendarToday,
      budgetPositive: budgetPositive ?? this.budgetPositive,
      budgetNegative: budgetNegative ?? this.budgetNegative,
      accentPink1: accentPink1 ?? this.accentPink1,
      accentPink2: accentPink2 ?? this.accentPink2,
      accentPink3: accentPink3 ?? this.accentPink3,
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
      primary: primary ?? this.primary,
      primaryDark: primaryDark ?? this.primaryDark,
      primaryLight: primaryLight ?? this.primaryLight,
      secondary: secondary ?? this.secondary,
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
      primaryPink: Color.lerp(primaryPink, other.primaryPink, t)!,
      primaryPinkDark: Color.lerp(primaryPinkDark, other.primaryPinkDark, t)!,
      primaryPinkLight:
          Color.lerp(primaryPinkLight, other.primaryPinkLight, t)!,
      primaryPinkPale:
          Color.lerp(primaryPinkPale, other.primaryPinkPale, t)!,
      secondaryPink: Color.lerp(secondaryPink, other.secondaryPink, t)!,
      secondaryPinkDark:
          Color.lerp(secondaryPinkDark, other.secondaryPinkDark, t)!,
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
      backgroundPinkTint:
          Color.lerp(backgroundPinkTint, other.backgroundPinkTint, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textWhite: Color.lerp(textWhite, other.textWhite, t)!,
      textPink: Color.lerp(textPink, other.textPink, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderPink: Color.lerp(borderPink, other.borderPink, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      shadowPink: Color.lerp(shadowPink, other.shadowPink, t)!,
      success: Color.lerp(success, other.success, t)!,
      error: Color.lerp(error, other.error, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      calendarToday: Color.lerp(calendarToday, other.calendarToday, t)!,
      budgetPositive: Color.lerp(budgetPositive, other.budgetPositive, t)!,
      budgetNegative: Color.lerp(budgetNegative, other.budgetNegative, t)!,
      accentPink1: Color.lerp(accentPink1, other.accentPink1, t)!,
      accentPink2: Color.lerp(accentPink2, other.accentPink2, t)!,
      accentPink3: Color.lerp(accentPink3, other.accentPink3, t)!,
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
      primary: Color.lerp(primary, other.primary, t)!,
      primaryDark: Color.lerp(primaryDark, other.primaryDark, t)!,
      primaryLight: Color.lerp(primaryLight, other.primaryLight, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
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
