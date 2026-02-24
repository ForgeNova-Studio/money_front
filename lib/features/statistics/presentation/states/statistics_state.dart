import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moamoa/features/statistics/domain/entities/category_monthly_comparison.dart';
import 'package:moamoa/features/statistics/domain/entities/monthly_statistics.dart';

part 'statistics_state.freezed.dart';

/// 월간 통계 화면 상태
@freezed
sealed class StatisticsState with _$StatisticsState {
  const factory StatisticsState({
    /// 선택된 월
    required DateTime selectedMonth,

    /// 현재 월 (미래 이동 방지용)
    required DateTime currentMonth,

    /// 월 통계 데이터
    @Default(AsyncValue.loading()) AsyncValue<MonthlyStatistics?> statistics,

    /// 카테고리별 전월 대비 데이터
    @Default(AsyncValue.loading())
    AsyncValue<CategoryMonthlyComparison?> categoryComparison,
  }) = _StatisticsState;

  const StatisticsState._();

  /// 현재 월인지 확인
  bool get isCurrentMonth =>
      selectedMonth.year == currentMonth.year &&
      selectedMonth.month == currentMonth.month;
}
