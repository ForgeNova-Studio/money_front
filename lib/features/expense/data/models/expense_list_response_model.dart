// packages
import 'package:freezed_annotation/freezed_annotation.dart';

// models
import 'package:moneyflow/features/expense/data/models/expense_model.dart';

part 'expense_list_response_model.freezed.dart';
part 'expense_list_response_model.g.dart';

@freezed
sealed class ExpenseListResponseModel with _$ExpenseListResponseModel {
  const factory ExpenseListResponseModel({
    required List<ExpenseModel> expenses,
    required double totalAmount,
    required int count,
  }) = _ExpenseListResponseModel;

  factory ExpenseListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseListResponseModelFromJson(json);
}
