import 'package:moamoa/features/statistics/domain/entities/category_breakdown.dart';

/// 전월 대비 비교 데이터
class ComparisonData {
  /// 전월 대비 차이 금액 (양수: 증가, 음수: 감소)
  final int diff;

  /// 전월 대비 증감률 (%) (양수: 증가, 음수: 감소)
  final double diffPercentage;

  const ComparisonData({
    required this.diff,
    required this.diffPercentage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ComparisonData &&
          runtimeType == other.runtimeType &&
          diff == other.diff &&
          diffPercentage == other.diffPercentage;

  @override
  int get hashCode => Object.hash(diff, diffPercentage);
}

/// 월간 통계 엔티티
class MonthlyStatistics {
  /// 장부 ID
  final String accountBookId;

  /// 장부 이름
  final String accountBookName;

  /// 총 지출 금액
  final int totalAmount;

  /// 카테고리별 지출 내역 리스트 (금액 기준 내림차순)
  final List<CategoryBreakdown> categoryBreakdown;

  /// 전월 대비 증감 정보
  final ComparisonData comparisonWithLastMonth;

  const MonthlyStatistics({
    required this.accountBookId,
    required this.accountBookName,
    required this.totalAmount,
    required this.categoryBreakdown,
    required this.comparisonWithLastMonth,
  });

  /// 빈 상태 체크
  bool get isEmpty => totalAmount == 0 && categoryBreakdown.isEmpty;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthlyStatistics &&
          runtimeType == other.runtimeType &&
          accountBookId == other.accountBookId &&
          totalAmount == other.totalAmount &&
          _listEquals(categoryBreakdown, other.categoryBreakdown);

  @override
  int get hashCode =>
      Object.hash(accountBookId, totalAmount, categoryBreakdown);

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
