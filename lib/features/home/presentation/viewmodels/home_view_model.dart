import 'package:flutter/widgets.dart';
import 'package:moneyflow/features/expense/presentation/providers/expense_providers.dart';
import 'package:moneyflow/features/home/domain/entities/transaction_entity.dart';
import 'package:moneyflow/features/home/presentation/providers/home_providers.dart';
import 'package:moneyflow/features/home/presentation/states/home_state.dart';
import 'package:moneyflow/features/income/presentation/providers/income_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:table_calendar/table_calendar.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  HomeState build() {
    final now = DateTime.now();
    // 초기 상태 설정 후 데이터 로드
    Future.microtask(() => fetchMonthlyData(now));

    return HomeState(
      focusedMonth: now,
      selectedDate: now,
    );
  }

  /// 특정 월의 데이터를 가져옵니다.
  Future<void> fetchMonthlyData(DateTime month) async {
    state = state.copyWith(
      monthlyData: const AsyncValue.loading(),
      focusedMonth: month,
    );

    final useCase = ref.read(getHomeMonthlyDataUseCaseProvider);

    final result = await AsyncValue.guard(
      () => useCase(yearMonth: month),
    );

    state = state.copyWith(monthlyData: result);

    debugPrint(result.toString());
  }

  /// 날짜가 선택되었을 때 호출
  void selectDate(DateTime selectedDate) {
    final previousFocusedMonth = state.focusedMonth;
    final shouldFetchMonthlyData =
        previousFocusedMonth.year != selectedDate.year ||
            previousFocusedMonth.month != selectedDate.month;

    state = state.copyWith(
      selectedDate: selectedDate,
      focusedMonth: selectedDate, // 선택된 날짜로 포커스 이동
      calendarFormat: CalendarFormat.week,
    );

    // 만약 월이 바뀌었다면 데이터도 새로 불러옴 (예: 주간 달력에서 월이 걸쳐있는 경우)
    if (shouldFetchMonthlyData) {
      fetchMonthlyData(selectedDate);
    }
  }

  /// 달력의 달이 바뀌었을 때 호출
  void changeMonth(DateTime focusedMonth) {
    if (focusedMonth.year != state.focusedMonth.year ||
        focusedMonth.month != state.focusedMonth.month) {
      fetchMonthlyData(focusedMonth);
    } else {
      // 월이 변경되지 않았더라도(주간 이동 등) 포커스 업데이트
      state = state.copyWith(focusedMonth: focusedMonth);
    }
  }

  /// 달력 표시 형식 변경
  void setCalendarFormat(CalendarFormat format) {
    state = state.copyWith(calendarFormat: format);
  }

  /// 드래그 시트 닫힘 등에서 월간 보기로 복귀
  void resetToMonthView() {
    if (state.calendarFormat != CalendarFormat.month) {
      state = state.copyWith(calendarFormat: CalendarFormat.month);
    }
  }

  /// 데이터 새로고침
  Future<void> refresh() async {
    await fetchMonthlyData(state.focusedMonth);
  }

  // 지출/수입 삭제
  Future<void> deleteTransaction(TransactionEntity transaction) async {
    if (transaction.id.isEmpty) {
      throw StateError('Invalid transaction id');
    }

    if (transaction.type == TransactionType.expense) {
      await ref.read(deleteExpenseUseCaseProvider).call(transaction.id);
    } else {
      await ref
          .read(deleteIncomeUsecaseProvider)
          .call(incomeId: transaction.id);
    }

    await refresh();
  }
}
