/// 예산(목표 소비) 모델
///
/// 기능:
/// - 월별 목표 예산 설정
/// - 현재 소비 금액 계산
/// - 남은 금액 및 사용률 표시
class BudgetModel {
  /// 예산 ID
  final String? budgetId;

  /// 사용자 ID
  final String? userId;

  /// 년도
  final int year;

  /// 월 (1-12)
  final int month;

  /// 목표 금액
  final double targetAmount;

  /// 현재 소비 금액
  final double currentSpending;

  /// 남은 금액
  final double remainingAmount;

  /// 사용률 (%)
  final double usagePercentage;

  /// 생성 일시
  final DateTime? createdAt;

  /// 수정 일시
  final DateTime? updatedAt;

  BudgetModel({
    this.budgetId,
    this.userId,
    required this.year,
    required this.month,
    required this.targetAmount,
    this.currentSpending = 0.0,
    this.remainingAmount = 0.0,
    this.usagePercentage = 0.0,
    this.createdAt,
    this.updatedAt,
  });

  /// JSON에서 모델 생성
  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    return BudgetModel(
      budgetId: json['budgetId'] as String?,
      userId: json['userId'] as String?,
      year: json['year'] as int,
      month: json['month'] as int,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      currentSpending: (json['currentSpending'] as num?)?.toDouble() ?? 0.0,
      remainingAmount: (json['remainingAmount'] as num?)?.toDouble() ?? 0.0,
      usagePercentage: (json['usagePercentage'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  /// 모델을 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'budgetId': budgetId,
      'userId': userId,
      'year': year,
      'month': month,
      'targetAmount': targetAmount,
      'currentSpending': currentSpending,
      'remainingAmount': remainingAmount,
      'usagePercentage': usagePercentage,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// 예산 생성/수정 요청용 JSON
  Map<String, dynamic> toRequestJson() {
    return {
      'year': year,
      'month': month,
      'targetAmount': targetAmount,
    };
  }

  /// 예산 초과 여부
  bool get isOverBudget => currentSpending > targetAmount;

  /// 사용 상태 색상 (위젯에서 사용)
  /// - 50% 미만: 안전 (녹색)
  /// - 50-80%: 주의 (주황색)
  /// - 80% 이상: 위험 (빨간색)
  String get statusColor {
    if (usagePercentage < 50) return 'safe';
    if (usagePercentage < 80) return 'warning';
    return 'danger';
  }

  /// 복사본 생성
  BudgetModel copyWith({
    String? budgetId,
    String? userId,
    int? year,
    int? month,
    double? targetAmount,
    double? currentSpending,
    double? remainingAmount,
    double? usagePercentage,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BudgetModel(
      budgetId: budgetId ?? this.budgetId,
      userId: userId ?? this.userId,
      year: year ?? this.year,
      month: month ?? this.month,
      targetAmount: targetAmount ?? this.targetAmount,
      currentSpending: currentSpending ?? this.currentSpending,
      remainingAmount: remainingAmount ?? this.remainingAmount,
      usagePercentage: usagePercentage ?? this.usagePercentage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
