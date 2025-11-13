import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF5548C8);
  static const Color primaryLight = Color(0xFF9D97FF);

  // Secondary
  static const Color secondary = Color(0xFF00D9A0);

  // Background
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textHint = Color(0xFFADB5BD);

  // Border
  static const Color border = Color(0xFFDEE2E6);
  static const Color borderLight = Color(0xFFE9ECEF);

  // Category Colors
  static const Color categoryFood = Color(0xFFFF6B6B);
  static const Color categoryTransport = Color(0xFF4ECDC4);
  static const Color categoryShopping = Color(0xFFFFE66D);
  static const Color categoryCulture = Color(0xFFA8E6CF);
  static const Color categoryHousing = Color(0xFF95E1D3);
  static const Color categoryMedical = Color(0xFFF38181);
  static const Color categoryEducation = Color(0xFFAA96DA);
  static const Color categoryEvent = Color(0xFFFCBAD3);
  static const Color categoryEtc = Color(0xFFC7CEEA);

  // Status
  static const Color success = Color(0xFF28A745);
  static const Color error = Color(0xFFDC3545);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF17A2B8);

  // Get category color by code
  static Color getCategoryColor(String categoryCode) {
    switch (categoryCode) {
      case 'FOOD':
        return categoryFood;
      case 'TRANSPORT':
        return categoryTransport;
      case 'SHOPPING':
        return categoryShopping;
      case 'CULTURE':
        return categoryCulture;
      case 'HOUSING':
        return categoryHousing;
      case 'MEDICAL':
        return categoryMedical;
      case 'EDUCATION':
        return categoryEducation;
      case 'EVENT':
        return categoryEvent;
      default:
        return categoryEtc;
    }
  }
}
