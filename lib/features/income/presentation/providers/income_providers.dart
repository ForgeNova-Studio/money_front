// dataSources
import 'package:moamoa/features/income/data/datasources/income_remote_datasource.dart';
import 'package:moamoa/features/income/data/datasources/income_remote_datasource_impl.dart';

// repository
import 'package:moamoa/features/income/data/repositories/income_repository_impl.dart';
import 'package:moamoa/features/income/domain/repositories/income_repository.dart';

// usecases
import 'package:moamoa/features/income/domain/usecases/create_income_usecase.dart';
import 'package:moamoa/features/income/domain/usecases/delete_income_usecase.dart';
import 'package:moamoa/features/income/domain/usecases/get_income_detail_usecase.dart';
import 'package:moamoa/features/income/domain/usecases/get_income_list_usecase.dart';
import 'package:moamoa/features/income/domain/usecases/update_income_usecase.dart';

// packages
import 'package:riverpod_annotation/riverpod_annotation.dart';

// providers
import 'package:moamoa/features/common/providers/core_providers.dart';

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
GetIncomeListUseCase getIncomeListUseCase(Ref ref) {
  return GetIncomeListUseCase(ref.read(incomeRepositoryProvider));
}

@riverpod
CreateIncomeUseCase createIncomeUseCase(Ref ref) {
  return CreateIncomeUseCase(ref.read(incomeRepositoryProvider));
}

@riverpod
GetIncomeDetailUseCase getIncomeDetailUseCase(Ref ref) {
  return GetIncomeDetailUseCase(ref.read(incomeRepositoryProvider));
}

@riverpod
UpdateIncomeUseCase updateIncomeUseCase(Ref ref) {
  return UpdateIncomeUseCase(ref.read(incomeRepositoryProvider));
}

@riverpod
DeleteIncomeUseCase deleteIncomeUseCase(Ref ref) {
  return DeleteIncomeUseCase(ref.read(incomeRepositoryProvider));
}
