import 'package:flutter/material.dart';
import 'package:moneyflow/core/constants/expense_categories.dart';

String resolveExpenseCategoryLabel(String code) {
  for (final category in DefaultExpenseCategories.all) {
    if (category.id == code) {
      return category.name;
    }
  }
  return code;
}

IconData resolveExpenseCategoryIcon(String code) {
  for (final category in DefaultExpenseCategories.all) {
    if (category.id == code) {
      return expenseIconFromName(category.icon);
    }
  }
  return Icons.category;
}

IconData expenseIconFromName(String? iconName) {
  switch (iconName) {
    case 'restaurant':
      return Icons.restaurant;
    case 'local_cafe':
      return Icons.local_cafe;
    case 'directions_bus':
      return Icons.directions_bus;
    case 'home':
      return Icons.home;
    case 'wifi':
      return Icons.wifi;
    case 'subscriptions':
      return Icons.subscriptions;
    case 'home_repair_service':
      return Icons.home_repair_service;
    case 'shopping_bag':
      return Icons.shopping_bag;
    case 'medical_services':
      return Icons.medical_services;
    case 'verified_user':
      return Icons.verified_user;
    case 'school':
      return Icons.school;
    case 'movie':
      return Icons.movie;
    case 'flight_takeoff':
      return Icons.flight_takeoff;
    case 'pets':
      return Icons.pets;
    case 'card_giftcard':
      return Icons.card_giftcard;
    case 'volunteer_activism':
      return Icons.volunteer_activism;
    case 'help_outline':
      return Icons.help_outline;
    case 'more_horiz':
      return Icons.more_horiz;
    default:
      return Icons.category;
  }
}
