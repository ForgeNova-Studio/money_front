import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/budget/domain/repositories/budget_repository.dart';
import 'package:moamoa/features/budget/data/providers/budget_data_providers.dart';
import 'package:moamoa/features/budget/presentation/constants/budget_error_messages.dart';
import 'package:moamoa/features/budget/presentation/states/initial_balance_settings_state.dart';
import 'package:moamoa/features/budget/presentation/viewmodels/initial_balance_settings_view_model.dart';
import 'package:moamoa/features/home/presentation/states/home_state.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:moamoa/features/budget/domain/entities/asset_entity.dart';

void main() {
  group('InitialBalanceSettingsViewModel', () {
    test('initialize 성공 시 현재 자산과 초기 잔액 입력값을 설정한다', () async {
      final fakeRepository = _FakeBudgetRepository(
        totalAssetsResult: const AssetEntity(
          accountBookId: 'account-book-1',
          accountBookName: '테스트 가계부',
          currentTotalAssets: 123456,
          initialBalance: -70000,
          totalIncome: 0,
          totalExpense: 0,
          periodIncome: 0,
          periodExpense: 0,
          periodNetIncome: 0,
        ),
      );
      final container = _createContainer(fakeRepository);
      addTearDown(container.dispose);

      final notifier =
          container.read(initialBalanceSettingsViewModelProvider.notifier);
      await notifier.initialize();

      final state = container.read(initialBalanceSettingsViewModelProvider);
      expect(state.isLoading, false);
      expect(state.currentTotalAssets, 123456);
      expect(state.isNegative, true);
      expect(state.initialAmount, 70000);
    });

    test('saveInitialBalance 성공 시 저장 후 PopWithToast 이벤트를 발행한다', () async {
      final fakeRepository = _FakeBudgetRepository(
        totalAssetsResult: const AssetEntity(
          accountBookId: 'account-book-1',
          accountBookName: '테스트 가계부',
          currentTotalAssets: 0,
          initialBalance: 0,
          totalIncome: 0,
          totalExpense: 0,
          periodIncome: 0,
          periodExpense: 0,
          periodNetIncome: 0,
        ),
      );
      final container = _createContainer(fakeRepository);
      addTearDown(container.dispose);

      final notifier =
          container.read(initialBalanceSettingsViewModelProvider.notifier);
      await notifier.initialize();
      notifier.setNegative(true);
      await notifier.saveInitialBalance(rawText: '123,400');

      final state = container.read(initialBalanceSettingsViewModelProvider);
      final fakeHome =
          container.read(homeViewModelProvider.notifier) as _FakeHomeViewModel;

      expect(fakeRepository.updateInitialBalanceCallCount, 1);
      expect(fakeRepository.lastUpdatedInitialBalance, -123400);
      expect(state.event, isA<InitialBalanceSettingsPopWithToast>());
      expect(fakeHome.refreshCallCount, 1);
    });

    test('초기 자산 로드 실패 시 사용자 에러 이벤트를 발행한다', () async {
      final fakeRepository = _FakeBudgetRepository(
        totalAssetsError: Exception('network fail'),
      );
      final container = _createContainer(fakeRepository);
      addTearDown(container.dispose);

      final notifier =
          container.read(initialBalanceSettingsViewModelProvider.notifier);
      await notifier.initialize();

      final state = container.read(initialBalanceSettingsViewModelProvider);
      expect(state.isLoading, false);
      expect(state.event, isA<InitialBalanceSettingsShowError>());
      expect(
        (state.event as InitialBalanceSettingsShowError).message,
        BudgetErrorMessages.initialBalanceLoadFailed,
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

  final screenSubscription = container.listen(
    initialBalanceSettingsViewModelProvider,
    (_, __) {},
  );
  final homeSubscription = container.listen(homeViewModelProvider, (_, __) {});

  addTearDown(screenSubscription.close);
  addTearDown(homeSubscription.close);

  return container;
}

class _FakeHomeViewModel extends HomeViewModel {
  int refreshCallCount = 0;

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
  Future<void> refresh() async {
    refreshCallCount += 1;
  }
}

class _FakeBudgetRepository implements BudgetRepository {
  _FakeBudgetRepository({
    AssetEntity? totalAssetsResult,
    this.totalAssetsError,
  }) : totalAssetsResult = totalAssetsResult ??
            const AssetEntity(
              accountBookId: 'account-book-1',
              accountBookName: '테스트 가계부',
              currentTotalAssets: 0,
              initialBalance: 0,
              totalIncome: 0,
              totalExpense: 0,
              periodIncome: 0,
              periodExpense: 0,
              periodNetIncome: 0,
            );

  final AssetEntity totalAssetsResult;
  final Object? totalAssetsError;

  int updateInitialBalanceCallCount = 0;
  double? lastUpdatedInitialBalance;

  @override
  Future<AssetEntity> getTotalAssets({String? accountBookId}) async {
    if (totalAssetsError != null) throw totalAssetsError!;
    return totalAssetsResult;
  }

  @override
  Future<void> updateInitialBalance({
    required String accountBookId,
    required double initialBalance,
  }) async {
    updateInitialBalanceCallCount += 1;
    lastUpdatedInitialBalance = initialBalance;
  }

  @override
  Future<BudgetEntity> createOrUpdateBudget({
    required String accountBookId,
    required int year,
    required int month,
    required double targetAmount,
  }) {
    throw UnimplementedError('not used');
  }

  @override
  Future<void> deleteBudget({required String budgetId}) {
    throw UnimplementedError('not used');
  }

  @override
  Future<BudgetEntity?> getMonthlyBudget({
    required int year,
    required int month,
    String? accountBookId,
  }) {
    throw UnimplementedError('not used');
  }
}
