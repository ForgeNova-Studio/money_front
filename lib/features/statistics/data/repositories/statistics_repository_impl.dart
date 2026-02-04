import 'package:moamoa/features/statistics/data/datasources/statistics_remote_datasource.dart';
import 'package:moamoa/features/statistics/domain/entities/monthly_statistics.dart';
import 'package:moamoa/features/statistics/domain/repositories/statistics_repository.dart';

/// 통계 Repository 구현체
class StatisticsRepositoryImpl implements StatisticsRepository {
  final StatisticsRemoteDataSource _remoteDataSource;

  StatisticsRepositoryImpl(this._remoteDataSource);

  @override
  Future<MonthlyStatistics> getMonthlyStatistics({
    required int year,
    required int month,
    String? accountBookId,
  }) async {
    final model = await _remoteDataSource.getMonthlyStatistics(
      year: year,
      month: month,
      accountBookId: accountBookId,
    );
    return model.toEntity();
  }
}
