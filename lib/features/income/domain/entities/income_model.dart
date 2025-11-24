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

  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    return IncomeModel(
      incomeId: json['incomeId'],
      userId: json['userId'],
      coupleId: json['coupleId'],
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      source: json['source'],
      description: json['description'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (incomeId != null) 'incomeId': incomeId,
      if (userId != null) 'userId': userId,
      if (coupleId != null) 'coupleId': coupleId,
      'amount': amount,
      'date': date.toIso8601String().split('T')[0], // yyyy-MM-dd 형식
      'source': source,
      if (description != null) 'description': description,
    };
  }

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
