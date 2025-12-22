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

// providers
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:moneyflow/core/providers/core_providers.dart';

part 'income_providers.g.dart';

// ============================================================================
// DataSource Providers
// ============================================================================

/// Remote DataSource Provider
@riverpod
IncomeRemoteDataSource incomeRemoteDataSource(Ref ref) {
  return IncomeRemoteDataSourceImpl(dio: ref.read(dioProvider));
}

// ============================================================================
// Repository Provider
// ============================================================================

/// Income Repository Provider
@riverpod
IncomeRepository incomeRepository(Ref ref) {
  return IncomeRepositoryImpl(
    remoteDataSource: ref.read(incomeRemoteDataSourceProvider),
  );
}

// ============================================================================
// UseCase Providers
// ============================================================================

/// Get Income List UseCase Provider
@riverpod
GetIncomeListUsecase getIncomeListUsecase(Ref ref) {
  return GetIncomeListUsecase(ref.read(incomeRepositoryProvider));
}

/// Create Income UseCase Provider
@riverpod
CreateIncomeUsecase createIncomeUsecase(Ref ref) {
  return CreateIncomeUsecase(ref.read(incomeRepositoryProvider));
}

/// Get Income Detail UseCase Provider
@riverpod
GetIncomeDetailUsecase getIncomeDetailUsecase(Ref ref) {
  return GetIncomeDetailUsecase(ref.read(incomeRepositoryProvider));
}

/// Update Income UseCase Provider
@riverpod
UpdateIncomeUsecase updateIncomeUsecase(Ref ref) {
  return UpdateIncomeUsecase(ref.read(incomeRepositoryProvider));
}

/// Delete Income UseCase Provider
@riverpod
DeleteIncomeUsecase deleteIncomeUsecase(Ref ref) {
  return DeleteIncomeUsecase(ref.read(incomeRepositoryProvider));
}
