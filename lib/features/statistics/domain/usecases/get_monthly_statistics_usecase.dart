import 'package:moamoa/features/statistics/domain/entities/monthly_statistics.dart';
import 'package:moamoa/features/statistics/domain/repositories/statistics_repository.dart';

/// 월간 통계 조회 UseCase
class GetMonthlyStatisticsUseCase {
  final StatisticsRepository _repository;

  GetMonthlyStatisticsUseCase(this._repository);

  /// 월간 통계 조회
  ///
  /// [year] 년도
  /// [month] 월 (1-12)
  /// [accountBookId] 장부 ID (null이면 기본 장부)
  Future<MonthlyStatistics> call({
    required int year,
    required int month,
    String? accountBookId,
  }) async {
    return await _repository.getMonthlyStatistics(
      year: year,
      month: month,
      accountBookId: accountBookId,
    );
  }
}
