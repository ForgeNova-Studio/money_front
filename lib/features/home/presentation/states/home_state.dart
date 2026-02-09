import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/home/domain/entities/daily_transaction_summary.dart';
import 'package:table_calendar/table_calendar.dart';

part 'home_state.freezed.dart';

/// 홈 화면의 UI 상태를 담는 불변(Immutable) 상태 클래스
///
/// Freezed를 사용하여 불변 객체로 구현되며,
/// [HomeViewModel]에서 관리됩니다.
///
/// 주요 속성:
/// - [monthlyData]: 월간 일별 거래 요약 데이터 (AsyncValue)
/// - [focusedMonth]: 캘린더에서 현재 보고 있는 월
/// - [selectedDate]: 사용자가 선택한 날짜
/// - [calendarFormat]: 캘린더 표시 형식 (월간/주간)
/// - [budgetInfo]: 이번 달 예산 정보 (null이면 미설정)
/// - [assetInfo]: 총 자산 정보
///
/// 사용 예시:
/// ```dart
/// final state = HomeState(
///   focusedMonth: DateTime.now(),
///   selectedDate: DateTime.now(),
/// );
/// ```
@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState({
    @Default(AsyncValue.loading())
    AsyncValue<Map<String, DailyTransactionSummary>> monthlyData,
    required DateTime focusedMonth,
    required DateTime selectedDate,
    @Default(CalendarFormat.month) CalendarFormat calendarFormat,
    BudgetEntity? budgetInfo,
    AssetEntity? assetInfo,
  }) = _HomeState;
}
