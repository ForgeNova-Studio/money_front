import 'dart:async';

import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/budget/domain/providers/budget_usecase_providers.dart';
import 'package:moamoa/features/budget/presentation/constants/budget_error_messages.dart';
import 'package:moamoa/features/budget/presentation/states/budget_settings_state.dart';
import 'package:moamoa/features/budget/presentation/utils/budget_amount_utils.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'budget_settings_view_model.g.dart';

@riverpod
class BudgetSettingsViewModel extends _$BudgetSettingsViewModel {
  static const _monthChangeDebounceDuration = Duration(milliseconds: 150);
  static const _prefetchRetryCount = 1;

  bool _initialized = false;
  int _latestMonthRequestId = 0;
  Timer? _monthChangeDebounceTimer;
  final Map<String, Future<BudgetEntity?>> _inFlightMonthlyBudgetRequests = {};

  @override
  BudgetSettingsState build() {
    ref.onDispose(() {
      _monthChangeDebounceTimer?.cancel();
      _inFlightMonthlyBudgetRequests.clear();
    });

    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);

    return BudgetSettingsState.initial(
      currentMonth: currentMonth,
      selectedMonth: currentMonth,
    );
  }

  /// 예산 설정 첫 진입 초기화 담당
  /// - 선택된 월의 예산, 이전 달의 예산, 다음 달의 예산을 미리 캐시에 채운다.
  Future<void> initialize(DateTime? initialDate) async {
    // 초기화는 한 번만 수행한다. 이미 초기화 된 상태면 리턴한다.
    if (_initialized) return;
    _initialized = true;

    // selectedMonth 초기화 및 가공
    // initialDate가 null이면 현재 월을 선택한다.
    final selectedMonth = initialDate != null
        ? DateTime(initialDate.year, initialDate.month)
        : state.currentMonth;

    state = state.copyWith(selectedMonth: selectedMonth);
    await _prefetchBudgets();
  }

  /// 선택된 월의 예산, 이전 달의 예산, 다음 달의 예산을 미리 캐싱한다
  /// 즉 선택된 월과 +- 1인 달의 예산을 캐싱
  Future<void> _prefetchBudgets() async {
    // 가계부 ID를 가져온다.
    final accountBookId = _resolveAccountBookId();
    if (accountBookId == null) {
      state = state.copyWith(isInitialLoading: false);
      return;
    }

    // 선택된 월과 +-1인 달의 예산을 캐싱하기 위해 월 선별
    final baseMonth = state.selectedMonth;
    bool selectedMonthFetchFailed = false;
    final months = <DateTime>[];
    for (int i = -1; i <= 1; i++) {
      months.add(DateTime(baseMonth.year, baseMonth.month + i));
    }

    // 선택된 월들에 대한 캐싱
    final updatedCache = Map<String, BudgetEntity?>.from(state.budgetCache);

    await Future.wait(months.map((month) async {
      final key = buildBudgetMonthKey(month);
      if (updatedCache.containsKey(key)) return;

      try {
        final budget = await _getMonthlyBudgetWithDedupe(
          month: month,
          accountBookId: accountBookId,
          retryCount: _prefetchRetryCount,
        );
        updatedCache[key] = budget;
      } catch (_) {
        if (month.year == baseMonth.year && month.month == baseMonth.month) {
          selectedMonthFetchFailed = true;
        }
        // 프리페치 실패는 캐시하지 않는다.
      }
    }));

    if (!ref.mounted) return;
    if (selectedMonthFetchFailed) {
      _showError(BudgetErrorMessages.selectedMonthBudgetLoadFailed);
    }
    state = state.copyWith(
      budgetCache: updatedCache,
      isInitialLoading: false,
    );
  }

  /// 이벤트가 종료되면 이벤트를 비운다
  void clearEvent() {
    if (state.event == null) return;
    state = state.copyWith(event: null);
  }

  /// 월을 변경한다.
  /// [delta] 만큼 [selectedMonth]를 즉시 갱신하고,
  /// 실제 월 데이터 조회는 디바운스 스케줄러([_scheduleMonthFetch])로 위임한다.
  Future<void> changeMonth(int delta) async {
    final newMonth = DateTime(
      state.selectedMonth.year,
      state.selectedMonth.month + delta,
    );

    state = state.copyWith(selectedMonth: newMonth);
    _scheduleMonthFetch(newMonth, direction: delta, useDebounce: true);
  }

  /// 현재 월로 이동한다.
  /// 현재 월이 아닐 때만 [selectedMonth]를 갱신하고,
  /// 즉시 조회(디바운스 미적용)로 데이터를 동기화한다.
  Future<void> goToCurrentMonth() async {
    if (state.isCurrentMonth) return;
    final month = state.currentMonth;
    state = state.copyWith(selectedMonth: month);
    _scheduleMonthFetch(month, direction: 0, useDebounce: false);
  }

  /// 예산 저장
  /// [amount] 만큼 예산을 저장한다.
  /// [amount]가 0보다 작으면 에러를 발생시킨다.
  /// [accountBookId]가 null이면 에러를 발생시킨다.
  /// [isSaving] 또는 [isDeleting]이 true이면 중복 요청을 무시한다.
  /// 저장 성공시 [BudgetSettingsPopWithToast] 이벤트를 발생시킨다.
  /// 저장 실패시 [BudgetSettingsShowError] 이벤트를 발생시킨다.
  Future<void> saveBudget(double amount) async {
    if (amount < 0) {
      _showError(BudgetErrorMessages.invalidBudgetAmount);
      return;
    }

    final accountBookId = _resolveAccountBookId();
    if (accountBookId == null) {
      _showError(BudgetErrorMessages.accountBookNotSelected);
      return;
    }

    if (state.isSaving || state.isDeleting) return;
    state = state.copyWith(isSaving: true);

    try {
      final selectedMonth = state.selectedMonth;
      final budget = await ref.read(createOrUpdateBudgetUseCaseProvider)(
        accountBookId: accountBookId,
        year: selectedMonth.year,
        month: selectedMonth.month,
        targetAmount: amount,
      );

      if (!ref.mounted) return;

      final updatedCache = Map<String, BudgetEntity?>.from(state.budgetCache)
        ..[buildBudgetMonthKey(selectedMonth)] = budget;
      state = state.copyWith(budgetCache: updatedCache);

      await ref.read(homeViewModelProvider.notifier).fetchMonthlyData(
            selectedMonth,
            forceRefresh: true,
          );

      if (!ref.mounted) return;
      state = state.copyWith(
        event: const BudgetSettingsPopWithToast('예산이 저장되었습니다.'),
      );
    } catch (_) {
      if (!ref.mounted) return;
      _showError(BudgetErrorMessages.budgetSaveFailed);
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isSaving: false);
      }
    }
  }

  /// 예산 삭제
  /// [budget]이 null이면 에러를 발생시킨다.
  /// [isSaving] 또는 [isDeleting]이 true이면 중복 요청을 무시한다.
  /// 삭제 성공시 [BudgetSettingsPop] 이벤트를 발생시킨다.
  /// 삭제 실패시 [BudgetSettingsShowError] 이벤트를 발생시킨다.
  Future<void> deleteSelectedBudget() async {
    final budget = state.selectedBudget;
    if (budget == null) {
      _showError(BudgetErrorMessages.noBudgetToDelete);
      return;
    }

    if (state.isSaving || state.isDeleting) return;
    state = state.copyWith(isDeleting: true);

    try {
      final selectedMonth = state.selectedMonth;

      await ref.read(deleteBudgetUseCaseProvider)(budgetId: budget.budgetId);

      if (!ref.mounted) return;

      final updatedCache = Map<String, BudgetEntity?>.from(state.budgetCache)
        ..[buildBudgetMonthKey(selectedMonth)] = null;
      state = state.copyWith(
        budgetCache: updatedCache,
        event: const BudgetSettingsPop(),
      );

      unawaited(
        ref.read(homeViewModelProvider.notifier).fetchMonthlyData(
              selectedMonth,
              forceRefresh: true,
            ),
      );
    } catch (_) {
      if (!ref.mounted) return;
      _showError(BudgetErrorMessages.budgetDeleteFailed);
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isDeleting: false);
      }
    }
  }

  /// 특정 월 예산을 조회해 캐시에 반영한다.
  /// - 캐시 hit면 본조회 없이 [direction] 방향 프리페치만 수행한다.
  /// - 캐시 miss면 본조회 후 캐시를 갱신하고 방향 프리페치를 수행한다.
  /// - [requestId]가 최신 요청이 아닐 경우 응답 반영을 중단한다.
  /// - 본조회 실패 시 해당 월 캐시를 제거하고 사용자 에러 이벤트를 발행한다.
  Future<void> _fetchAndCacheMonth(
    DateTime month, {
    required int direction,
    required int requestId,
  }) async {
    if (!_isLatestMonthRequest(requestId)) return;

    final key = buildBudgetMonthKey(month);

    if (state.budgetCache.containsKey(key)) {
      _prefetchDirectional(month, direction);
      return;
    }

    final accountBookId = _resolveAccountBookId();
    if (accountBookId == null) return;

    try {
      final budget = await _getMonthlyBudgetWithDedupe(
        month: month,
        accountBookId: accountBookId,
      );

      if (!ref.mounted || !_isLatestMonthRequest(requestId)) return;

      final updatedCache = Map<String, BudgetEntity?>.from(state.budgetCache)
        ..[key] = budget;
      state = state.copyWith(budgetCache: updatedCache);

      _prefetchDirectional(month, direction);
    } catch (_) {
      if (!ref.mounted || !_isLatestMonthRequest(requestId)) return;

      final updatedCache = Map<String, BudgetEntity?>.from(state.budgetCache)
        ..remove(key);
      state = state.copyWith(budgetCache: updatedCache);
      _showError(BudgetErrorMessages.selectedMonthBudgetLoadFailed);
    }
  }

  /// 월 이동 방향으로 인접 1개월을 백그라운드 프리패치한다.
  /// - [direction]이 0이면 프리패치하지 않는다.
  /// - 동일 월 요청이 진행 중이면 dedupe 로직([_getMonthlyBudgetWithDedupe])을 사용한다.
  /// - 프리패치는 실패 시 사용자 에러를 노출하지 않고 조용히 종료한다.
  void _prefetchDirectional(DateTime currentMonth, int direction) {
    if (direction == 0) return;

    final accountBookId = _resolveAccountBookId();
    if (accountBookId == null) return;

    final targetMonth =
        DateTime(currentMonth.year, currentMonth.month + direction);
    final key = buildBudgetMonthKey(targetMonth);

    if (state.budgetCache.containsKey(key)) return;

    unawaited(
      () async {
        try {
          final budget = await _getMonthlyBudgetWithDedupe(
            month: targetMonth,
            accountBookId: accountBookId,
            retryCount: _prefetchRetryCount,
          );

          if (!ref.mounted) return;
          final updatedCache =
              Map<String, BudgetEntity?>.from(state.budgetCache)
                ..[key] = budget;
          state = state.copyWith(budgetCache: updatedCache);
        } catch (_) {
          // 프리페치 실패는 캐시하지 않는다.
        }
      }(),
    );
  }

  /// 월 조회 실행을 스케줄링한다.
  /// - 호출 시마다 요청 번호를 증가시켜 이전 요청의 응답 반영을 차단한다.
  /// - [useDebounce]가 true면 [_monthChangeDebounceDuration] 이후 실행한다.
  /// - [useDebounce]가 false면 즉시 실행한다.
  void _scheduleMonthFetch(
    DateTime month, {
    required int direction,
    required bool useDebounce,
  }) {
    final requestId = ++_latestMonthRequestId;
    _monthChangeDebounceTimer?.cancel();

    void run() {
      if (!ref.mounted || !_isLatestMonthRequest(requestId)) return;
      unawaited(
        _fetchAndCacheMonth(
          month,
          direction: direction,
          requestId: requestId,
        ),
      );
    }

    if (!useDebounce) {
      run();
      return;
    }

    _monthChangeDebounceTimer = Timer(_monthChangeDebounceDuration, run);
  }

  /// 전달된 [requestId]가 최신 월 요청인지 확인한다.
  /// 최신 요청이 아니면 상태 반영을 중단해 레이스 컨디션을 방지한다.
  bool _isLatestMonthRequest(int requestId) {
    return requestId == _latestMonthRequestId;
  }

  /// 월별 in-flight dedupe 조회를 수행한다.
  /// - 이미 진행 중인 같은 월 요청이 있으면 해당 Future를 재사용한다.
  /// - 없으면 새 요청을 생성하고 완료 시 in-flight 맵에서 정리한다.
  /// - [retryCount]는 내부 재시도 횟수([_fetchMonthlyBudgetWithRetry])로 전달된다.
  Future<BudgetEntity?> _getMonthlyBudgetWithDedupe({
    required DateTime month,
    required String accountBookId,
    int retryCount = 0,
  }) {
    final key = buildBudgetMonthKey(month);
    final existing = _inFlightMonthlyBudgetRequests[key];
    if (existing != null) return existing;

    final future = _fetchMonthlyBudgetWithRetry(
      month: month,
      accountBookId: accountBookId,
      retryCount: retryCount,
    );
    _inFlightMonthlyBudgetRequests[key] = future;

    future.then<void>((_) {}, onError: (_, __) {}).whenComplete(() {
      final current = _inFlightMonthlyBudgetRequests[key];
      if (identical(current, future)) {
        _inFlightMonthlyBudgetRequests.remove(key);
      }
    });

    return future;
  }

  /// 월 예산 조회를 재시도 정책과 함께 수행한다.
  /// - 최대 [retryCount]만큼 재시도한다.
  /// - 재시도 간격은 120ms * 시도회수(backoff)다.
  /// - 재시도 한도를 초과하면 예외를 재던진다.
  Future<BudgetEntity?> _fetchMonthlyBudgetWithRetry({
    required DateTime month,
    required String accountBookId,
    required int retryCount,
  }) async {
    var attempts = 0;

    while (true) {
      try {
        return await ref.read(getMonthlyBudgetUseCaseProvider)(
          year: month.year,
          month: month.month,
          accountBookId: accountBookId,
        );
      } catch (_) {
        if (attempts >= retryCount) rethrow;
        attempts += 1;
        await Future<void>.delayed(
          Duration(milliseconds: 120 * attempts),
        );
      }
    }
  }

  /// 선택된 가계부의 ID를 반환한다.
  String? _resolveAccountBookId() {
    final accountBookState = ref.read(selectedAccountBookViewModelProvider);
    return accountBookState.asData?.value;
  }

  /// 에러 이벤트를 추가한다.
  /// [message]를 포함한 [BudgetSettingsShowError] 이벤트를 추가한다.
  void _showError(String message) {
    state = state.copyWith(event: BudgetSettingsShowError(message));
  }
}
