import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/budget/domain/repositories/budget_repository.dart';
import 'package:moamoa/features/budget/data/providers/budget_data_providers.dart';
import 'package:moamoa/features/budget/presentation/screens/budget_settings_screen.dart';

void main() {
  group('BudgetSettingsScreen', () {
    testWidgets('초기 로딩 중에는 ProgressIndicator를 표시한다', (tester) async {
      final completer = Completer<BudgetEntity?>();
      final fakeRepository = _FakeBudgetRepository(
        getMonthlyBudgetCompleter: completer,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedAccountBookViewModelProvider.overrideWithValue(
              const AsyncValue.data('account-book-1'),
            ),
            budgetRepositoryProvider.overrideWithValue(fakeRepository),
          ],
          child: MaterialApp(
            home: BudgetSettingsScreen(initialDate: DateTime(2026, 2, 1)),
          ),
        ),
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

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            selectedAccountBookViewModelProvider.overrideWithValue(
              const AsyncValue.data('account-book-1'),
            ),
            budgetRepositoryProvider.overrideWithValue(fakeRepository),
          ],
          child: MaterialApp(
            home: BudgetSettingsScreen(initialDate: DateTime(2026, 2, 1)),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('2026년 2월'), findsOneWidget);
      expect(find.text('저장하기'), findsOneWidget);
      expect(find.text('이번 달 예산'), findsOneWidget);
    });
  });
}

class _FakeBudgetRepository implements BudgetRepository {
  _FakeBudgetRepository({
    this.monthlyBudgetByKey = const {},
    this.getMonthlyBudgetCompleter,
  });

  final Map<String, BudgetEntity?> monthlyBudgetByKey;
  final Completer<BudgetEntity?>? getMonthlyBudgetCompleter;

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
