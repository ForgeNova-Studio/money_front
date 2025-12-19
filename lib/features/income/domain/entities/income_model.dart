class IncomeModel {
  final String? incomeId;
  final String? userId;
  final String? coupleId;
  final double amount;
  final DateTime date;
  final String source; // 급여, 부수입, 상여금, 투자수익, 기타
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  IncomeModel({
    this.incomeId,
    this.userId,
    this.coupleId,
    required this.amount,
    required this.date,
    required this.source,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  IncomeModel copyWith({
    String? incomeId,
    String? userId,
    String? coupleId,
    double? amount,
    DateTime? date,
    String? source,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return IncomeModel(
      incomeId: incomeId ?? this.incomeId,
      userId: userId ?? this.userId,
      coupleId: coupleId ?? this.coupleId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      source: source ?? this.source,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// 수입 출처 상수
class IncomeSource {
  static const String salary = '급여';
  static const String sideIncome = '부수입';
  static const String bonus = '상여금';
  static const String investment = '투자수익';
  static const String other = '기타';

  static const List<String> all = [
    salary,
    sideIncome,
    bonus,
    investment,
    other,
  ];
}
