import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// MoneyFlow App Text Theme
class AppTextTheme {
  AppTextTheme._();

  /// Light Text Theme (Noto Sans 기반)
  static TextTheme get light => GoogleFonts.notoSansTextTheme().copyWith(
        // Display Styles - 큰 제목
        displayLarge: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          height: 1.2,
          letterSpacing: -0.5,
        ),
        displayMedium: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          height: 1.2,
          letterSpacing: -0.5,
        ),
        displaySmall: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          height: 1.3,
          letterSpacing: -0.3,
        ),

        // Headline Styles - 섹션 제목
        headlineLarge: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        headlineMedium: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
        headlineSmall: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),

        // Title Styles - 카드/리스트 제목
        titleLarge: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        titleMedium: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),
        titleSmall: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          height: 1.4,
        ),

        // Body Styles - 본문
        bodyLarge: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          height: 1.5,
        ),
        bodyMedium: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          height: 1.5,
        ),
        bodySmall: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          height: 1.5,
        ),

        // Label Styles - 버튼/라벨
        labelLarge: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.4,
          letterSpacing: 0.1,
        ),
        labelMedium: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.4,
          letterSpacing: 0.1,
        ),
        labelSmall: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          height: 1.4,
          letterSpacing: 0.1,
        ),
      );

  /// Dark Text Theme (필요시 구현)
  static TextTheme get dark => light.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      );

  /// Pretendard 폰트 기반 (선택사항)
  /// pubspec.yaml에 Pretendard 폰트 추가 필요
  static TextTheme pretendardLight() {
    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 32,
        fontWeight: FontWeight.bold,
        height: 1.2,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.2,
        letterSpacing: -0.5,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 24,
        fontWeight: FontWeight.bold,
        height: 1.3,
        letterSpacing: -0.3,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      titleMedium: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 16,
        fontWeight: FontWeight.normal,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 14,
        fontWeight: FontWeight.normal,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 12,
        fontWeight: FontWeight.normal,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.1,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.4,
        letterSpacing: 0.1,
      ),
    );
  }
}
