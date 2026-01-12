/// 지출 엔티티
class Expense {
  final String? expenseId;
  final String? userId;
  final String? coupleId;
  final double amount;
  final DateTime date;
  final String category; // 식비, 교통, 쇼핑 등
  final String? merchant; // 가맹점명
  final String? memo;
  final String paymentMethod; // CARD, CASH
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Expense({
    this.expenseId,
    this.userId,
    this.coupleId,
    required this.amount,
    required this.date,
    required this.category,
    this.merchant,
    this.memo,
    required this.paymentMethod,
    this.createdAt,
    this.updatedAt,
  });

  Expense copyWith({
    String? expenseId,
    String? userId,
    String? coupleId,
    double? amount,
    DateTime? date,
    String? category,
    String? merchant,
    String? memo,
    String? paymentMethod,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Expense(
      expenseId: expenseId ?? this.expenseId,
      userId: userId ?? this.userId,
      coupleId: coupleId ?? this.coupleId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      merchant: merchant ?? this.merchant,
      memo: memo ?? this.memo,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
