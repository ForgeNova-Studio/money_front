/// 주간 통계 모델
///
/// 기능:
/// - 일별 지출 금액 (최근 7일)
/// - 최다 지출 카테고리
/// - 일평균 지출 금액
class WeeklyStatisticsModel {
  /// 일별 지출 내역 리스트 (날짜 기준 오름차순)
  final List<DailyExpense> dailyExpenses;

  /// 최다 지출 카테고리 (금액 기준)
  final String topCategory;

  /// 일평균 지출 금액
  final double averageDaily;

  WeeklyStatisticsModel({
    required this.dailyExpenses,
    required this.topCategory,
    required this.averageDaily,
  });

  /// JSON에서 모델 생성
  factory WeeklyStatisticsModel.fromJson(Map<String, dynamic> json) {
    return WeeklyStatisticsModel(
      dailyExpenses: (json['dailyExpenses'] as List)
          .map((item) => DailyExpense.fromJson(item))
          .toList(),
      topCategory: json['topCategory'] as String,
      averageDaily: (json['averageDaily'] as num).toDouble(),
    );
  }

  /// 모델을 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'dailyExpenses': dailyExpenses.map((item) => item.toJson()).toList(),
      'topCategory': topCategory,
      'averageDaily': averageDaily,
    };
  }
}

/// 일별 지출 정보
class DailyExpense {
  /// 날짜
  final DateTime date;

  /// 해당 날짜의 총 지출 금액
  final double amount;

  DailyExpense({
    required this.date,
    required this.amount,
  });

  /// JSON에서 모델 생성
  factory DailyExpense.fromJson(Map<String, dynamic> json) {
    return DailyExpense(
      date: DateTime.parse(json['date']),
      amount: (json['amount'] as num).toDouble(),
    );
  }

  /// 모델을 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String().split('T')[0], // yyyy-MM-dd 형식
      'amount': amount,
    };
  }
}
