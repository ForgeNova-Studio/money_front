/// 카테고리별 지출 엔티티
class CategoryBreakdown {
  /// 카테고리 코드 (FOOD, TRANSPORT 등)
  final String category;

  /// 해당 카테고리의 지출 금액
  final int amount;

  /// 전체 지출 대비 비율 (0-100)
  final int percentage;

  const CategoryBreakdown({
    required this.category,
    required this.amount,
    required this.percentage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryBreakdown &&
          runtimeType == other.runtimeType &&
          category == other.category &&
          amount == other.amount &&
          percentage == other.percentage;

  @override
  int get hashCode => Object.hash(category, amount, percentage);

  @override
  String toString() =>
      'CategoryBreakdown(category: $category, amount: $amount, percentage: $percentage%)';
}
