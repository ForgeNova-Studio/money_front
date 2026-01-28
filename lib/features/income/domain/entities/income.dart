class Income {
  final String? incomeId;
  final String? userId;
  final String? accountBookId;
  final String? fundingSource;

  /// Amount in KRW (won). Keep this as int to avoid floating point rounding.
  final int amount;
  final DateTime date;
  final String source; // 급여, 부수입, 용돈, 상여금, 기타
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Income({
    this.incomeId,
    this.userId,
    this.accountBookId,
    this.fundingSource,
    required this.amount,
    required this.date,
    required this.source,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  Income copyWith({
    String? incomeId,
    String? userId,
    String? accountBookId,
    String? fundingSource,
    int? amount,
    DateTime? date,
    String? source,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Income(
      incomeId: incomeId ?? this.incomeId,
      userId: userId ?? this.userId,
      accountBookId: accountBookId ?? this.accountBookId,
      fundingSource: fundingSource ?? this.fundingSource,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      source: source ?? this.source,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Income &&
          runtimeType == other.runtimeType &&
          incomeId == other.incomeId &&
          userId == other.userId &&
          accountBookId == other.accountBookId &&
          fundingSource == other.fundingSource &&
          amount == other.amount &&
          date == other.date &&
          source == other.source &&
          description == other.description &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      incomeId.hashCode ^
      userId.hashCode ^
      accountBookId.hashCode ^
      fundingSource.hashCode ^
      amount.hashCode ^
      date.hashCode ^
      source.hashCode ^
      description.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}

/// 수입 출처 상수
class IncomeSource {
  static const String salary = 'SALARY';
  static const String sideIncome = 'SIDE_INCOME';
  static const String allowance = 'ALLOWANCE';
  static const String bonus = 'BONUS';
  static const String investment = 'INVESTMENT';
  static const String other = 'OTHER';

  static const List<String> all = [
    salary,
    sideIncome,
    allowance,
    bonus,
    investment,
    other,
  ];
}
