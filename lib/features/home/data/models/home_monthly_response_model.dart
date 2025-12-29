import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneyflow/features/home/domain/entities/transaction_entity.dart';
import 'package:moneyflow/features/home/domain/entities/daily_transaction_summary.dart';

part 'home_monthly_response_model.freezed.dart';
part 'home_monthly_response_model.g.dart';

@freezed
sealed class HomeTransactionModel with _$HomeTransactionModel {
  const HomeTransactionModel._();

  const factory HomeTransactionModel({
    required String id,
    required double amount,
    required DateTime date,
    required String title,
    required String category,
    required String type, // "INCOME" or "EXPENSE"
  }) = _HomeTransactionModel;

  factory HomeTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$HomeTransactionModelFromJson(json);

  TransactionEntity toEntity() {
    return TransactionEntity(
      id: id,
      amount: amount,
      date: date,
      title: title,
      category: category,
      type: type == 'INCOME' ? TransactionType.income : TransactionType.expense,
      createdAt: date, // 임시로 date 사용
    );
  }
}

@freezed
sealed class DailyTransactionSummaryModel with _$DailyTransactionSummaryModel {
  const DailyTransactionSummaryModel._();

  const factory DailyTransactionSummaryModel({
    required DateTime date,
    required double totalIncome,
    required double totalExpense,
    required List<HomeTransactionModel> transactions,
  }) = _DailyTransactionSummaryModel;

  factory DailyTransactionSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DailyTransactionSummaryModelFromJson(json);

  DailyTransactionSummary toEntity() {
    return DailyTransactionSummary(
      date: date,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      transactions: transactions.map((t) => t.toEntity()).toList(),
    );
  }
}
