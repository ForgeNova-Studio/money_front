import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moamoa/features/home/domain/entities/transaction_entity.dart';

part 'search_response_model.freezed.dart';
part 'search_response_model.g.dart';

/// 거래 내역 검색 API 응답 모델
@freezed
sealed class SearchResponseModel with _$SearchResponseModel {
  const SearchResponseModel._();

  const factory SearchResponseModel({
    required List<SearchTransactionModel> transactions,
    required int totalCount,
    required bool hasNext,
  }) = _SearchResponseModel;

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseModelFromJson(json);
}

/// 검색 결과의 개별 거래 내역 모델
///
/// [HomeTransactionModel]과 동일하나 [date] 필드가 포함됩니다.
@freezed
sealed class SearchTransactionModel with _$SearchTransactionModel {
  const SearchTransactionModel._();

  const factory SearchTransactionModel({
    required String id,
    required String type, // "INCOME" | "EXPENSE"
    required int amount,
    required String title,
    required String category,
    String? memo,
    required String date, // "yyyy-MM-dd"
    required String time, // "HH:mm" or ""
  }) = _SearchTransactionModel;

  factory SearchTransactionModel.fromJson(Map<String, dynamic> json) =>
      _$SearchTransactionModelFromJson(json);

  TransactionEntity toEntity() {
    final baseDate = DateTime.parse(date);

    int hour = 0;
    int minute = 0;
    if (time.isNotEmpty && time.contains(':')) {
      final parts = time.split(':');
      hour = int.tryParse(parts[0]) ?? 0;
      minute = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
    }

    final dateTime = DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      hour,
      minute,
    );

    return TransactionEntity(
      id: id,
      amount: amount,
      date: dateTime,
      title: title,
      category: category,
      memo: memo,
      type: type == 'INCOME' ? TransactionType.income : TransactionType.expense,
      createdAt: dateTime,
    );
  }
}
