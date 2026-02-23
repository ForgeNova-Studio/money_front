import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/budget/domain/repositories/budget_repository.dart';
import 'package:moamoa/features/budget/data/providers/budget_data_providers.dart';
import 'package:moamoa/features/budget/presentation/states/budget_settings_state.dart';
import 'package:moamoa/features/budget/presentation/utils/budget_amount_utils.dart';
import 'package:moamoa/features/budget/presentation/viewmodels/budget_settings_view_model.dart';
import 'package:moamoa/features/home/presentation/states/home_state.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';

void main() {
  group('BudgetSettingsViewModel', () {
    test('initialize는 선택 월 기준 ±1개월을 프리페치한다', () async {
      final fakeRepository = _FakeBudgetRepository(
        monthlyBudgetByKey: {
          '2026-01': _budget(year: 2026, month: 1, targetAmount: 100000),
          '2026-02': _budget(year: 2026, month: 2, targetAmount: 200000),
          '2026-03': _budget(year: 2026, month: 3, targetAmount: 300000),
        },
      );
      final container = _createContainer(fakeRepository);
      addTearDown(container.dispose);

      final notifier = container.read(budgetSettingsViewModelProvider.notifier);
      await notifier.initialize(DateTime(2026, 2, 10));

      final state = container.read(budgetSettingsViewModelProvider);
      expect(state.isInitialLoading, false);
      expect(state.selectedMonth, DateTime(2026, 2));
      expect(state.budgetCache.keys,
          containsAll(['2026-01', '2026-02', '2026-03']));
      expect(fakeRepository.getMonthlyBudgetCalls.length, 3);
    });

    test('saveBudget 성공 시 캐시 갱신 및 PopWithToast 이벤트를 발행한다', () async {
      final fakeRepository = _FakeBudgetRepository(
        monthlyBudgetByKey: {
          '2026-02': null,
          '2026-01': null,
          '2026-03': null,
        },
        createOrUpdateResult:
            _budget(year: 2026, month: 2, targetAmount: 500000),
      );
      final container = _createContainer(fakeRepository);
      addTearDown(container.dispose);

      final notifier = container.read(budgetSettingsViewModelProvider.notifier);
      await notifier.initialize(DateTime(2026, 2, 1));
      await notifier.saveBudget(500000);

      final state = container.read(budgetSettingsViewModelProvider);
      final fakeHome =
          container.read(homeViewModelProvider.notifier) as _FakeHomeViewModel;

      expect(fakeRepository.createOrUpdateCallCount, 1);
      expect(state.selectedBudget?.targetAmount, 500000);
      expect(state.event, isA<BudgetSettingsPopWithToast>());
      expect(fakeHome.fetchMonthlyDataCallCount, 1);
      expect(fakeHome.lastForceRefresh, true);
    });

    test('deleteSelectedBudget 성공 시 선택 월 캐시를 null로 만들고 Pop 이벤트를 발행한다',
        () async {
      final existingBudget =
          _budget(year: 2026, month: 2, targetAmount: 400000);
      final fakeRepository = _FakeBudgetRepository(
        monthlyBudgetByKey: {
          '2026-01': null,
          '2026-02': existingBudget,
          '2026-03': null,
        },
      );
      final container = _createContainer(fakeRepository);
      addTearDown(container.dispose);

      final notifier = container.read(budgetSettingsViewModelProvider.notifier);
      await notifier.initialize(DateTime(2026, 2, 1));
      await notifier.deleteSelectedBudget();
      await Future<void>.delayed(Duration.zero);

      final state = container.read(budgetSettingsViewModelProvider);
      final fakeHome =
          container.read(homeViewModelProvider.notifier) as _FakeHomeViewModel;

      expect(fakeRepository.lastDeletedBudgetId, existingBudget.budgetId);
      expect(state.selectedBudget, isNull);
      expect(state.event, isA<BudgetSettingsPop>());
      expect(fakeHome.fetchMonthlyDataCallCount, 1);
      expect(fakeHome.lastForceRefresh, true);
    });

    test('선택 월 프리페치 실패 시 사용자 에러 이벤트를 발행한다', () async {
      final fakeRepository = _FakeBudgetRepository(
        monthlyBudgetByKey: {
          '2026-01': null,
          '2026-03': null,
        },
        failMonthlyBudgetKeys: {'2026-02'},
      );
      final container = _createContainer(fakeRepository);
      addTearDown(container.dispose);

      final notifier = container.read(budgetSettingsViewModelProvider.notifier);
      await notifier.initialize(DateTime(2026, 2, 1));

      final state = container.read(budgetSettingsViewModelProvider);
      expect(state.isInitialLoading, false);
      expect(state.event, isA<BudgetSettingsShowError>());
      expect(
        (state.event as BudgetSettingsShowError).message,
        '선택한 월의 예산 정보를 불러오지 못했습니다. 다시 시도해주세요.',
      );
    });
  });
}

