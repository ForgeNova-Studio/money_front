class ExpenseModel {
  final String? expenseId;
  final String? userId;
  final String? coupleId;
  final double amount;
  final DateTime date;
  final String category;
  final String? merchant;
  final String? memo;
  final String? paymentMethod;
  final String? imageUrl;
  final bool isAutoCategorized;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ExpenseModel({
    this.expenseId,
    this.userId,
    this.coupleId,
    required this.amount,
    required this.date,
    required this.category,
    this.merchant,
    this.memo,
    this.paymentMethod,
    this.imageUrl,
    this.isAutoCategorized = false,
    this.createdAt,
    this.updatedAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      expenseId: json['expenseId'],
      userId: json['userId'],
      coupleId: json['coupleId'],
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      category: json['category'],
      merchant: json['merchant'],
      memo: json['memo'],
      paymentMethod: json['paymentMethod'],
      imageUrl: json['imageUrl'],
      isAutoCategorized: json['isAutoCategorized'] ?? false,
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
      if (expenseId != null) 'expenseId': expenseId,
      if (userId != null) 'userId': userId,
      if (coupleId != null) 'coupleId': coupleId,
      'amount': amount,
      'date': date.toIso8601String().split('T')[0], // yyyy-MM-dd 형식
      'category': category,
      if (merchant != null) 'merchant': merchant,
      if (memo != null) 'memo': memo,
      if (paymentMethod != null) 'paymentMethod': paymentMethod,
      if (imageUrl != null) 'imageUrl': imageUrl,
      'isAutoCategorized': isAutoCategorized,
    };
  }

  ExpenseModel copyWith({
    String? expenseId,
    String? userId,
    String? coupleId,
    double? amount,
    DateTime? date,
    String? category,
    String? merchant,
    String? memo,
    String? paymentMethod,
    String? imageUrl,
    bool? isAutoCategorized,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ExpenseModel(
      expenseId: expenseId ?? this.expenseId,
      userId: userId ?? this.userId,
      coupleId: coupleId ?? this.coupleId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      merchant: merchant ?? this.merchant,
      memo: memo ?? this.memo,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      imageUrl: imageUrl ?? this.imageUrl,
      isAutoCategorized: isAutoCategorized ?? this.isAutoCategorized,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
