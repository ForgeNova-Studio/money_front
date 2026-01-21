// packages
import 'package:flutter_riverpod/flutter_riverpod.dart' as flutter_riverpod;
import 'package:riverpod_annotation/riverpod_annotation.dart';

// core
import 'package:moamoa/features/common/providers/core_providers.dart';

// dataSource
import 'package:moamoa/features/home/data/datasources/home_local_data_source.dart';
import 'package:moamoa/features/home/data/datasources/home_remote_data_source.dart';

// repository
import 'package:moamoa/features/home/data/repositories/home_repository_impl.dart';
import 'package:moamoa/features/home/domain/repositories/home_repository.dart';

// usecase
import 'package:moamoa/features/home/domain/usecases/get_home_monthly_data_usecase.dart';

part 'home_providers.g.dart';

// ============================================================================
// DataSource Providers
// ============================================================================
@riverpod
HomeRemoteDataSource homeRemoteDataSource(Ref ref) {
  return HomeRemoteDataSourceImpl(dio: ref.read(dioProvider));
}

final homeLocalDataSourceProvider =
    flutter_riverpod.Provider<HomeLocalDataSource>((ref) {
  return HomeLocalDataSourceImpl();
});

@riverpod
class HomeRefreshError extends _$HomeRefreshError {
  @override
  String? build() => null;

  void set(String message) {
    state = message;
  }

  void clear() {
    state = null;
  }
}

// ============================================================================
// Repository Provider
// ============================================================================
@riverpod
HomeRepository homeRepository(Ref ref) {
  return HomeRepositoryImpl(
    homeRemoteDataSource: ref.read(homeRemoteDataSourceProvider),
    homeLocalDataSource: ref.read(homeLocalDataSourceProvider),
  );
}

// ============================================================================
// UseCase Provider
// ============================================================================
@riverpod
GetHomeMonthlyDataUseCase getHomeMonthlyDataUseCase(Ref ref) {
  return GetHomeMonthlyDataUseCase(ref.read(homeRepositoryProvider));
}
