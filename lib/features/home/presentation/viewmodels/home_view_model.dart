import 'dart:async';

import 'package:moneyflow/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:moneyflow/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moneyflow/features/expense/presentation/providers/expense_providers.dart';
import 'package:moneyflow/features/home/domain/entities/daily_transaction_summary.dart';
import 'package:moneyflow/features/home/domain/entities/transaction_entity.dart';
import 'package:moneyflow/features/home/domain/entities/monthly_home_cache.dart';
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
    ref.listen<AsyncValue<String?>>(
      selectedAccountBookViewModelProvider,
      (previous, next) {
        final previousId = previous?.asData?.value;
        final nextId = next.asData?.value;
        if (nextId == null || nextId == previousId) {
          return;
        }
        unawaited(fetchMonthlyData(state.focusedMonth, forceRefresh: true));
      },
    );

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
    bool useCache = true,
  }) async {
    final userId = _resolveUserId();
    final accountBookId = _resolveAccountBookId();
    void setRefreshIndicator(bool value) {
      if (!ref.mounted) return;
      ref.read(homeRefreshIndicatorProvider.notifier).set(value);
    }
    if (accountBookId == null) {
      setRefreshIndicator(false);
      state = state.copyWith(
        monthlyData: AsyncValue.error(
          StateError('Account book is not selected'),
          StackTrace.current,
        ),
        focusedMonth: month,
      );
      return;
    }
    final repository = ref.read(homeRepositoryProvider);

    var hasCache = false;
    MonthlyHomeCache? cached;

    // 홈 진입 시 캐시를 먼저 읽어 바로 표시
    if (useCache) {
      cached = await repository.getCachedMonthlyHomeData(
        yearMonth: month,
        userId: userId,
        accountBookId: accountBookId,
      );
    }

    if (cached != null) {
      hasCache = true;
      state = state.copyWith(
        monthlyData: AsyncValue.data(cached.data),
        focusedMonth: month,
      );

      if (!forceRefresh && !cached.isExpired(_cacheTtl)) {
        setRefreshIndicator(false);
        _prefetchAdjacentMonths(month, userId, accountBookId);
        return;
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

    final shouldShowRefreshIndicator = hasCache;
    if (shouldShowRefreshIndicator) {
      setRefreshIndicator(true);
    }

    AsyncValue<Map<String, DailyTransactionSummary>> result;
    try {
      final useCase = ref.read(getHomeMonthlyDataUseCaseProvider);
      result = await AsyncValue.guard(
        () => useCase(
          yearMonth: month,
          userId: userId,
          accountBookId: accountBookId,
        ),
      );
    } finally {
      if (shouldShowRefreshIndicator) {
        setRefreshIndicator(false);
      }
    }

    if (!ref.mounted) return;

    if (result.hasError && hasCache) {
      ref
          .read(homeRefreshErrorProvider.notifier)
          .set('최신 데이터를 불러오지 못했습니다.');
      // Remote failure should not break cache usage.
    } else {
      state = state.copyWith(monthlyData: result);
    }

    _prefetchAdjacentMonths(month, userId, accountBookId);
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
    final accountBookId = _resolveAccountBookId();
    if (accountBookId == null) {
      return;
    }
    final targetMonth =
        DateTime(transaction.date.year, transaction.date.month, 1);
    await ref.read(homeRepositoryProvider).invalidateMonthlyHomeData(
          yearMonth: targetMonth,
          userId: userId,
          accountBookId: accountBookId,
        );

    await refresh();
  }

  void _prefetchAdjacentMonths(
    DateTime month,
    String userId,
    String accountBookId,
  ) {
    final previous = DateTime(month.year, month.month - 1, 1);
    final next = DateTime(month.year, month.month + 1, 1);

    unawaited(_prefetchMonth(previous, userId, accountBookId));
    unawaited(_prefetchMonth(next, userId, accountBookId));
  }

  Future<void> _prefetchMonth(
    DateTime month,
    String userId,
    String accountBookId,
  ) async {
    final repository = ref.read(homeRepositoryProvider);
    final cached = await repository.getCachedMonthlyHomeData(
      yearMonth: month,
      userId: userId,
      accountBookId: accountBookId,
    );

    if (cached != null && !cached.isExpired(_cacheTtl)) {
      return;
    }

    try {
      final useCase = ref.read(getHomeMonthlyDataUseCaseProvider);
      await useCase(
        yearMonth: month,
        userId: userId,
        accountBookId: accountBookId,
      );
    } catch (e) {
      // Ignore prefetch failures.
    }
  }

  String _resolveUserId() {
    final authState = ref.read(authViewModelProvider);
    return authState.user?.userId ?? 'anonymous';
  }

  String? _resolveAccountBookId() {
    final accountBookState =
        ref.read(selectedAccountBookViewModelProvider);
    return accountBookState.asData?.value;
  }
}
