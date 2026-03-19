import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/budget/domain/repositories/budget_repository.dart';

/// 월간 예산 조회 UseCase
///
/// 사용자가 선택한 특정 월의 예산 정보(설정액, 지출액, 잔액 등)를 서버로부터 불러올 때 호출되는 단일 진입점입니다.
/// 가계부 정보와 연/월 정보를 기반으로 도메인 리포지토리([BudgetRepository])를 통해 데이터를 요청합니다.
///
/// **Key Features:**
/// *   특정 월의 예산 상세 내역 및 진행률 정보 조회
///
/// **Parameters:**
/// *   [year] - 조회를 원하는 연도
/// *   [month] - 조회를 원하는 월
/// *   [accountBookId] - 조회할 가계부의 고유 식별자 (선택 사항)
///
/// **Usage Example:**
/// ```dart
/// final getMonthlyBudget = ref.read(getMonthlyBudgetUseCaseProvider);
/// final budgetInfo = await getMonthlyBudget(
///   year: 2026,
///   month: 2,
///   accountBookId: 'account-123',
/// );
/// ```
class GetMonthlyBudgetUseCase {
  final BudgetRepository _repository;

  GetMonthlyBudgetUseCase(this._repository);

  Future<BudgetEntity?> call({
    required int year,
    required int month,
    String? accountBookId,
  }) async {
    return await _repository.getMonthlyBudget(
      year: year,
      month: month,
      accountBookId: accountBookId,
    );
  }
}
