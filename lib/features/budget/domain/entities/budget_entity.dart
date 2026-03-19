/// 월별 예산 정보를 담는 도메인 엔티티
///
/// 애플리케이션 내에서 예산 관련 핵심 비즈니스 로직 및 UI 표현에 사용되는 불변 객체입니다.
/// 특정 연도와 특정 월에 대한 예산 목표 금액, 현재까지의 지출, 남은 예산, 예산 소진율을 포함합니다.
///
/// **Key Features:**
/// *   특정 월의 예산 식별 및 관리
/// *   목표 예산 대비 현재 지출 및 잔액 정보 제공
/// *   예산 소진 비율 계산 상태 제공
///
/// **Parameters:**
/// *   [budgetId] - 해당 예산의 고유 식별자
/// *   [year] - 예산이 설정된 연도
/// *   [month] - 예산이 설정된 월
/// *   [targetAmount] - 사용자가 설정한 목표 예산 금액
/// *   [currentSpending] - 해당 월에 현재까지 누적된 지출 금액
/// *   [remainingAmount] - 해당 월에 남아있는 예산 금액 (음수일 경우 예산 초과를 의미)
/// *   [usagePercentage] - 타겟 금액 대비 지출 금액의 백분율 (예: 50% 지출 시 50.0)
///
/// **Usage Example:**
/// ```dart
/// final monthlyBudget = BudgetEntity(
///   budgetId: 'b-2602',
///   year: 2026,
///   month: 2,
///   targetAmount: 500000,
///   currentSpending: 250000,
///   remainingAmount: 250000,
///   usagePercentage: 50.0,
/// );
/// print(monthlyBudget.remainingAmount);
/// ```
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
