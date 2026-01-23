import 'package:moamoa/features/budget/data/models/budget_models.dart';

/// Budget Remote Data Source 인터페이스
abstract class BudgetRemoteDataSource {
  /// 예산 생성 또는 수정 API 호출
  Future<BudgetResponseModel> createOrUpdateBudget({
    required String accountBookId,
    required int year,
    required int month,
    required double targetAmount,
  });

  /// 월간 예산 조회 API 호출
  Future<BudgetResponseModel?> getMonthlyBudget({
    required int year,
    required int month,
    String? accountBookId,
  });

  /// 총 자산 조회 API 호출
  Future<AssetResponseModel> getTotalAssets({
    String? accountBookId,
  });

  /// 초기 잔액 수정 API 호출
  Future<void> updateInitialBalance({
    required String accountBookId,
    required double initialBalance,
  });
}
