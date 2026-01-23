import 'package:moamoa/features/budget/data/datasources/remote/budget_remote_datasource.dart';
import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/budget/domain/repositories/budget_repository.dart';

/// Budget Repository 구현체
class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetRemoteDataSource remoteDataSource;

  BudgetRepositoryImpl({required this.remoteDataSource});

  @override
  Future<BudgetEntity> createOrUpdateBudget({
    required String accountBookId,
    required int year,
    required int month,
    required double targetAmount,
  }) async {
    final model = await remoteDataSource.createOrUpdateBudget(
      accountBookId: accountBookId,
      year: year,
      month: month,
      targetAmount: targetAmount,
    );
    return model.toEntity();
  }

  @override
  Future<BudgetEntity?> getMonthlyBudget({
    required int year,
    required int month,
    String? accountBookId,
  }) async {
    final model = await remoteDataSource.getMonthlyBudget(
      year: year,
      month: month,
      accountBookId: accountBookId,
    );
    return model?.toEntity();
  }

  @override
  Future<AssetEntity> getTotalAssets({
    String? accountBookId,
  }) async {
    final model = await remoteDataSource.getTotalAssets(
      accountBookId: accountBookId,
    );
    return model.toEntity();
  }

  @override
  Future<void> updateInitialBalance({
    required String accountBookId,
    required double initialBalance,
  }) async {
    await remoteDataSource.updateInitialBalance(
      accountBookId: accountBookId,
      initialBalance: initialBalance,
    );
  }
}
