import 'package:moamoa/core/constants/income_categories.dart';

/// 수입 엔티티
///
/// 가계부의 수입 내역을 나타내는 핵심 엔티티입니다.
///
/// **주요 속성:**
/// - [incomeId]: 수입 고유 ID
/// - [amount]: 수입 금액
/// - [date]: 수입 날짜
/// - [source]: 수입 출처 코드 ([IncomeCategoryCode] 상수 사용, 필수)
/// - [description]: 수입 설명 (선택)설명
/// - [incomeId], [userId], [accountBookId]: 식별자 정보
///
/// **사용 예시:**
/// ```dart
/// final income = Income(
///   amount: 3000000,
///   date: DateTime.now(),
///   source: IncomeCategoryCode.salary,
///   description: '3월 월급',
/// );
/// ```
class Income {
  final String? incomeId;
  final String? userId;
  final String? accountBookId;
  final String? fundingSource;

  /// Amount in KRW (won). Keep this as int to avoid floating point rounding.
  final int amount;
  final DateTime date;
  final String source;
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
