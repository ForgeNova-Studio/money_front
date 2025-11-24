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
}
