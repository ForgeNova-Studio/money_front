import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/budget/data/providers/budget_data_providers.dart';
import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/budget/domain/repositories/budget_repository.dart';
import 'package:moamoa/features/budget/presentation/screens/budget_settings_screen.dart';
import 'package:moamoa/features/home/presentation/states/home_state.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';

void main() {
  group('BudgetSettingsScreen', () {
    testWidgets('초기 로딩 중에는 ProgressIndicator를 표시한다', (tester) async {
      final completer = Completer<BudgetEntity?>();
      final fakeRepository = _FakeBudgetRepository(
        getMonthlyBudgetCompleter: completer,
      );

      await _pumpBudgetSettingsScreen(
        tester,
        fakeRepository: fakeRepository,
        initialDate: DateTime(2026, 2, 1),
      );
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(null);
      await tester.pumpAndSettle();
    });

    testWidgets('로딩 완료 후 월 선택 영역과 저장 버튼을 표시한다', (tester) async {
      final fakeRepository = _FakeBudgetRepository(
        monthlyBudgetByKey: {
          '2026-01': null,
          '2026-02': null,
          '2026-03': null,
        },
      );

      await _pumpBudgetSettingsScreen(
        tester,
        fakeRepository: fakeRepository,
        initialDate: DateTime(2026, 2, 1),
      );
      await tester.pumpAndSettle();

      expect(find.text('2026년 2월'), findsOneWidget);
      expect(find.text('저장하기'), findsOneWidget);
      expect(find.text('이번 달 예산'), findsOneWidget);
    });

    testWidgets('저장 버튼 탭 시 예산 저장 후 이전 화면으로 복귀한다', (tester) async {
      final fakeRepository = _FakeBudgetRepository(
        monthlyBudgetByKey: {
          '2026-01': null,
          '2026-02': null,
          '2026-03': null,
        },
      );

      await _pumpBudgetSettingsScreen(
        tester,
        fakeRepository: fakeRepository,
        initialDate: DateTime(2026, 2, 1),
      );
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField), '500000');
      await tester.pump();
      await tester.tap(find.widgetWithText(ElevatedButton, '저장하기'));
      await tester.pumpAndSettle();

      expect(fakeRepository.createOrUpdateCallCount, 1);
      expect(fakeRepository.lastSavedTargetAmount, 500000);
      expect(find.text(_hostPageText), findsOneWidget);
    });

    testWidgets('삭제 버튼 탭 후 확인 시 예산 삭제 후 이전 화면으로 복귀한다', (tester) async {
      final fakeRepository = _FakeBudgetRepository(
        monthlyBudgetByKey: {
          '2026-01': null,
          '2026-02': _budget(year: 2026, month: 2, targetAmount: 300000),
          '2026-03': null,
        },
      );

      await _pumpBudgetSettingsScreen(
        tester,
        fakeRepository: fakeRepository,
        initialDate: DateTime(2026, 2, 1),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('이 달 예산 삭제'));
      await tester.pumpAndSettle();
      expect(find.text('예산 삭제'), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, '삭제'));
      await tester.pumpAndSettle();

      expect(fakeRepository.deleteCallCount, 1);
      expect(fakeRepository.lastDeletedBudgetId, 'budget-2026-2');
      expect(find.text(_hostPageText), findsOneWidget);
    });
  });
}

const _hostPageText = 'BUDGET_TEST_HOST';

Future<void> _pumpBudgetSettingsScreen(
  WidgetTester tester, {
  required _FakeBudgetRepository fakeRepository,
  DateTime? initialDate,
}) async {
  final router = GoRouter(
    initialLocation: '/host',
    routes: [
      GoRoute(
        path: '/host',
        builder: (_, __) => const Scaffold(
          body: Center(child: Text(_hostPageText)),
        ),
      ),
      GoRoute(
        path: '/budget',
        builder: (_, __) => BudgetSettingsScreen(initialDate: initialDate),
      ),
    ],
  );
  addTearDown(router.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        selectedAccountBookViewModelProvider.overrideWithValue(
          const AsyncValue.data('account-book-1'),
        ),
        budgetRepositoryProvider.overrideWithValue(fakeRepository),
        homeViewModelProvider.overrideWith(_FakeHomeViewModel.new),
      ],
      child: MaterialApp.router(routerConfig: router),
    ),
  );

  router.push('/budget');
  await tester.pump();
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
  }) async {}
}

class _FakeBudgetRepository implements BudgetRepository {
  _FakeBudgetRepository({
    this.monthlyBudgetByKey = const {},
    this.getMonthlyBudgetCompleter,
  });

  final Map<String, BudgetEntity?> monthlyBudgetByKey;
  final Completer<BudgetEntity?>? getMonthlyBudgetCompleter;
  int createOrUpdateCallCount = 0;
  double? lastSavedTargetAmount;
  int deleteCallCount = 0;
  String? lastDeletedBudgetId;

  @override
  Future<BudgetEntity?> getMonthlyBudget({
    required int year,
    required int month,
    String? accountBookId,
  }) async {
    if (getMonthlyBudgetCompleter != null) {
      return getMonthlyBudgetCompleter!.future;
    }

    final key =
        '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}';
    return monthlyBudgetByKey[key];
  }

  @override
  Future<BudgetEntity> createOrUpdateBudget({
    required String accountBookId,
    required int year,
    required int month,
    required double targetAmount,
  }) async {
    createOrUpdateCallCount += 1;
    lastSavedTargetAmount = targetAmount;

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

  @override
  Future<void> deleteBudget({required String budgetId}) async {
    deleteCallCount += 1;
    lastDeletedBudgetId = budgetId;
  }

  @override
  Future<AssetEntity> getTotalAssets({String? accountBookId}) async {
    return const AssetEntity(
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
  }

  @override
  Future<void> updateInitialBalance({
    required String accountBookId,
    required double initialBalance,
  }) async {}
}
