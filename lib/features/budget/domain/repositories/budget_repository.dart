import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';

/// Budget Repository 인터페이스
abstract class BudgetRepository {
  /// 예산 생성 또는 수정
  Future<BudgetEntity> createOrUpdateBudget({
    required String accountBookId,
    required int year,
    required int month,
    required double targetAmount,
  });

  /// 월간 예산 조회
  Future<BudgetEntity?> getMonthlyBudget({
    required int year,
    required int month,
    String? accountBookId,
  });

  /// 총 자산 조회
  Future<AssetEntity> getTotalAssets({
    String? accountBookId,
  });

  /// 초기 잔액 수정
  Future<void> updateInitialBalance({
    required String accountBookId,
    required double initialBalance,
  });
}
