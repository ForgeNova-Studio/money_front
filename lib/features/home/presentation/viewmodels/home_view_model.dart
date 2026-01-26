import 'dart:async';

import 'package:intl/intl.dart';

import 'package:flutter/foundation.dart';
import 'package:moamoa/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/budget/presentation/providers/budget_providers.dart';
import 'package:moamoa/features/expense/presentation/providers/expense_providers.dart';
import 'package:moamoa/features/home/domain/entities/daily_transaction_summary.dart';
import 'package:moamoa/features/home/domain/entities/transaction_entity.dart';
import 'package:moamoa/features/home/domain/entities/monthly_home_cache.dart';
import 'package:moamoa/features/home/presentation/providers/home_providers.dart';
import 'package:moamoa/features/home/presentation/states/home_state.dart';
import 'package:moamoa/features/income/presentation/providers/income_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:table_calendar/table_calendar.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  static const Duration _cacheTtl = Duration(minutes: 5);
  int _latestRequestId = 0;
  // Track account book changes to invalidate in-memory budget/asset cache.
  String? _cachedAccountBookId;
  // Cache monthly budget per YYYYMM key to align with monthly prefetch.
  final Map<int, _BudgetCacheEntry> _budgetCache = {};
  // Cache total assets (not month-specific) with the same TTL.
  _AssetCacheEntry? _assetCache;

  @override
  HomeState build() {
    ref.listen<AsyncValue<String?>>(
      selectedAccountBookViewModelProvider,
      (previous, next) {
        final previousId = previous?.asData?.value;
        final nextId = next.asData?.value;
        if (nextId == previousId) {
          return;
        }
        if (nextId == null) {
          _resetBudgetAndAssetCache(null);
          state = state.copyWith(
            monthlyData: const AsyncValue.data({}),
          );
          return;
        }
        _resetBudgetAndAssetCache(nextId);
        unawaited(fetchMonthlyData(state.focusedMonth, forceRefresh: true));
      },
      fireImmediately: true,
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
    if (!ref.mounted) return;
    final userId = _resolveUserId();
    final accountBookId = _resolveAccountBookId();
    if (accountBookId == null) {
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
    final requestId = ++_latestRequestId;

    var hasCache = false;
    MonthlyHomeCache? cached;
    final cacheUserId = userId;
    final canUseCache = useCache && cacheUserId != null;

    // 홈 진입 시 캐시를 먼저 읽어 바로 표시
    if (canUseCache) {
      cached = await repository.getCachedMonthlyHomeData(
        yearMonth: month,
        userId: cacheUserId,
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
        if (userId != null) {
          _prefetchAdjacentMonths(month, userId, accountBookId);
        }
        // 캐시를 사용하더라도 예산/자산 정보는 갱신
        unawaited(
          _fetchBudgetAndAssetInfo(
            month,
            accountBookId,
            forceRefresh: forceRefresh,
          ),
        );
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

    AsyncValue<Map<String, DailyTransactionSummary>> result;
    final useCase = ref.read(getHomeMonthlyDataUseCaseProvider);
    result = await AsyncValue.guard(
      () => useCase(
        yearMonth: month,
        userId: userId ?? '',
        accountBookId: accountBookId,
      ),
    );

    if (!ref.mounted || requestId != _latestRequestId) return;

    if (result.hasError && hasCache) {
      ref.read(homeRefreshErrorProvider.notifier).set('최신 데이터를 불러오지 못했습니다.');
      // Remote failure should not break cache usage.
    } else {
      state = state.copyWith(monthlyData: result);
    }

    // 예산/자산 정보 가져오기
    await _fetchBudgetAndAssetInfo(
      month,
      accountBookId,
      forceRefresh: forceRefresh,
    );

    if (!ref.mounted) return;
    if (userId != null) {
      _prefetchAdjacentMonths(month, userId, accountBookId);
    }
  }

  /// 예산 및 자산 정보 가져오기
  Future<void> _fetchBudgetAndAssetInfo(
    DateTime month,
    String accountBookId, {
    bool forceRefresh = false,
  }) async {
    final monthKey = _monthKey(month);
    final now = DateTime.now();

    BudgetEntity? nextBudgetInfo = state.budgetInfo;
    AssetEntity? nextAssetInfo = state.assetInfo;

    final cachedBudgetEntry = forceRefresh ? null : _budgetCache[monthKey];
    final hasFreshBudgetCache =
        cachedBudgetEntry != null && !cachedBudgetEntry.isExpired(_cacheTtl);

    if (cachedBudgetEntry != null && cachedBudgetEntry.isExpired(_cacheTtl)) {
      _budgetCache.remove(monthKey);
    }

    final cachedAssetEntry = forceRefresh ? null : _assetCache;
    final hasFreshAssetCache =
        cachedAssetEntry != null && !cachedAssetEntry.isExpired(_cacheTtl);

    if (cachedAssetEntry != null && cachedAssetEntry.isExpired(_cacheTtl)) {
      _assetCache = null;
    }

    if (hasFreshBudgetCache) {
      nextBudgetInfo = cachedBudgetEntry?.value;
    }
    if (hasFreshAssetCache) {
      nextAssetInfo = cachedAssetEntry?.value;
    }

    if ((hasFreshBudgetCache || hasFreshAssetCache) && ref.mounted) {
      state = state.copyWith(
        budgetInfo: nextBudgetInfo,
        assetInfo: nextAssetInfo,
      );
      if (hasFreshBudgetCache && hasFreshAssetCache && !forceRefresh) {
        return;
      }
    }

    try {
      if (!ref.mounted) return;
      // 예산 정보 가져오기
      final budgetUseCase = ref.read(getMonthlyBudgetUseCaseProvider);
      if (!hasFreshBudgetCache || forceRefresh) {
        nextBudgetInfo = await budgetUseCase(
          year: month.year,
          month: month.month,
          accountBookId: accountBookId,
        );
        _budgetCache[monthKey] = _BudgetCacheEntry(
          value: nextBudgetInfo,
          cachedAt: now,
        );
      }

      // 자산 정보 가져오기
      final assetUseCase = ref.read(getTotalAssetsUseCaseProvider);
      if (!hasFreshAssetCache || forceRefresh) {
        nextAssetInfo = await assetUseCase(
          accountBookId: accountBookId,
        );
        if (nextAssetInfo != null) {
          _assetCache = _AssetCacheEntry(
            value: nextAssetInfo,
            cachedAt: now,
          );
        }
      }

      if (!ref.mounted) return;

      state = state.copyWith(
        budgetInfo: nextBudgetInfo,
        assetInfo: nextAssetInfo,
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[HomeViewModel] Failed to fetch budget/asset info: $e');
        debugPrint('[HomeViewModel] Stack trace: $stackTrace');
      }
      // 예산/자산 정보 실패는 무시하고 기존 데이터 유지
    }
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

  // 지출/수입 삭제 (Optimistic Update)
  Future<void> deleteTransaction(TransactionEntity transaction) async {
    if (transaction.id.isEmpty) {
      throw StateError('Invalid transaction id');
    }

    // 1. Optimistic Update: 먼저 로컬 상태에서 해당 트랜잭션 제거
    final dateKey = DateFormat('yyyy-MM-dd').format(transaction.date);
    final currentData = state.monthlyData.asData?.value;
    if (currentData != null && currentData.containsKey(dateKey)) {
      final daySummary = currentData[dateKey]!;
      final updatedTransactions = daySummary.transactions
          .where((tx) => tx.id != transaction.id)
          .toList();

      final updatedIncome = transaction.type == TransactionType.income
          ? daySummary.totalIncome - transaction.amount
          : daySummary.totalIncome;
      final updatedExpense = transaction.type == TransactionType.expense
          ? daySummary.totalExpense - transaction.amount
          : daySummary.totalExpense;

      final updatedSummary = DailyTransactionSummary(
        date: daySummary.date,
        transactions: updatedTransactions,
        totalIncome: updatedIncome,
        totalExpense: updatedExpense,
      );

      final updatedData =
          Map<String, DailyTransactionSummary>.from(currentData);
      updatedData[dateKey] = updatedSummary;

      state = state.copyWith(
        monthlyData: AsyncValue.data(updatedData),
      );
    }

    // 2. 백그라운드에서 실제 삭제 API 호출
    if (transaction.type == TransactionType.expense) {
      await ref.read(deleteExpenseUseCaseProvider).call(transaction.id);
    } else {
      await ref
          .read(deleteIncomeUsecaseProvider)
          .call(incomeId: transaction.id);
    }

    // 3. 캐시 무효화 (다음 새로고침 시 최신 데이터 보장)
    final userId = _resolveUserId();
    final accountBookId = _resolveAccountBookId();
    if (accountBookId != null && userId != null) {
      final targetMonth =
          DateTime(transaction.date.year, transaction.date.month, 1);
      await ref.read(homeRepositoryProvider).invalidateMonthlyHomeData(
            yearMonth: targetMonth,
            userId: userId,
            accountBookId: accountBookId,
          );
    }
  }

  /// 낙관적 트랜잭션 추가 (등록 화면에서 호출)
  void addTransactionOptimistically(TransactionEntity transaction) {
    final dateKey = DateFormat('yyyy-MM-dd').format(transaction.date);
    final currentData = state.monthlyData.asData?.value;
    if (currentData == null) return;

    final daySummary = currentData[dateKey];
    final updatedTransactions = [
      ...?daySummary?.transactions,
      transaction,
    ];

    final updatedIncome = (daySummary?.totalIncome ?? 0) +
        (transaction.type == TransactionType.income ? transaction.amount : 0);
    final updatedExpense = (daySummary?.totalExpense ?? 0) +
        (transaction.type == TransactionType.expense ? transaction.amount : 0);

    final updatedSummary = DailyTransactionSummary(
      date: transaction.date,
      transactions: updatedTransactions,
      totalIncome: updatedIncome,
      totalExpense: updatedExpense,
    );

    final updatedData = Map<String, DailyTransactionSummary>.from(currentData);
    updatedData[dateKey] = updatedSummary;

    state = state.copyWith(
      monthlyData: AsyncValue.data(updatedData),
    );
  }

  /// 낙관적 트랜잭션 수정 (수정 화면에서 호출)
  void updateTransactionOptimistically({
    required TransactionEntity oldTransaction,
    required TransactionEntity newTransaction,
  }) {
    final currentData = state.monthlyData.asData?.value;
    if (currentData == null) return;

    final updatedData = Map<String, DailyTransactionSummary>.from(currentData);

    // 1. 기존 데이터 제거
    final oldDateKey = DateFormat('yyyy-MM-dd').format(oldTransaction.date);
    if (updatedData.containsKey(oldDateKey)) {
      final daySummary = updatedData[oldDateKey]!;
      final updatedTransactions = daySummary.transactions
          .where((tx) => tx.id != oldTransaction.id)
          .toList();

      final updatedIncome = daySummary.totalIncome -
          (oldTransaction.type == TransactionType.income
              ? oldTransaction.amount
              : 0);
      final updatedExpense = daySummary.totalExpense -
          (oldTransaction.type == TransactionType.expense
              ? oldTransaction.amount
              : 0);

      updatedData[oldDateKey] = DailyTransactionSummary(
        date: daySummary.date,
        transactions: updatedTransactions,
        totalIncome: updatedIncome,
        totalExpense: updatedExpense,
      );
    }

    // 2. 새로운 데이터 추가
    final newDateKey = DateFormat('yyyy-MM-dd').format(newTransaction.date);
    // 해당 날짜에 데이터가 없으면 새로 생성, 있으면 사용
    final daySummary = updatedData[newDateKey] ??
        DailyTransactionSummary(
          date: newTransaction.date,
          transactions: [],
          totalIncome: 0,
          totalExpense: 0,
        );

    final newTransactions = [...daySummary.transactions, newTransaction];
    // (선택사항) 시간순 정렬이 필요하다면 여기서 sort 수행

    final newIncome = daySummary.totalIncome +
        (newTransaction.type == TransactionType.income
            ? newTransaction.amount
            : 0);
    final newExpense = daySummary.totalExpense +
        (newTransaction.type == TransactionType.expense
            ? newTransaction.amount
            : 0);

    updatedData[newDateKey] = DailyTransactionSummary(
      date: daySummary.date,
      transactions: newTransactions,
      totalIncome: newIncome,
      totalExpense: newExpense,
    );

    state = state.copyWith(
      monthlyData: AsyncValue.data(updatedData),
    );
  }

  void _prefetchAdjacentMonths(
    DateTime month,
    String userId,
    String accountBookId,
  ) {
    if (!ref.mounted) return;
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
    if (!ref.mounted) return;
    final repository = ref.read(homeRepositoryProvider);
    final cached = await repository.getCachedMonthlyHomeData(
      yearMonth: month,
      userId: userId,
      accountBookId: accountBookId,
    );

    if (!ref.mounted) return;
    if (cached != null && !cached.isExpired(_cacheTtl)) {
      await _prefetchBudgetAndAssetInfo(month, accountBookId);
      return;
    }

    try {
      if (!ref.mounted) return;
      final useCase = ref.read(getHomeMonthlyDataUseCaseProvider);
      await useCase(
        yearMonth: month,
        userId: userId,
        accountBookId: accountBookId,
      );
      await _prefetchBudgetAndAssetInfo(month, accountBookId);
    } catch (e) {
      // Ignore prefetch failures.
    }
  }

  String? _resolveUserId() {
    final authState = ref.read(authViewModelProvider);
    return authState.user?.userId;
  }

  String? _resolveAccountBookId() {
    final accountBookState = ref.read(selectedAccountBookViewModelProvider);
    return accountBookState.asData?.value;
  }

  int _monthKey(DateTime month) {
    return (month.year * 100) + month.month;
  }

  // Clear in-memory budget/asset cache when account book changes.
  void _resetBudgetAndAssetCache(String? accountBookId) {
    if (_cachedAccountBookId == accountBookId) {
      return;
    }
    _cachedAccountBookId = accountBookId;
    _budgetCache.clear();
    _assetCache = null;
  }

  Future<void> _prefetchBudgetAndAssetInfo(
    DateTime month,
    String accountBookId,
  ) async {
    // Prefetch with cache guards to avoid redundant network calls.
    final monthKey = _monthKey(month);
    final now = DateTime.now();

    final cachedBudgetEntry = _budgetCache[monthKey];
    final hasFreshBudgetCache =
        cachedBudgetEntry != null && !cachedBudgetEntry.isExpired(_cacheTtl);
    if (cachedBudgetEntry != null && cachedBudgetEntry.isExpired(_cacheTtl)) {
      _budgetCache.remove(monthKey);
    }

    final cachedAssetEntry = _assetCache;
    final hasFreshAssetCache =
        cachedAssetEntry != null && !cachedAssetEntry.isExpired(_cacheTtl);
    if (cachedAssetEntry != null && cachedAssetEntry.isExpired(_cacheTtl)) {
      _assetCache = null;
    }

    if (hasFreshBudgetCache && hasFreshAssetCache) {
      return;
    }

    try {
      final budgetUseCase = ref.read(getMonthlyBudgetUseCaseProvider);
      if (!hasFreshBudgetCache) {
        final budgetInfo = await budgetUseCase(
          year: month.year,
          month: month.month,
          accountBookId: accountBookId,
        );
        _budgetCache[monthKey] = _BudgetCacheEntry(
          value: budgetInfo,
          cachedAt: now,
        );
      }

      final assetUseCase = ref.read(getTotalAssetsUseCaseProvider);
      if (!hasFreshAssetCache) {
        final assetInfo = await assetUseCase(
          accountBookId: accountBookId,
        );
        _assetCache = _AssetCacheEntry(
          value: assetInfo,
          cachedAt: now,
        );
      }
    } catch (_) {
      // Ignore prefetch failures.
    }
  }
}

class _BudgetCacheEntry {
  final BudgetEntity? value;
  final DateTime cachedAt;

  const _BudgetCacheEntry({
    required this.value,
    required this.cachedAt,
  });

  bool isExpired(Duration ttl) {
    return DateTime.now().difference(cachedAt) > ttl;
  }
}

class _AssetCacheEntry {
  final AssetEntity value;
  final DateTime cachedAt;

  const _AssetCacheEntry({
    required this.value,
    required this.cachedAt,
  });

  bool isExpired(Duration ttl) {
    return DateTime.now().difference(cachedAt) > ttl;
  }
}
