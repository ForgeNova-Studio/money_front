import 'dart:async';

import 'package:moneyflow/features/auth/presentation/viewmodels/auth_view_model.dart';
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
  static const Duration _cacheTtl = Duration(minutes: 5);

  @override
  HomeState build() {
    final now = DateTime.now();
    return HomeState(
      focusedMonth: now,
      selectedDate: now,
    );
  }

  /// 특정 월의 데이터를 가져옵니다.
  Future<void> fetchMonthlyData(
    DateTime month, {
    bool forceRefresh = false,
  }) async {
    final userId = _resolveUserId();
    final repository = ref.read(homeRepositoryProvider);

    var hasCache = false;

    if (!forceRefresh) {
      final cached = await repository.getCachedMonthlyHomeData(
        yearMonth: month,
        userId: userId,
      );

      if (cached != null) {
        hasCache = true;
        state = state.copyWith(
          monthlyData: AsyncValue.data(cached.data),
          focusedMonth: month,
        );

        if (!cached.isExpired(_cacheTtl)) {
          _prefetchAdjacentMonths(month, userId);
          return;
        }
      }
    }

    if (!hasCache) {
      state = state.copyWith(
        monthlyData: const AsyncValue.loading(),
        focusedMonth: month,
      );
    } else {
      state = state.copyWith(focusedMonth: month);
    }

    final useCase = ref.read(getHomeMonthlyDataUseCaseProvider);
    final result = await AsyncValue.guard(
      () => useCase(yearMonth: month, userId: userId),
    );

    if (!ref.mounted) return;

    if (result.hasError && hasCache) {
      // Remote failure should not break cache usage.
    } else {
      state = state.copyWith(monthlyData: result);
    }

    _prefetchAdjacentMonths(month, userId);
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
    await fetchMonthlyData(state.focusedMonth, forceRefresh: true);
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

    final userId = _resolveUserId();
    final targetMonth =
        DateTime(transaction.date.year, transaction.date.month, 1);
    await ref.read(homeRepositoryProvider).invalidateMonthlyHomeData(
          yearMonth: targetMonth,
          userId: userId,
        );

    await refresh();
  }

  void _prefetchAdjacentMonths(DateTime month, String userId) {
    final previous = DateTime(month.year, month.month - 1, 1);
    final next = DateTime(month.year, month.month + 1, 1);

    unawaited(_prefetchMonth(previous, userId));
    unawaited(_prefetchMonth(next, userId));
  }

  Future<void> _prefetchMonth(DateTime month, String userId) async {
    final repository = ref.read(homeRepositoryProvider);
    final cached = await repository.getCachedMonthlyHomeData(
      yearMonth: month,
      userId: userId,
    );

    if (cached != null && !cached.isExpired(_cacheTtl)) {
      return;
    }

    try {
      final useCase = ref.read(getHomeMonthlyDataUseCaseProvider);
      await useCase(yearMonth: month, userId: userId);
    } catch (e) {
      // Ignore prefetch failures.
    }
  }

  String _resolveUserId() {
    final authState = ref.read(authViewModelProvider);
    return authState.user?.userId ?? 'anonymous';
  }
}