ProviderContainer _createContainer(_FakeBudgetRepository repository) {
  final container = ProviderContainer(
    overrides: [
      selectedAccountBookViewModelProvider.overrideWithValue(
        const AsyncValue.data('account-book-1'),
      ),
      budgetRepositoryProvider.overrideWithValue(repository),
      homeViewModelProvider.overrideWith(_FakeHomeViewModel.new),
    ],
  );

  final budgetSubscription = container.listen(
    budgetSettingsViewModelProvider,
    (_, __) {},
  );
  final homeSubscription = container.listen(homeViewModelProvider, (_, __) {});

  addTearDown(budgetSubscription.close);
  addTearDown(homeSubscription.close);

  return container;
}

BudgetEntity _budget({
  required int year,
  required int month,
  required double targetAmount,
}) {
  return BudgetEntity(
    budgetId: 'budget-$year-$month',
    year: year,
    month: month,
    targetAmount: targetAmount,
    currentSpending: 0,
    remainingAmount: targetAmount,
    usagePercentage: 0,
  );
}

class _FakeHomeViewModel extends HomeViewModel {
  int fetchMonthlyDataCallCount = 0;
  DateTime? lastFetchedMonth;
  bool? lastForceRefresh;

  @override
  HomeState build() {
    final now = DateTime(2026, 2, 1);
    return HomeState(
      focusedMonth: now,
      selectedDate: now,
      monthlyData: const AsyncValue.data({}),
    );
  }

  @override
  Future<void> fetchMonthlyData(
    DateTime month, {
    bool forceRefresh = false,
    bool useCache = true,
  }) async {
    fetchMonthlyDataCallCount += 1;
    lastFetchedMonth = month;
    lastForceRefresh = forceRefresh;
  }
}

class _FakeBudgetRepository implements BudgetRepository {
  _FakeBudgetRepository({
    this.monthlyBudgetByKey = const {},
    this.failMonthlyBudgetKeys = const {},
    BudgetEntity? createOrUpdateResult,
  }) : createOrUpdateResult = createOrUpdateResult ??
            _budget(year: 2026, month: 2, targetAmount: 100000);

  final Map<String, BudgetEntity?> monthlyBudgetByKey;
  final Set<String> failMonthlyBudgetKeys;
  final BudgetEntity createOrUpdateResult;
  int createOrUpdateCallCount = 0;
  int getMonthlyBudgetCallCount = 0;
  int deleteCallCount = 0;

  String? lastDeletedBudgetId;
  final List<String> getMonthlyBudgetCalls = [];

  @override
  Future<BudgetEntity> createOrUpdateBudget({
    required String accountBookId,
    required int year,
    required int month,
    required double targetAmount,
  }) async {
    createOrUpdateCallCount += 1;
    return BudgetEntity(
      budgetId: createOrUpdateResult.budgetId,
      year: year,
      month: month,
      targetAmount: targetAmount,
      currentSpending: createOrUpdateResult.currentSpending,
      remainingAmount: targetAmount - createOrUpdateResult.currentSpending,
      usagePercentage: createOrUpdateResult.usagePercentage,
    );
  }

  @override
  Future<void> deleteBudget({required String budgetId}) async {
    deleteCallCount += 1;
    lastDeletedBudgetId = budgetId;
  }

  @override
  Future<BudgetEntity?> getMonthlyBudget({
    required int year,
    required int month,
    String? accountBookId,
  }) async {
    getMonthlyBudgetCallCount += 1;
    final key = buildBudgetMonthKey(DateTime(year, month));
    getMonthlyBudgetCalls.add(key);

    if (failMonthlyBudgetKeys.contains(key)) {
      throw Exception('fetch failed for $key');
    }

    return monthlyBudgetByKey[key];
  }

  @override
  Future<AssetEntity> getTotalAssets({String? accountBookId}) {
    throw UnimplementedError('not used');
  }

  @override
  Future<void> updateInitialBalance({
    required String accountBookId,
    required double initialBalance,
  }) {
    throw UnimplementedError('not used');
  }
}
