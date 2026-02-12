/// 지출 엔티티
///
/// 사용자의 개별 지출 내역을 표현하는 핵심 도메인 객체입니다.
/// 가계부 ID, 금액, 날짜, 카테고리 등 지출에 필요한 모든 정보를 포함하며 불변(Immutable) 객체로 설계되었습니다.
///
/// **주요 속성:**
/// - [expenseId]: 지출 고유 식별자 (DB PK)
/// - [amount]: 지출 금액 (원 단위)
/// - [date]: 지출 일시
/// - [category]: 지출 카테고리 코드 (예: FOOD, TRANSPORT)
/// - [paymentMethod]: 결제 수단 (CARD, CASH)
/// - [isAutoCategorized]: 자동 분류 여부
///
/// **사용 예시:**
/// ```dart
/// final expense = Expense(
///   amount: 15000,
///   date: DateTime.now(),
///   category: 'FOOD',
///   merchant: '김밥천국',
///   paymentMethod: 'CARD',
/// );
/// ```
class Expense {
  final String? expenseId;
  final String? userId;
  final String? accountBookId;
  final String? fundingSource;

  /// Amount in KRW (won). Keep this as int to avoid floating point rounding.
  final int amount;
  final DateTime date;
  final String? category; // 식비, 교통, 쇼핑 등
  final String? merchant; // 가맹점명
  final String? memo;
  final String? paymentMethod; // CARD, CASH
  final String? imageUrl;
  final bool? isAutoCategorized;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Expense({
    this.expenseId,
    this.userId,
    this.accountBookId,
    this.fundingSource,
    required this.amount,
    required this.date,
    this.category,
    this.merchant,
    this.memo,
    this.paymentMethod,
    this.imageUrl,
    this.isAutoCategorized,
    this.createdAt,
    this.updatedAt,
  });

  Expense copyWith({
    String? expenseId,
    String? userId,
    String? accountBookId,
    String? fundingSource,
    int? amount,
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
    return Expense(
      expenseId: expenseId ?? this.expenseId,
      userId: userId ?? this.userId,
      accountBookId: accountBookId ?? this.accountBookId,
      fundingSource: fundingSource ?? this.fundingSource,
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Expense &&
          runtimeType == other.runtimeType &&
          expenseId == other.expenseId &&
          userId == other.userId &&
          accountBookId == other.accountBookId &&
          fundingSource == other.fundingSource &&
          amount == other.amount &&
          date == other.date &&
          category == other.category &&
          merchant == other.merchant &&
          memo == other.memo &&
          paymentMethod == other.paymentMethod &&
          imageUrl == other.imageUrl &&
          isAutoCategorized == other.isAutoCategorized &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode =>
      expenseId.hashCode ^
      userId.hashCode ^
      accountBookId.hashCode ^
      fundingSource.hashCode ^
      amount.hashCode ^
      date.hashCode ^
      category.hashCode ^
      merchant.hashCode ^
      memo.hashCode ^
      paymentMethod.hashCode ^
      imageUrl.hashCode ^
      isAutoCategorized.hashCode ^
      createdAt.hashCode ^
      updatedAt.hashCode;
}
