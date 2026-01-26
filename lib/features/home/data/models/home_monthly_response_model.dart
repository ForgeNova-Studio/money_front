import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moamoa/features/home/domain/entities/transaction_entity.dart';
import 'package:moamoa/features/home/domain/entities/daily_transaction_summary.dart';

part 'home_monthly_response_model.freezed.dart';
part 'home_monthly_response_model.g.dart';

@freezed
sealed class HomeTransactionModel with _$HomeTransactionModel {
  const HomeTransactionModel._();

  const factory HomeTransactionModel({
    required String
        id, // UUID String (예: "123e4567-e89b-12d3-a456-426614174000")
    required String type, // "INCOME" or "EXPENSE"
    required int amount,
    required String title, // 사용자 입력 설명 (지출: merchant ?? category, 수입: description ?? source)
    required String category, // 카테고리 코드 (지출: category, 수입: source)
    String? memo, // 추가 메모 (지출: memo, 수입: null)
    required String time, // "14:30"
  }) = _HomeTransactionModel;

  factory HomeTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$HomeTransactionModelFromJson(json);

  TransactionEntity toEntity(DateTime date) {
    // time을 파싱하여 date와 합침
    DateTime dateTime;
    if (time.isEmpty || !time.contains(':')) {
      // time이 빈 문자열이거나 형식이 잘못된 경우 날짜만 사용
      dateTime = DateTime(date.year, date.month, date.day);
    } else {
      final timeParts = time.split(':');
      final hour = int.tryParse(timeParts[0]) ?? 0;
      final minute =
          timeParts.length > 1 ? (int.tryParse(timeParts[1]) ?? 0) : 0;
      dateTime = DateTime(date.year, date.month, date.day, hour, minute);
    }

    return TransactionEntity(
      id: id,
      amount: amount.toDouble(),
      date: dateTime,
      title: title,
      category: category,
      memo: memo,
      type: type == 'INCOME' ? TransactionType.income : TransactionType.expense,
      createdAt: dateTime,
    );
  }
}

@freezed
sealed class DailyTransactionSummaryModel with _$DailyTransactionSummaryModel {
  const DailyTransactionSummaryModel._();

  const factory DailyTransactionSummaryModel({
    required String date, // "2025-12-24"
    required int totalIncome,
    required int totalExpense,
    required List<HomeTransactionModel> transactions,
  }) = _DailyTransactionSummaryModel;

  factory DailyTransactionSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DailyTransactionSummaryModelFromJson(json);

  DailyTransactionSummary toEntity() {
    final dateTime = DateTime.parse(date); // String -> DateTime 변환

    return DailyTransactionSummary(
      date: dateTime,
      totalIncome: totalIncome.toDouble(),
      totalExpense: totalExpense.toDouble(),
      transactions: transactions.map((t) => t.toEntity(dateTime)).toList(),
    );
  }
}
