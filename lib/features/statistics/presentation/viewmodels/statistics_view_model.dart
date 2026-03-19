import 'dart:async';

import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/common/providers/expense_sync_provider.dart';
import 'package:moamoa/features/statistics/domain/entities/category_monthly_comparison.dart';
import 'package:moamoa/features/statistics/domain/entities/monthly_statistics.dart';
import 'package:moamoa/features/statistics/presentation/providers/statistics_providers.dart';
import 'package:moamoa/features/statistics/presentation/states/statistics_state.dart';
import 'package:moamoa/features/statistics/presentation/viewmodels/statistics_cache_key.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'statistics_view_model.g.dart';

@riverpod
class StatisticsViewModel extends _$StatisticsViewModel {
  /// 월별 통계 캐시 (key: accountBook + yyyyMM)
  final Map<StatisticsCacheKey, MonthlyStatistics> _cache = {};

  /// 월별 카테고리 비교 캐시 (key: accountBook + yyyyMM)
  final Map<StatisticsCacheKey, CategoryMonthlyComparison> _comparisonCache =
      {};

  /// 초기 상태를 만들고, 외부 변경 이벤트(가계부/지출)를 구독한다.
  ///
  /// - 가계부 변경 시: 캐시 전체 초기화 후 현재 선택 월 강제 재조회
  /// - 지출 변경 시: 해당 월 캐시 무효화 후 (현재 보고 있는 월이면) 강제 재조회
  @override
  StatisticsState build() {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);

    // 가계부가 변경되었을 때, 기존 캐시를 모두 초기화 하고, 현재 선택 월의 데이터를 강제로 다시 불러온다.
    ref.listen<AsyncValue<String?>>(
      selectedAccountBookViewModelProvider,
      (previous, next) {
        final previousId = previous?.asData?.value;
        final nextId = next.asData?.value;
        if (previousId == nextId) {
          return;
        }
        _cache.clear();
        _comparisonCache.clear();
        unawaited(_fetchStatistics(state.selectedMonth, forceRefresh: true));
      },
    );

    // 사용자가 새로운 지출 내역을 추가/수정/삭제 했을 때 변경 신호를 감지하고 실행
    ref.listen<ExpenseSyncSignal?>(expenseSyncProvider, (previous, next) {
      if (next == null) {
        return;
      }

      final selectedAccountBookId =
          ref.read(selectedAccountBookViewModelProvider).asData?.value;
      if (next.accountBookId != null &&
          next.accountBookId != selectedAccountBookId) {
        return;
      }

      _invalidateMonthCache(
        month: next.month,
        accountBookId: selectedAccountBookId,
      );

      if (_isSameMonth(next.month, state.selectedMonth)) {
        unawaited(_fetchStatistics(state.selectedMonth, forceRefresh: true));
      }
    });

    // 초기 데이터 로드 (비동기)
    Future.microtask(() => _fetchStatistics(currentMonth));

