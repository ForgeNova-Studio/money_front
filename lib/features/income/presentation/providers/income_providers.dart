// dataSources
import 'package:moneyflow/features/income/data/datasources/income_remote_datasource.dart';
import 'package:moneyflow/features/income/data/datasources/income_remote_datasource_impl.dart';

// repository
import 'package:moneyflow/features/income/data/repositories/income_repository_impl.dart';
import 'package:moneyflow/features/income/domain/repositories/income_repository.dart';

// usecases
import 'package:moneyflow/features/income/domain/usecases/create_income_usecase.dart';
import 'package:moneyflow/features/income/domain/usecases/delete_income_usecase.dart';
import 'package:moneyflow/features/income/domain/usecases/get_income_detail_usecase.dart';
import 'package:moneyflow/features/income/domain/usecases/get_income_list_usecase.dart';
import 'package:moneyflow/features/income/domain/usecases/update_income_usecase.dart';

// packages
import 'package:riverpod_annotation/riverpod_annotation.dart';

// providers
import 'package:moneyflow/features/common/providers/core_providers.dart';

part 'income_providers.g.dart';

// ============================================================================
// DataSource Providers
// ============================================================================
@riverpod
IncomeRemoteDataSource incomeRemoteDataSource(Ref ref) {
  return IncomeRemoteDataSourceImpl(dio: ref.read(dioProvider));
}

// ============================================================================
// Repository Provider
// ============================================================================
@riverpod
IncomeRepository incomeRepository(Ref ref) {
  return IncomeRepositoryImpl(
    remoteDataSource: ref.read(incomeRemoteDataSourceProvider),
  );
}

// ============================================================================
// UseCase Providers
// ============================================================================
@riverpod
GetIncomeListUsecase getIncomeListUsecase(Ref ref) {
  return GetIncomeListUsecase(ref.read(incomeRepositoryProvider));
}

@riverpod
CreateIncomeUsecase createIncomeUsecase(Ref ref) {
  return CreateIncomeUsecase(ref.read(incomeRepositoryProvider));
}

@riverpod
GetIncomeDetailUsecase getIncomeDetailUsecase(Ref ref) {
  return GetIncomeDetailUsecase(ref.read(incomeRepositoryProvider));
}

@riverpod
UpdateIncomeUsecase updateIncomeUsecase(Ref ref) {
  return UpdateIncomeUsecase(ref.read(incomeRepositoryProvider));
}

@riverpod
DeleteIncomeUsecase deleteIncomeUsecase(Ref ref) {
  return DeleteIncomeUsecase(ref.read(incomeRepositoryProvider));
}
