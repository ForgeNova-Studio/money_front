import 'package:flutter/material.dart';
import 'package:moneyflow/core/constants/app_constants.dart';
import 'package:moneyflow/core/theme/color_schemes.dart';
import 'package:moneyflow/core/theme/text_theme.dart';

/// Light Theme 빌더
ThemeData buildLightTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: AppColorSchemes.light,
    textTheme: AppTextTheme.light,
    scaffoldBackgroundColor: AppColors.backgroundGray,

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryPink,
      foregroundColor: AppColors.textWhite,
      elevation: 0,
      centerTitle: false,
      iconTheme: IconThemeData(color: AppColors.textWhite),
      titleTextStyle: TextStyle(
        color: AppColors.textWhite,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: AppColors.backgroundWhite,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      shadowColor: AppColors.shadowPink,
      margin: EdgeInsets.zero,
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryPink,
        foregroundColor: AppColors.textWhite,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        shadowColor: AppColors.shadowPink,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryPink,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryPink,
        side: const BorderSide(color: AppColors.primaryPink, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // FAB Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryPink,
      foregroundColor: AppColors.textWhite,
      elevation: 4,
      shape: CircleBorder(),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.backgroundWhite,
      selectedItemColor: AppColors.primaryPink,
      unselectedItemColor: AppColors.textTertiary,
      selectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      unselectedLabelStyle: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 12,
      ),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),

    // Navigation Bar Theme (Material 3)
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.backgroundWhite,
      indicatorColor: AppColors.primaryPinkPale,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryPink,
          );
        }
        return const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textTertiary,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(
            color: AppColors.primaryPink,
            size: 24,
          );
        }
        return const IconThemeData(
          color: AppColors.textTertiary,
          size: 24,
        );
      }),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.backgroundLight,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primaryPink,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 2,
        ),
      ),
      prefixIconColor: AppColors.primaryPink,
      suffixIconColor: AppColors.primaryPink,
      hintStyle: const TextStyle(
        color: AppColors.textTertiary,
        fontSize: 15,
      ),
      labelStyle: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 15,
      ),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.primaryPinkPale,
      selectedColor: AppColors.primaryPink,
      disabledColor: AppColors.gray100,
      labelStyle: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 14,
      ),
      secondaryLabelStyle: const TextStyle(
        color: AppColors.textWhite,
        fontSize: 14,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    // Dialog Theme
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.backgroundWhite,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      titleTextStyle: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      contentTextStyle: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 15,
        height: 1.5,
      ),
    ),

    // Progress Indicator Theme
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primaryPink,
      linearTrackColor: AppColors.primaryPinkPale,
      circularTrackColor: AppColors.primaryPinkPale,
    ),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),

    // Icon Theme
    iconTheme: const IconThemeData(
      color: AppColors.textSecondary,
      size: 24,
    ),

    // List Tile Theme
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      minLeadingWidth: 40,
      iconColor: AppColors.textSecondary,
      textColor: AppColors.textPrimary,
    ),

    // Snackbar Theme
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.gray800,
      contentTextStyle: const TextStyle(
        color: AppColors.textWhite,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      behavior: SnackBarBehavior.floating,
    ),

    // Bottom Sheet Theme
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.backgroundWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAlias,
    ),
  );
}

/// Dark Theme 빌더 (필요시 구현)
// ThemeData buildDarkTheme() {
//   return ThemeData(
//     useMaterial3: true,
//     colorScheme: AppColorSchemes.dark,
//     fontFamily: 'Pretendard',
//     scaffoldBackgroundColor: const Color(0xFF1a1a1a),
//     // 다크 테마 설정 추가
//   );
// }
