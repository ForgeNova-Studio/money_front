import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget_entity.freezed.dart';
part 'budget_entity.g.dart';

/// 월간 예산 정보 엔티티
@freezed
sealed class BudgetEntity with _$BudgetEntity {
  const factory BudgetEntity({
    required String budgetId,
    required int year,
    required int month,
    required double targetAmount,
    required double currentSpending,
    required double remainingAmount,
    required double usagePercentage,
  }) = _BudgetEntity;

  factory BudgetEntity.fromJson(Map<String, dynamic> json) =>
      _$BudgetEntityFromJson(json);
}

/// 총 자산 정보 엔티티
@freezed
sealed class AssetEntity with _$AssetEntity {
  const factory AssetEntity({
    required String accountBookId,
    required String accountBookName,
    required double currentTotalAssets,
    required double initialBalance,
    required double totalIncome,
    required double totalExpense,

    /// 이번 달 수입
    required double periodIncome,

    /// 이번 달 지출
    required double periodExpense,

    /// 이번 달 순수익
    required double periodNetIncome,
  }) = _AssetEntity;

  factory AssetEntity.fromJson(Map<String, dynamic> json) =>
      _$AssetEntityFromJson(json);
}
