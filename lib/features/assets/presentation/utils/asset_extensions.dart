import 'package:flutter/material.dart';
import 'package:moamoa/features/assets/domain/entities/asset.dart';
import 'package:moamoa/features/assets/domain/entities/asset_category.dart';

extension AssetCategoryUI on AssetCategory {
  IconData get icon {
    switch (this) {
      case AssetCategory.cash:
        return Icons.account_balance_wallet;
      case AssetCategory.savings:
        return Icons.savings;
      case AssetCategory.stock:
        return Icons.trending_up;
      case AssetCategory.crypto:
        return Icons.currency_bitcoin;
      case AssetCategory.bond:
        return Icons.receipt_long;
      case AssetCategory.pension:
        return Icons.shield_outlined;
      case AssetCategory.realEstate:
        return Icons.home;
      case AssetCategory.car:
        return Icons.directions_car;
      case AssetCategory.lentMoney:
        return Icons.handshake_outlined;
      case AssetCategory.other:
        return Icons.more_horiz;
    }
  }

  Color get color {
    switch (this) {
      case AssetCategory.cash:
        return const Color(0xFF4CAF50);
      case AssetCategory.savings:
        return const Color(0xFF2196F3);
      case AssetCategory.stock:
        return const Color(0xFF9C27B0);
      case AssetCategory.crypto:
        return const Color(0xFF00BCD4);
      case AssetCategory.bond:
        return const Color(0xFF3F51B5);
      case AssetCategory.pension:
        return const Color(0xFF009688);
      case AssetCategory.realEstate:
        return const Color(0xFFFF9800);
      case AssetCategory.car:
        return const Color(0xFF795548);
      case AssetCategory.lentMoney:
        return const Color(0xFF8BC34A);
      case AssetCategory.other:
        return const Color(0xFF607D8B);
    }
  }
}

extension AssetUI on Asset {
  String get formattedAmount {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        );
  }
}
