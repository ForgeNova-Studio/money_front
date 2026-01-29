import 'package:flutter/material.dart';

/// 자산 카테고리 enum
enum AssetCategory {
  cash('CASH', '현금', Icons.account_balance_wallet, 0xFF4CAF50),
  savings('SAVINGS', '예적금', Icons.savings, 0xFF2196F3),
  stock('STOCK', '주식', Icons.trending_up, 0xFF9C27B0),
  crypto('CRYPTO', '암호화폐', Icons.currency_bitcoin, 0xFF00BCD4),
  bond('BOND', '채권', Icons.receipt_long, 0xFF3F51B5),
  pension('PENSION', '연금', Icons.shield_outlined, 0xFF009688),
  realEstate('REAL_ESTATE', '부동산', Icons.home, 0xFFFF9800),
  car('CAR', '자동차', Icons.directions_car, 0xFF795548),
  lentMoney('LENT_MONEY', '빌려준 돈', Icons.handshake_outlined, 0xFF8BC34A),
  other('OTHER', '기타', Icons.more_horiz, 0xFF607D8B);

  final String code;
  final String label;
  final IconData icon;
  final int colorValue;

  const AssetCategory(this.code, this.label, this.icon, this.colorValue);

  Color get color => Color(colorValue);

  /// code로 카테고리 찾기
  static AssetCategory fromCode(String code) {
    return AssetCategory.values.firstWhere(
      (e) => e.code == code,
      orElse: () => AssetCategory.other,
    );
  }
}
