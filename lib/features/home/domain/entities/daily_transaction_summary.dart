import 'package:moamoa/features/home/domain/entities/transaction_entity.dart';

class DailyTransactionSummary {
  final DateTime date;
  final int totalIncome;
  final int totalExpense;
  final List<TransactionEntity> transactions;

  DailyTransactionSummary({
    required this.date,
    required this.totalIncome,
    required this.totalExpense,
    required this.transactions,
  });

  factory DailyTransactionSummary.empty(DateTime date) {
    return DailyTransactionSummary(
      date: date,
      totalIncome: 0,
      totalExpense: 0,
      transactions: [],
    );
  }
}
