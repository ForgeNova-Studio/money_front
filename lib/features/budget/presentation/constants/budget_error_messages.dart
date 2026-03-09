/// Budget feature 전용 에러 메시지 모음.
///
/// 화면/뷰모델 전반에서 동일한 문구를 재사용하여
/// 사용자 경험과 QA 기준을 일관되게 유지한다.
abstract final class BudgetErrorMessages {
  static const accountBookNotSelected = '가계부를 선택해주세요.';

  static const invalidBudgetAmount = '예산 금액은 0원 이상이어야 합니다.';
  static const noBudgetToDelete = '삭제할 예산이 없습니다.';

  static const selectedMonthBudgetLoadFailed =
      '선택한 월의 예산 정보를 불러오지 못했습니다. 다시 시도해주세요.';
  static const budgetSaveFailed = '예산 저장에 실패했습니다. 다시 시도해주세요.';
  static const budgetDeleteFailed = '예산 삭제에 실패했습니다. 다시 시도해주세요.';

  static const initialBalanceLoadFailed = '초기 잔액 정보를 불러오지 못했습니다. 다시 시도해주세요.';
  static const initialBalanceSaveFailed = '초기 잔액 저장에 실패했습니다. 다시 시도해주세요.';
}
