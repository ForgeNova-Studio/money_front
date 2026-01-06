import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneyflow/features/home/domain/entities/daily_transaction_summary.dart';
import 'package:table_calendar/table_calendar.dart';

part 'home_state.freezed.dart';

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState({
    /// 월별 데이터 (날짜 문자열 Key: "yyyy-MM-dd")
    @Default(AsyncValue.loading()) AsyncValue<Map<String, DailyTransactionSummary>> monthlyData,

    /// 현재 달력에서 보고 있는 달의 기준 날짜
    required DateTime focusedMonth,

    /// 사용자가 선택한 구체적인 날짜
    required DateTime selectedDate,

    /// 달력 표시 형식
    @Default(CalendarFormat.month) CalendarFormat calendarFormat,
  }) = _HomeState;
}
