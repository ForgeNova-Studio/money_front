import 'package:moamoa/features/common/providers/core_providers.dart';
import 'package:moamoa/features/statistics/data/datasources/statistics_remote_datasource.dart';
import 'package:moamoa/features/statistics/data/datasources/statistics_remote_datasource_impl.dart';
import 'package:moamoa/features/statistics/data/repositories/statistics_repository_impl.dart';
import 'package:moamoa/features/statistics/domain/repositories/statistics_repository.dart';
import 'package:moamoa/features/statistics/domain/usecases/get_monthly_statistics_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'statistics_providers.g.dart';

// ============================================================================
// DataSource Provider
// ============================================================================

@riverpod
StatisticsRemoteDataSource statisticsRemoteDataSource(Ref ref) {
  return StatisticsRemoteDataSourceImpl(dio: ref.read(dioProvider));
}

// ============================================================================
// Repository Provider
// ============================================================================

@riverpod
StatisticsRepository statisticsRepository(Ref ref) {
  return StatisticsRepositoryImpl(ref.read(statisticsRemoteDataSourceProvider));
}

// ============================================================================
// UseCase Provider
// ============================================================================

@riverpod
GetMonthlyStatisticsUseCase getMonthlyStatisticsUseCase(Ref ref) {
  return GetMonthlyStatisticsUseCase(ref.read(statisticsRepositoryProvider));
}
