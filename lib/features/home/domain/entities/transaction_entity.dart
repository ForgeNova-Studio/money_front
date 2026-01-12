import 'package:moneyflow/features/expense/domain/entities/expense.dart';
import 'package:moneyflow/features/income/domain/entities/income.dart';

enum TransactionType { income, expense }

class TransactionEntity {
  final String id;
  final double amount;
  final DateTime date;
  final String title; // merchant for expense, source for income
  final String category;
  final TransactionType type;
  final DateTime createdAt;

  TransactionEntity({
    required this.id,
    required this.amount,
    required this.date,
    required this.title,
    required this.category,
    required this.type,
    required this.createdAt,
  });

  factory TransactionEntity.fromExpense(Expense expense) {
    return TransactionEntity(
      id: expense.expenseId ?? '',
      amount: expense.amount, // Expense amount is usually positive in DB, handled as negative in UI
      date: expense.date,
      title: expense.merchant ?? expense.category,
      category: expense.category,
      type: TransactionType.expense,
      createdAt: expense.createdAt ?? DateTime.now(),
    );
  }

  factory TransactionEntity.fromIncome(Income income) {
    return TransactionEntity(
      id: income.incomeId ?? '',
      amount: income.amount,
      date: income.date,
      title: income.source,
      category: income.source,
      type: TransactionType.income,
      createdAt: income.createdAt ?? DateTime.now(),
    );
  }
}
