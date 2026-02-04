import 'package:moamoa/features/statistics/domain/entities/monthly_statistics.dart';

/// 통계 Repository 인터페이스
abstract class StatisticsRepository {
  /// 월간 통계 조회
  ///
  /// [year] 년도
  /// [month] 월 (1-12)
  /// [accountBookId] 장부 ID (null이면 기본 장부)
  Future<MonthlyStatistics> getMonthlyStatistics({
    required int year,
    required int month,
    String? accountBookId,
  });
}
