import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/statistics/domain/entities/category_monthly_comparison.dart';
import 'package:moamoa/features/statistics/domain/entities/monthly_statistics.dart';
import 'package:moamoa/features/statistics/presentation/providers/statistics_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'statistics_view_model.g.dart';

/// 월간 통계 상태
class StatisticsState {
  /// 선택된 월
  final DateTime selectedMonth;

  /// 현재 월 (미래 이동 방지용)
  final DateTime currentMonth;

  /// 통계 데이터
  final AsyncValue<MonthlyStatistics?> statistics;

  /// 카테고리별 전월 대비 데이터
  final AsyncValue<CategoryMonthlyComparison?> categoryComparison;

  const StatisticsState({
    required this.selectedMonth,
    required this.currentMonth,
    this.statistics = const AsyncValue.loading(),
    this.categoryComparison = const AsyncValue.loading(),
  });

  /// 현재 월인지 확인
  bool get isCurrentMonth =>
      selectedMonth.year == currentMonth.year &&
      selectedMonth.month == currentMonth.month;

  StatisticsState copyWith({
    DateTime? selectedMonth,
    DateTime? currentMonth,
    AsyncValue<MonthlyStatistics?>? statistics,
    AsyncValue<CategoryMonthlyComparison?>? categoryComparison,
  }) {
    return StatisticsState(
      selectedMonth: selectedMonth ?? this.selectedMonth,
      currentMonth: currentMonth ?? this.currentMonth,
      statistics: statistics ?? this.statistics,
      categoryComparison: categoryComparison ?? this.categoryComparison,
    );
  }
}

@riverpod
class StatisticsViewModel extends _$StatisticsViewModel {
  /// 월별 통계 캐시 (key: yyyyMM)
  final Map<int, MonthlyStatistics> _cache = {};

  /// 월별 카테고리 비교 캐시 (key: yyyyMM)
  final Map<int, CategoryMonthlyComparison> _comparisonCache = {};

  @override
  StatisticsState build() {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);

    // 초기 데이터 로드 (비동기)
    Future.microtask(() => _fetchStatistics(currentMonth));

    return StatisticsState(
      selectedMonth: currentMonth,
      currentMonth: currentMonth,
    );
  }

  /// 월 변경
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
  void goToCurrentMonth() {
    if (state.isCurrentMonth) return;
    state = state.copyWith(selectedMonth: state.currentMonth);
    _fetchStatistics(state.currentMonth);
  }

  /// 새로고침
  Future<void> refresh() async {
    final key = _monthKey(state.selectedMonth);
    _cache.remove(key);
    _comparisonCache.remove(key);
    await _fetchStatistics(state.selectedMonth, forceRefresh: true);
  }

  /// 통계 데이터 가져오기
  Future<void> _fetchStatistics(DateTime month,
      {bool forceRefresh = false}) async {
    final key = _monthKey(month);

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

    // 로딩 상태
    state = state.copyWith(
      statistics: const AsyncValue.loading(),
      categoryComparison: const AsyncValue.loading(),
    );

    // API 호출
    final accountBookId =
        ref.read(selectedAccountBookViewModelProvider).asData?.value;
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

  int _monthKey(DateTime month) => month.year * 100 + month.month;
}
