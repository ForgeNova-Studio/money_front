import 'package:moamoa/features/budget/domain/entities/asset_entity.dart';
import 'package:moamoa/features/budget/domain/repositories/budget_repository.dart';

/// 총 자산 조회 UseCase
///
/// 현재 사용자의 특정 가계부에 등록된 현재 총 자산 금액 및 전체 통계 정보를 불러올 때 호출되는 유즈케이스입니다.
/// 홈 화면 상단이나 통계 화면 등에서 총 자산 현황을 표시할 때 주로 사용됩니다.
///
/// **Key Features:**
/// *   특정 가계부 기준 현재 총 자산 및 수입/지출 통계 조회 연결
///
/// **Parameters:**
/// *   [accountBookId] - 대상 가계부의 고유 식별자 (선택 사항)
///
/// **Usage Example:**
/// ```dart
/// final getTotalAssets = ref.read(getTotalAssetsUseCaseProvider);
/// final assetsInfo = await getTotalAssets(accountBookId: 'account-123');
/// print(assetsInfo.currentTotalAssets);
/// ```
class GetTotalAssetsUseCase {
  final BudgetRepository _repository;

  GetTotalAssetsUseCase(this._repository);

  Future<AssetEntity> call({
    String? accountBookId,
  }) async {
    return await _repository.getTotalAssets(
      accountBookId: accountBookId,
    );
  }
}
