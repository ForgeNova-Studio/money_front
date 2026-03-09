import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/income_categories.dart';

String resolveIncomeCategoryLabel(String code) {
  for (final category in DefaultIncomeCategories.all) {
    if (category.id == code) {
      return category.name;
    }
  }
  return code;
}

String? resolveIncomeCategoryImage(String code) {
  for (final category in DefaultIncomeCategories.all) {
    if (category.id == code) {
      return category.icon;
    }
  }
  return null;
}

IconData resolveIncomeCategoryIcon(String code) {
  // Income categories primarily use images, so return a default icon
  // or map to icons if you have specific icon mappings.
  return Icons.attach_money;
}
