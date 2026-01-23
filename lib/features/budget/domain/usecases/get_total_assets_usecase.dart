import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/budget/domain/repositories/budget_repository.dart';

/// 총 자산 조회 UseCase
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
