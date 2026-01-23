import 'package:moamoa/features/budget/data/datasources/remote/budget_remote_datasource.dart';
import 'package:moamoa/features/budget/data/datasources/remote/budget_remote_datasource_impl.dart';
import 'package:moamoa/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:moamoa/features/budget/domain/repositories/budget_repository.dart';
import 'package:moamoa/features/budget/domain/usecases/create_or_update_budget_usecase.dart';
import 'package:moamoa/features/budget/domain/usecases/get_monthly_budget_usecase.dart';
import 'package:moamoa/features/budget/domain/usecases/get_total_assets_usecase.dart';
import 'package:moamoa/features/budget/domain/usecases/update_initial_balance_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:moamoa/features/common/providers/core_providers.dart';

part 'budget_providers.g.dart';

// ============================================================================
// DataSource Providers
// ============================================================================

@riverpod
BudgetRemoteDataSource budgetRemoteDataSource(Ref ref) {
  return BudgetRemoteDataSourceImpl(dio: ref.read(dioProvider));
}

// ============================================================================
// Repository Provider
// ============================================================================

@riverpod
BudgetRepository budgetRepository(Ref ref) {
  return BudgetRepositoryImpl(
    remoteDataSource: ref.read(budgetRemoteDataSourceProvider),
  );
}

// ============================================================================
// UseCase Providers
// ============================================================================

@riverpod
CreateOrUpdateBudgetUseCase createOrUpdateBudgetUseCase(Ref ref) {
  return CreateOrUpdateBudgetUseCase(ref.read(budgetRepositoryProvider));
}

@riverpod
GetMonthlyBudgetUseCase getMonthlyBudgetUseCase(Ref ref) {
  return GetMonthlyBudgetUseCase(ref.read(budgetRepositoryProvider));
}

@riverpod
GetTotalAssetsUseCase getTotalAssetsUseCase(Ref ref) {
  return GetTotalAssetsUseCase(ref.read(budgetRepositoryProvider));
}

@riverpod
UpdateInitialBalanceUseCase updateInitialBalanceUseCase(Ref ref) {
  return UpdateInitialBalanceUseCase(ref.read(budgetRepositoryProvider));
}
