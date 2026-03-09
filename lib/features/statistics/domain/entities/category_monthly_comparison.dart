/// 카테고리별 비교 데이터
class CategoryComparison {
  /// 카테고리 코드 (FOOD, TRANSPORT 등)
  final String category;

  /// 이번 달 지출 금액
  final int currentAmount;

  /// 전월 지출 금액
  final int previousAmount;

  /// 전월 대비 차이 금액 (양수: 증가, 음수: 감소)
  final int diff;

  /// 전월 대비 증감률 (%) (양수: 증가, 음수: 감소, 전월 0이면 null)
  final double? diffPercentage;

  const CategoryComparison({
    required this.category,
    required this.currentAmount,
    required this.previousAmount,
    required this.diff,
    this.diffPercentage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryComparison &&
          runtimeType == other.runtimeType &&
          category == other.category &&
          currentAmount == other.currentAmount &&
          previousAmount == other.previousAmount &&
          diff == other.diff &&
          diffPercentage == other.diffPercentage;

  @override
  int get hashCode => Object.hash(
        category,
        currentAmount,
        previousAmount,
        diff,
        diffPercentage,
      );
}

/// 카테고리별 전월 대비 변화 엔티티
class CategoryMonthlyComparison {
  /// 장부 ID
  final String accountBookId;

  /// 장부 이름
  final String accountBookName;

  /// 년도
  final int year;

  /// 월 (1-12)
  final int month;

  /// 이번 달 총 지출
  final int currentMonthTotal;

  /// 전월 총 지출
  final int previousMonthTotal;

  /// 카테고리별 전월 대비 변화 리스트 (이번 달 금액 기준 내림차순)
  final List<CategoryComparison> categories;

  const CategoryMonthlyComparison({
    required this.accountBookId,
    required this.accountBookName,
    required this.year,
    required this.month,
    required this.currentMonthTotal,
    required this.previousMonthTotal,
    required this.categories,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryMonthlyComparison &&
          runtimeType == other.runtimeType &&
          accountBookId == other.accountBookId &&
          year == other.year &&
          month == other.month &&
          currentMonthTotal == other.currentMonthTotal &&
          previousMonthTotal == other.previousMonthTotal &&
          _listEquals(categories, other.categories);

  @override
  int get hashCode => Object.hash(
        accountBookId,
        year,
        month,
        currentMonthTotal,
        previousMonthTotal,
        categories,
      );

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
