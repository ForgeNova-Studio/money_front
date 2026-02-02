import 'package:moamoa/features/statistics/data/models/monthly_statistics_model.dart';

/// 통계 Remote DataSource 인터페이스
abstract class StatisticsRemoteDataSource {
  /// 월간 통계 조회
  ///
  /// [year] 년도
  /// [month] 월 (1-12)
  /// [accountBookId] 장부 ID (null이면 기본 장부)
  Future<MonthlyStatisticsModel> getMonthlyStatistics({
    required int year,
    required int month,
    String? accountBookId,
  });
}
