// packages
import 'package:freezed_annotation/freezed_annotation.dart';

// models
import 'package:moamoa/features/income/data/models/income_model.dart';

part 'income_list_response_model.freezed.dart';
part 'income_list_response_model.g.dart';

@freezed
sealed class IncomeListResponseModel with _$IncomeListResponseModel {
  const factory IncomeListResponseModel({
    required List<IncomeModel> incomes,
    required double totalAmount,
    required int count,
  }) = _IncomeListResponseModel;

  factory IncomeListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$IncomeListResponseModelFromJson(json);
}
