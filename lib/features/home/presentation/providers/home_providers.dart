import 'package:moneyflow/features/home/data/repositories/home_repository_impl.dart';
import 'package:moneyflow/features/home/domain/repositories/home_repository.dart';
import 'package:moneyflow/features/home/domain/usecases/get_home_monthly_data_usecase.dart';
import 'package:moneyflow/features/expense/presentation/providers/expense_providers.dart';
import 'package:moneyflow/features/income/presentation/providers/income_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_providers.g.dart';

@riverpod
HomeRepository homeRepository(Ref ref) {
  return HomeRepositoryImpl(
    expenseRepository: ref.read(expenseRepositoryProvider),
    incomeRepository: ref.read(incomeRepositoryProvider),
  );
}

@riverpod
GetHomeMonthlyDataUseCase getHomeMonthlyDataUseCase(Ref ref) {
  return GetHomeMonthlyDataUseCase(ref.read(homeRepositoryProvider));
}
