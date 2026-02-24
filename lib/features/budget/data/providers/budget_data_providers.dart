import 'package:moamoa/features/budget/data/datasources/remote/budget_remote_datasource.dart';
import 'package:moamoa/features/budget/data/datasources/remote/budget_remote_datasource_impl.dart';
import 'package:moamoa/features/budget/data/repositories/budget_repository_impl.dart';
import 'package:moamoa/features/budget/domain/repositories/budget_repository.dart';
import 'package:moamoa/features/common/providers/core_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budget_data_providers.g.dart';

@riverpod
BudgetRemoteDataSource budgetRemoteDataSource(Ref ref) {
  return BudgetRemoteDataSourceImpl(dio: ref.read(dioProvider));
}

@riverpod
BudgetRepository budgetRepository(Ref ref) {
  return BudgetRepositoryImpl(
    remoteDataSource: ref.read(budgetRemoteDataSourceProvider),
  );
}