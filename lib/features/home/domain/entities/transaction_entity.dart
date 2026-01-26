import 'package:moamoa/features/expense/domain/entities/expense.dart';
import 'package:moamoa/features/income/domain/entities/income.dart';

enum TransactionType { income, expense }

class TransactionEntity {
  final String id;
  /// Amount in KRW (won). Keep this as int to avoid floating point rounding.
  final int amount;
  final DateTime date;
  final String title; // 사용자 입력 설명 (merchant or description), fallback: category label
  final String category; // 카테고리 코드 (category or source)
  final String? memo; // 추가 메모 (지출 memo, 수입은 null)
  final TransactionType type;
  final DateTime createdAt;

  TransactionEntity({
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
}
