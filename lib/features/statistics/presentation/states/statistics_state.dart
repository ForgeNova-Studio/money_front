import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moamoa/features/statistics/domain/entities/category_monthly_comparison.dart';
import 'package:moamoa/features/statistics/domain/entities/monthly_statistics.dart';

part 'statistics_state.freezed.dart';

/// 월간 통계 화면의 상태를 관리하는 State 클래스입니다.
///
/// **Key Features:**
/// * 선택된 월(`selectedMonth`) 및 현재 월(`currentMonth`) 정보 관리
/// * 월간 전체 통계 데이터(`statistics`) 상태 관리 (로딩, 성공, 에러)
/// * 카테고리별 전월 대비 비교 데이터(`categoryComparison`) 상태 관리
/// * 현재 선택된 월이 이번 달인지 확인하는 기능(`isCurrentMonth`) 제공
///
/// **Parameters:**
/// * [selectedMonth] - 사용자가 조회를 위해 선택한 기준 월입니다.
/// * [currentMonth] - 현재 앱 구동 기준의 시스템 월입니다. 미래로의 이동을 방지하기 위한 기준으로 사용됩니다.
/// * [statistics] - 통계 화면에 표시될 월간 전체 수입/지출 통계 데이터의 비동기 상태입니다.
/// * [categoryComparison] - 하단에 표시될 카테고리별 전월 대비 비교 데이터의 비동기 상태입니다.
///
/// **Usage Example:**
/// ```dart
/// final state = StatisticsState(
///   selectedMonth: DateTime(2024, 5),
///   currentMonth: DateTime.now(),
///   statistics: const AsyncValue.data(monthlyStatistics),
///   categoryComparison: const AsyncValue.loading(),
/// );
///
/// if (state.isCurrentMonth) {
///   print('현재 접속한 달의 통계를 보고 있습니다.');
/// }
/// ```
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
