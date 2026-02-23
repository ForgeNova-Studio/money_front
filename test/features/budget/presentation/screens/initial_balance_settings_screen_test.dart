import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/budget/domain/repositories/budget_repository.dart';
import 'package:moamoa/features/budget/data/providers/budget_data_providers.dart';
import 'package:moamoa/features/budget/presentation/screens/initial_balance_settings_screen.dart';

void main() {
  group('InitialBalanceSettingsScreen', () {
    testWidgets('초기 로딩 중에는 ProgressIndicator를 표시한다', (tester) async {
      final completer = Completer<AssetEntity>();
      final fakeRepository = _FakeBudgetRepository(
        getTotalAssetsCompleter: completer,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedAccountBookViewModelProvider.overrideWithValue(
              const AsyncValue.data('account-book-1'),
            ),
            budgetRepositoryProvider.overrideWithValue(fakeRepository),
          ],
          child: const MaterialApp(
            home: InitialBalanceSettingsScreen(),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(_defaultAsset);
      await tester.pumpAndSettle();
    });

    testWidgets('로딩 완료 후 현재 총 자산과 저장 버튼을 표시한다', (tester) async {
      final fakeRepository =
          _FakeBudgetRepository(totalAssetsResult: _defaultAsset);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedAccountBookViewModelProvider.overrideWithValue(
              const AsyncValue.data('account-book-1'),
            ),
            budgetRepositoryProvider.overrideWithValue(fakeRepository),
          ],
          child: const MaterialApp(
            home: InitialBalanceSettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('현재 총 자산'), findsOneWidget);
      expect(find.text('123,456원'), findsOneWidget);
      expect(find.text('저장하기'), findsOneWidget);
    });
  });
}

const _defaultAsset = AssetEntity(
  accountBookId: 'account-book-1',
  accountBookName: '테스트 가계부',
  currentTotalAssets: 123456,
  initialBalance: 10000,
  totalIncome: 0,
  totalExpense: 0,
  periodIncome: 0,
  periodExpense: 0,
  periodNetIncome: 0,
);

class _FakeBudgetRepository implements BudgetRepository {
  _FakeBudgetRepository({
    this.totalAssetsResult = _defaultAsset,
    this.getTotalAssetsCompleter,
  });

  final AssetEntity totalAssetsResult;
  final Completer<AssetEntity>? getTotalAssetsCompleter;

  @override
  Future<AssetEntity> getTotalAssets({String? accountBookId}) async {
    if (getTotalAssetsCompleter != null) {
      return getTotalAssetsCompleter!.future;
    }
    return totalAssetsResult;
  }

  @override
  Future<BudgetEntity> createOrUpdateBudget({
    required String accountBookId,
    required int year,
    required int month,
    required double targetAmount,
  }) async {
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
  Future<void> deleteBudget({required String budgetId}) async {}

  @override
  Future<BudgetEntity?> getMonthlyBudget({
    required int year,
    required int month,
    String? accountBookId,
  }) async {
    return null;
  }

  @override
  Future<void> updateInitialBalance({
    required String accountBookId,
    required double initialBalance,
  }) async {}
}
