/// 월간 예산 정보 엔티티
class BudgetEntity {
  final String budgetId;
  final int year;
  final int month;
  final double targetAmount;
  final double currentSpending;
  final double remainingAmount;
  final double usagePercentage;

  const BudgetEntity({
    required this.budgetId,
    required this.year,
    required this.month,
    required this.targetAmount,
    required this.currentSpending,
    required this.remainingAmount,
    required this.usagePercentage,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetEntity &&
          runtimeType == other.runtimeType &&
          budgetId == other.budgetId &&
          year == other.year &&
          month == other.month &&
          targetAmount == other.targetAmount &&
          currentSpending == other.currentSpending &&
          remainingAmount == other.remainingAmount &&
          usagePercentage == other.usagePercentage;

  @override
  int get hashCode =>
      budgetId.hashCode ^
      year.hashCode ^
      month.hashCode ^
      targetAmount.hashCode ^
      currentSpending.hashCode ^
      remainingAmount.hashCode ^
      usagePercentage.hashCode;
}

/// 총 자산 정보 엔티티
class AssetEntity {
  final String accountBookId;
  final String accountBookName;
  final double currentTotalAssets;
  final double initialBalance;
  final double totalIncome;
  final double totalExpense;

  /// 이번 달 수입
  final double periodIncome;

  /// 이번 달 지출
  final double periodExpense;

  /// 이번 달 순수익
  final double periodNetIncome;

  const AssetEntity({
    required this.accountBookId,
    required this.accountBookName,
    required this.currentTotalAssets,
    required this.initialBalance,
    required this.totalIncome,
    required this.totalExpense,
    required this.periodIncome,
    required this.periodExpense,
    required this.periodNetIncome,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssetEntity &&
          runtimeType == other.runtimeType &&
          accountBookId == other.accountBookId &&
          accountBookName == other.accountBookName &&
          currentTotalAssets == other.currentTotalAssets &&
          initialBalance == other.initialBalance &&
          totalIncome == other.totalIncome &&
          totalExpense == other.totalExpense &&
          periodIncome == other.periodIncome &&
          periodExpense == other.periodExpense &&
          periodNetIncome == other.periodNetIncome;

  @override
  int get hashCode =>
      accountBookId.hashCode ^
      accountBookName.hashCode ^
      currentTotalAssets.hashCode ^
      initialBalance.hashCode ^
      totalIncome.hashCode ^
      totalExpense.hashCode ^
      periodIncome.hashCode ^
      periodExpense.hashCode ^
      periodNetIncome.hashCode;
}
