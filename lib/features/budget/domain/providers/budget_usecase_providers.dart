import 'package:moamoa/features/budget/data/providers/budget_data_providers.dart';
import 'package:moamoa/features/budget/domain/usecases/create_or_update_budget_usecase.dart';
import 'package:moamoa/features/budget/domain/usecases/delete_budget_usecase.dart';
import 'package:moamoa/features/budget/domain/usecases/get_monthly_budget_usecase.dart';
import 'package:moamoa/features/budget/domain/usecases/get_total_assets_usecase.dart';
import 'package:moamoa/features/budget/domain/usecases/update_initial_balance_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budget_usecase_providers.g.dart';

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

@riverpod
DeleteBudgetUseCase deleteBudgetUseCase(Ref ref) {
  return DeleteBudgetUseCase(ref.read(budgetRepositoryProvider));
}
