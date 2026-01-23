import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';

part 'budget_models.freezed.dart';
part 'budget_models.g.dart';

/// 예산 응답 모델 (API -> Domain)
@freezed
sealed class BudgetResponseModel with _$BudgetResponseModel {
  const BudgetResponseModel._();

  const factory BudgetResponseModel({
    required String budgetId,
    required String userId,
    required int year,
    required int month,
    required double targetAmount,
    required double currentSpending,
    required double remainingAmount,
    required double usagePercentage,
  }) = _BudgetResponseModel;

  factory BudgetResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetResponseModelFromJson(json);

  BudgetEntity toEntity() {
    return BudgetEntity(
      budgetId: budgetId,
      year: year,
      month: month,
      targetAmount: targetAmount,
      currentSpending: currentSpending,
      remainingAmount: remainingAmount,
      usagePercentage: usagePercentage,
    );
  }
}

/// 자산 응답 모델 (API -> Domain)
@freezed
sealed class AssetResponseModel with _$AssetResponseModel {
  const AssetResponseModel._();

  const factory AssetResponseModel({
    required String accountBookId,
    required String accountBookName,
    required double currentTotalAssets,
    required double initialBalance,
    required double totalIncome,
    required double totalExpense,
    required double periodIncome,
    required double periodExpense,
    required double periodNetIncome,
  }) = _AssetResponseModel;

  factory AssetResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AssetResponseModelFromJson(json);

  AssetEntity toEntity() {
    return AssetEntity(
      accountBookId: accountBookId,
      accountBookName: accountBookName,
      currentTotalAssets: currentTotalAssets,
      initialBalance: initialBalance,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      periodIncome: periodIncome,
      periodExpense: periodExpense,
      periodNetIncome: periodNetIncome,
    );
  }
}
