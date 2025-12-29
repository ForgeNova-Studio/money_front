// packages
import 'package:riverpod_annotation/riverpod_annotation.dart';

// core
import 'package:moneyflow/core/providers/core_providers.dart';

// dataSource
import 'package:moneyflow/features/home/data/datasources/home_remote_data_source.dart';

// repository
import 'package:moneyflow/features/home/data/repositories/home_repository_impl.dart';
import 'package:moneyflow/features/home/domain/repositories/home_repository.dart';

// usecase
import 'package:moneyflow/features/home/domain/usecases/get_home_monthly_data_usecase.dart';

part 'home_providers.g.dart';

@riverpod
HomeRemoteDataSource homeRemoteDataSource(Ref ref) {
  return HomeRemoteDataSourceImpl(dio: ref.read(dioProvider));
}

@riverpod
HomeRepository homeRepository(Ref ref) {
  return HomeRepositoryImpl(
    homeRemoteDataSource: ref.read(homeRemoteDataSourceProvider),
  );
}

@riverpod
GetHomeMonthlyDataUseCase getHomeMonthlyDataUseCase(Ref ref) {
  return GetHomeMonthlyDataUseCase(ref.read(homeRepositoryProvider));
}
