// packages
import 'package:freezed_annotation/freezed_annotation.dart';

// models
import 'package:moneyflow/features/expense/data/models/expense_model.dart';
import 'package:moneyflow/features/income/data/models/income_model.dart';

part 'home_monthly_response_model.freezed.dart';
part 'home_monthly_response_model.g.dart';

@freezed
sealed class HomeMonthlyResponseModel with _$HomeMonthlyResponseModel {
  const factory HomeMonthlyResponseModel({
    @Default([]) List<ExpenseModel> expenses,
    @Default([]) List<IncomeModel> incomes,
  }) = _HomeMonthlyResponseModel;

  factory HomeMonthlyResponseModel.fromJson(Map<String, dynamic> json) =>
      _$HomeMonthlyResponseModelFromJson(json);
}