    return StatisticsState(
      selectedMonth: currentMonth,
      currentMonth: currentMonth,
    );
  }

  /// 월 변경
  ///
  /// [delta]가 -1이면 이전 달, 1이면 다음 달로 이동한다.
  /// 미래 월 이동은 차단한다.
  void changeMonth(int delta) {
    final newMonth = DateTime(
      state.selectedMonth.year,
      state.selectedMonth.month + delta,
    );

    // 미래 월 이동 방지
    if (newMonth.isAfter(state.currentMonth)) return;

    state = state.copyWith(selectedMonth: newMonth);
    _fetchStatistics(newMonth);
  }

  /// 이번달로 이동
  ///
  /// 이미 이번 달이면 아무 동작도 하지 않는다.
  void goToCurrentMonth() {
    if (state.isCurrentMonth) return;
    state = state.copyWith(selectedMonth: state.currentMonth);
    _fetchStatistics(state.currentMonth);
  }

  /// 새로고침
  ///
  /// 현재 선택 월의 캐시를 무효화하고 서버 데이터를 강제로 다시 불러온다.
  Future<void> refresh() async {
    final accountBookId =
        ref.read(selectedAccountBookViewModelProvider).asData?.value;
    _invalidateMonthCache(
      month: state.selectedMonth,
      accountBookId: accountBookId,
    );
    await _fetchStatistics(state.selectedMonth, forceRefresh: true);
  }

  /// 통계 데이터 가져오기
  ///
  /// [forceRefresh]가 false면 캐시 우선, true면 캐시를 무시하고 서버 호출을 수행한다.
  /// 통계/카테고리 비교 API를 병렬 호출해 상태를 한번에 갱신한다.
  Future<void> _fetchStatistics(DateTime month,
      {bool forceRefresh = false}) async {
    final accountBookId =
        ref.read(selectedAccountBookViewModelProvider).asData?.value;
    final key = _cacheKey(month, accountBookId);

    // 캐시 확인
    if (!forceRefresh &&
        _cache.containsKey(key) &&
        _comparisonCache.containsKey(key)) {
      state = state.copyWith(
        statistics: AsyncValue.data(_cache[key]),
        categoryComparison: AsyncValue.data(_comparisonCache[key]),
      );
      return;
    }

    // 데이터가 없는 경우에만 로딩 상태로 변경 (리프레시 시 깜빡임 방지)
    if (state.statistics.value == null) {
      state = state.copyWith(
        statistics: const AsyncValue.loading(),
        categoryComparison: const AsyncValue.loading(),
      );
    }

    // API 호출
    final statisticsUseCase = ref.read(getMonthlyStatisticsUseCaseProvider);
    final comparisonRepository = ref.read(statisticsRepositoryProvider);

    try {
      // 병렬로 두 API 호출
      final results = await Future.wait([
        statisticsUseCase(
          year: month.year,
          month: month.month,
          accountBookId: accountBookId,
        ),
        comparisonRepository.getCategoryMonthlyComparison(
          year: month.year,
          month: month.month,
          accountBookId: accountBookId,
        ),
      ]);

      final statistics = results[0] as MonthlyStatistics;
      final comparison = results[1] as CategoryMonthlyComparison;

      // 캐시 저장
      _cache[key] = statistics;
      _comparisonCache[key] = comparison;

      state = state.copyWith(
        statistics: AsyncValue.data(statistics),
        categoryComparison: AsyncValue.data(comparison),
      );
    } catch (e, st) {
      state = state.copyWith(
        statistics: AsyncValue.error(e, st),
        categoryComparison: AsyncValue.error(e, st),
      );
    }
  }

  /// DateTime(년/월)을 정수 키(yyyyMM)로 변환한다.
  int _monthKey(DateTime month) => month.year * 100 + month.month;

  /// 캐시 키 객체를 생성한다. (가계부 + 월)
  StatisticsCacheKey _cacheKey(DateTime month, String? accountBookId) {
    return StatisticsCacheKey(
      monthKey: _monthKey(month),
      accountBookId: accountBookId,
    );
  }

  /// 두 날짜가 같은 연/월인지 비교한다.
  bool _isSameMonth(DateTime left, DateTime right) {
    return left.year == right.year && left.month == right.month;
  }

  /// 특정 월 캐시를 무효화한다.
  ///
  /// [accountBookId]가 null이면 해당 월의 모든 가계부 캐시를 제거하고,
  /// 값이 있으면 해당 가계부+월 조합만 제거한다.
  void _invalidateMonthCache({
    required DateTime month,
    String? accountBookId,
  }) {
    final monthKey = _monthKey(month);
    if (accountBookId == null) {
      _cache.removeWhere((key, _) => key.monthKey == monthKey);
      _comparisonCache.removeWhere((key, _) => key.monthKey == monthKey);
      return;
    }

    final key = StatisticsCacheKey(
      monthKey: monthKey,
      accountBookId: accountBookId,
    );
    _cache.remove(key);
    _comparisonCache.remove(key);
  }
}
