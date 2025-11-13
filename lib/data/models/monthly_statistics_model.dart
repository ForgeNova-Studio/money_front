/// 월간 통계 모델
///
/// 기능:
/// - 총 지출 금액
/// - 카테고리별 지출 내역
/// - 전월 대비 증감 정보
class MonthlyStatisticsModel {
  /// 총 지출 금액
  final double totalAmount;

  /// 카테고리별 지출 내역 리스트 (금액 기준 내림차순)
  final List<CategoryBreakdown> categoryBreakdown;

  /// 전월 대비 증감 정보
  final ComparisonData comparisonWithLastMonth;

  MonthlyStatisticsModel({
    required this.totalAmount,
    required this.categoryBreakdown,
    required this.comparisonWithLastMonth,
  });

  /// JSON에서 모델 생성
  factory MonthlyStatisticsModel.fromJson(Map<String, dynamic> json) {
    return MonthlyStatisticsModel(
      totalAmount: (json['totalAmount'] as num).toDouble(),
      categoryBreakdown: (json['categoryBreakdown'] as List)
          .map((item) => CategoryBreakdown.fromJson(item))
          .toList(),
      comparisonWithLastMonth:
          ComparisonData.fromJson(json['comparisonWithLastMonth']),
    );
  }

  /// 모델을 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'totalAmount': totalAmount,
      'categoryBreakdown': categoryBreakdown.map((item) => item.toJson()).toList(),
      'comparisonWithLastMonth': comparisonWithLastMonth.toJson(),
    };
  }
}

/// 카테고리별 지출 상세 정보
class CategoryBreakdown {
  /// 카테고리 코드 (FOOD, TRANSPORT 등)
  final String category;

  /// 해당 카테고리의 지출 금액
  final double amount;

  /// 전체 지출 대비 비율 (0-100)
  final int percentage;

  CategoryBreakdown({
    required this.category,
    required this.amount,
    required this.percentage,
  });

  /// JSON에서 모델 생성
  factory CategoryBreakdown.fromJson(Map<String, dynamic> json) {
    return CategoryBreakdown(
      category: json['category'] as String,
      amount: (json['amount'] as num).toDouble(),
      percentage: json['percentage'] as int,
    );
  }

  /// 모델을 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'amount': amount,
      'percentage': percentage,
    };
  }
}

/// 전월 대비 증감 데이터
class ComparisonData {
  /// 전월 대비 차이 금액 (양수: 증가, 음수: 감소)
  final double diff;

  /// 전월 대비 증감률 (%) (양수: 증가, 음수: 감소)
  final double diffPercentage;

  ComparisonData({
    required this.diff,
    required this.diffPercentage,
  });

  /// JSON에서 모델 생성
  factory ComparisonData.fromJson(Map<String, dynamic> json) {
    return ComparisonData(
      diff: (json['diff'] as num).toDouble(),
      diffPercentage: (json['diffPercentage'] as num).toDouble(),
    );
  }

  /// 모델을 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'diff': diff,
      'diffPercentage': diffPercentage,
    };
  }
}
