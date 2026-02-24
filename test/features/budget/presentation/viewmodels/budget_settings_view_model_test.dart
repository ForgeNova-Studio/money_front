import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/budget/domain/repositories/budget_repository.dart';
import 'package:moamoa/features/budget/data/providers/budget_data_providers.dart';
import 'package:moamoa/features/budget/presentation/constants/budget_error_messages.dart';
import 'package:moamoa/features/budget/presentation/states/budget_settings_state.dart';
import 'package:moamoa/features/budget/presentation/utils/budget_amount_utils.dart';
import 'package:moamoa/features/budget/presentation/viewmodels/budget_settings_view_model.dart';
import 'package:moamoa/features/home/presentation/states/home_state.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:moamoa/features/budget/domain/entities/asset_entity.dart';

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
        BudgetErrorMessages.selectedMonthBudgetLoadFailed,
      );
    });

    test('빠른 월 이동 시 마지막 월만 본조회한다 (디바운스)', () async {
      final fakeRepository = _FakeBudgetRepository(
        monthlyBudgetByKey: {
          '2026-01': _budget(year: 2026, month: 1, targetAmount: 100000),
          '2026-02': _budget(year: 2026, month: 2, targetAmount: 200000),
          '2026-03': _budget(year: 2026, month: 3, targetAmount: 300000),
          '2025-11': _budget(year: 2025, month: 11, targetAmount: 110000),
          '2025-10': _budget(year: 2025, month: 10, targetAmount: 100000),
        },
      );
      final container = _createContainer(fakeRepository);
      addTearDown(container.dispose);

      final notifier = container.read(budgetSettingsViewModelProvider.notifier);
      await notifier.initialize(DateTime(2026, 2, 1));
      fakeRepository.resetCalls();

      await notifier.changeMonth(-1);
      await notifier.changeMonth(-1);
      await notifier.changeMonth(-1);

      await Future<void>.delayed(const Duration(milliseconds: 80));
      expect(fakeRepository.getMonthlyBudgetCalls, isEmpty);

      await Future<void>.delayed(const Duration(milliseconds: 180));

      final state = container.read(budgetSettingsViewModelProvider);
      expect(state.selectedMonth, DateTime(2025, 11));
      expect(fakeRepository.getMonthlyBudgetCalls, contains('2025-11'));
      expect(fakeRepository.getMonthlyBudgetCalls, isNot(contains('2025-12')));
    });

    test('프리패치 요청과 본조회 요청이 겹치면 월별 요청을 1회로 dedupe한다', () async {
      final aprilCompleter = Completer<BudgetEntity?>();
      final fakeRepository = _FakeBudgetRepository(
        monthlyBudgetByKey: {
          '2026-01': _budget(year: 2026, month: 1, targetAmount: 100000),
          '2026-02': _budget(year: 2026, month: 2, targetAmount: 200000),
          '2026-03': _budget(year: 2026, month: 3, targetAmount: 300000),
        },
        monthlyBudgetCompleterByKey: {
          '2026-04': aprilCompleter,
        },
      );
      final container = _createContainer(fakeRepository);
      addTearDown(container.dispose);

      final notifier = container.read(budgetSettingsViewModelProvider.notifier);
      await notifier.initialize(DateTime(2026, 2, 1));
      fakeRepository.resetCalls();

      // 1) 3월 이동(캐시 hit) -> 방향 프리패치로 4월 요청 시작
      await notifier.changeMonth(1);
      await Future<void>.delayed(const Duration(milliseconds: 180));
      expect(fakeRepository.callCountOf('2026-04'), 1);

      // 2) 4월 이동(본조회)도 4월 요청이 필요하지만, in-flight dedupe로 추가 호출되지 않아야 한다.
      await notifier.changeMonth(1);
      await Future<void>.delayed(const Duration(milliseconds: 180));
      expect(fakeRepository.callCountOf('2026-04'), 1);

      aprilCompleter
          .complete(_budget(year: 2026, month: 4, targetAmount: 400000));
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      final state = container.read(budgetSettingsViewModelProvider);
      expect(state.selectedMonth, DateTime(2026, 4));
      expect(state.selectedBudget?.month, 4);
    });

    test('선택 월 본조회 실패 시 에러 이벤트를 발행한다', () async {
      final fakeRepository = _FakeBudgetRepository(
        monthlyBudgetByKey: {
          '2026-01': _budget(year: 2026, month: 1, targetAmount: 100000),
          '2026-02': _budget(year: 2026, month: 2, targetAmount: 200000),
          '2026-03': _budget(year: 2026, month: 3, targetAmount: 300000),
        },
        failMonthlyBudgetKeys: {'2026-04'},
      );
      final container = _createContainer(fakeRepository);
      addTearDown(container.dispose);

      final notifier = container.read(budgetSettingsViewModelProvider.notifier);
      await notifier.initialize(DateTime(2026, 2, 1));

      // 첫 이동은 취소시켜 3월 방향 프리패치(4월) 부작용을 방지한다.
      await notifier.changeMonth(1);
      await Future<void>.delayed(const Duration(milliseconds: 40));
      await notifier.changeMonth(1);
      await Future<void>.delayed(const Duration(milliseconds: 200));

      final state = container.read(budgetSettingsViewModelProvider);
      expect(state.selectedMonth, DateTime(2026, 4));
      expect(state.event, isA<BudgetSettingsShowError>());
      expect(
        (state.event as BudgetSettingsShowError).message,
        BudgetErrorMessages.selectedMonthBudgetLoadFailed,
      );
    });

    test('프리패치는 실패 시 1회 재시도한다', () async {
      final fakeRepository = _FakeBudgetRepository(
        monthlyBudgetByKey: {
          '2026-01': _budget(year: 2026, month: 1, targetAmount: 100000),
          '2026-02': _budget(year: 2026, month: 2, targetAmount: 200000),
          '2026-03': _budget(year: 2026, month: 3, targetAmount: 300000),
        },
        failCountByKey: {
          '2026-03': 1,
        },
      );
      final container = _createContainer(fakeRepository);
      addTearDown(container.dispose);

      final notifier = container.read(budgetSettingsViewModelProvider.notifier);
      await notifier.initialize(DateTime(2026, 2, 1));

      final state = container.read(budgetSettingsViewModelProvider);
      expect(state.event, isNull);
      expect(fakeRepository.callCountOf('2026-03'), 2);
      expect(state.budgetCache['2026-03'], isNotNull);
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
    this.monthlyBudgetCompleterByKey = const {},
    Map<String, int> failCountByKey = const {},
    BudgetEntity? createOrUpdateResult,
  })  : failCountByKey = Map<String, int>.from(failCountByKey),
        createOrUpdateResult = createOrUpdateResult ??
            _budget(year: 2026, month: 2, targetAmount: 100000);

  final Map<String, BudgetEntity?> monthlyBudgetByKey;
  final Set<String> failMonthlyBudgetKeys;
  final Map<String, Completer<BudgetEntity?>> monthlyBudgetCompleterByKey;
  final Map<String, int> failCountByKey;
  final BudgetEntity createOrUpdateResult;
  int createOrUpdateCallCount = 0;
  int getMonthlyBudgetCallCount = 0;
  int deleteCallCount = 0;

  String? lastDeletedBudgetId;
  final List<String> getMonthlyBudgetCalls = [];
  final Map<String, int> getMonthlyBudgetCallCountByKey = {};

  void resetCalls() {
    getMonthlyBudgetCallCount = 0;
    getMonthlyBudgetCalls.clear();
    getMonthlyBudgetCallCountByKey.clear();
  }

  int callCountOf(String key) {
    return getMonthlyBudgetCallCountByKey[key] ?? 0;
  }

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
    getMonthlyBudgetCallCountByKey[key] =
        (getMonthlyBudgetCallCountByKey[key] ?? 0) + 1;

    final completer = monthlyBudgetCompleterByKey[key];
    if (completer != null) {
      return completer.future;
    }

    final failRemaining = failCountByKey[key];
    if (failRemaining != null && failRemaining > 0) {
      failCountByKey[key] = failRemaining - 1;
      throw Exception('fetch failed once for $key');
    }

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
