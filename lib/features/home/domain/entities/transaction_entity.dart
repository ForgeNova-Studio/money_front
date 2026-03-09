import 'package:moamoa/features/expense/domain/entities/expense.dart';
import 'package:moamoa/features/income/domain/entities/income.dart';

enum TransactionType { income, expense }

/// 수입/지출 거래 정보를 담는 엔티티 클래스
///
/// 애플리케이션 전반에서 사용되는 핵심 데이터 모델입니다.
/// 수입([Income])과 지출([Expense]) 엔티티를 통합하여 홈 화면 등에서 사용합니다.
///
/// 주요 속성:
/// - [id]: 거래 고유 ID (수입/지출 ID)
/// - [amount]: 거래 금액 (절대값)
/// - [date]: 거래 날짜
/// - [type]: 거래 타입 (수입/지출)
/// - [title]: 표시용 제목 (사용자 입력 설명 또는 카테고리명)
/// - [category]: 카테고리명
/// - [memo]: 추가 메모 (선택)
/// - [createdAt]: 생성 일시 (정렬용)
///
/// 생성자:
/// - [TransactionEntity]: 기본 생성자
/// - [TransactionEntity.fromExpense]: 지출 객체로부터 생성
/// - [TransactionEntity.fromIncome]: 수입 객체로부터 생성
class TransactionEntity {
  final String id;
  final int amount;
  final DateTime date;
  final String title;
  final String category;
  final String? memo;
  final TransactionType type;
  final DateTime createdAt;

  const TransactionEntity({
    required this.id,
    required this.amount,
    required this.date,
    required this.title,
    required this.category,
    this.memo,
    required this.type,
    required this.createdAt,
  });

  /// title이 사용자 입력 설명인지, 카테고리 fallback인지 판별
  bool get hasDescription => title != category;

  factory TransactionEntity.fromExpense(Expense expense) {
    final fallbackCategory = expense.category ?? '기타';
    return TransactionEntity(
      id: expense.expenseId ?? '',
      amount: expense.amount,
      date: expense.date,
      title: expense.merchant ?? fallbackCategory,
      category: fallbackCategory,
      memo: expense.memo,
      type: TransactionType.expense,
      createdAt: expense.createdAt ?? DateTime.now(),
    );
  }

  factory TransactionEntity.fromIncome(Income income) {
    return TransactionEntity(
      id: income.incomeId ?? '',
      amount: income.amount,
      date: income.date,
      title: income.description ?? income.source,
      category: income.source,
      memo: null,
      type: TransactionType.income,
      createdAt: income.createdAt ?? DateTime.now(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          amount == other.amount &&
          date == other.date &&
          title == other.title &&
          category == other.category &&
          memo == other.memo &&
          type == other.type &&
          createdAt == other.createdAt;

  @override
  int get hashCode =>
      id.hashCode ^
      amount.hashCode ^
      date.hashCode ^
      title.hashCode ^
      category.hashCode ^
      memo.hashCode ^
      type.hashCode ^
      createdAt.hashCode;
}
