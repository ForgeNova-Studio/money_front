enum AssetCategory {
  cash('CASH', '현금'),
  savings('SAVINGS', '예적금'),
  stock('STOCK', '주식'),
  crypto('CRYPTO', '암호화폐'),
  bond('BOND', '채권'),
  pension('PENSION', '연금'),
  realEstate('REAL_ESTATE', '부동산'),
  car('CAR', '자동차'),
  lentMoney('LENT_MONEY', '빌려준 돈'),
  other('OTHER', '기타');

  final String code;
  final String label;

  const AssetCategory(this.code, this.label);

  /// code로 카테고리 찾기
  static AssetCategory fromCode(String code) {
    return AssetCategory.values.firstWhere(
      (e) => e.code == code,
      orElse: () => AssetCategory.other,
    );
  }
}
