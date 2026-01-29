import 'package:moamoa/features/home/domain/entities/transaction_entity.dart';

bool _listEquals<T>(List<T>? a, List<T>? b) {
  if (a == null) return b == null;
  if (b == null || a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

class DailyTransactionSummary {
  final DateTime date;
  final int totalIncome;
  final int totalExpense;
  final List<TransactionEntity> transactions;

  const DailyTransactionSummary({
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
      transactions: const [],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyTransactionSummary &&
          runtimeType == other.runtimeType &&
          date == other.date &&
          totalIncome == other.totalIncome &&
          totalExpense == other.totalExpense &&
          _listEquals(transactions, other.transactions);

  @override
  int get hashCode =>
      date.hashCode ^
      totalIncome.hashCode ^
      totalExpense.hashCode ^
      Object.hashAll(transactions);
}
