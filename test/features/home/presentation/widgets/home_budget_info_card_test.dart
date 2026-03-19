import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:moamoa/features/home/presentation/states/home_state.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:moamoa/features/home/presentation/widgets/home_budget_info_card.dart';
import 'package:moamoa/router/route_names.dart';

void main() {
  testWidgets('예산 카드에서 설정 화면 복귀 시 focusedMonth 기준으로 강제 갱신한다', (tester) async {
    final container = ProviderContainer(
      overrides: [
        homeViewModelProvider.overrideWith(_FakeHomeViewModel.new),
      ],
    );
    addTearDown(container.dispose);

    final router = GoRouter(
      initialLocation: RouteNames.home,
      routes: [
        GoRoute(
          path: RouteNames.home,
          builder: (_, __) => const Scaffold(body: HomeBudgetInfoCard()),
        ),
        GoRoute(
          path: RouteNames.budgetSettings,
          builder: (_, __) => const Scaffold(
            body: Center(child: Text('BUDGET_SETTINGS_STUB')),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('2월 예산'), findsOneWidget);

    await tester.tap(find.text('2월 예산'));
    await tester.pumpAndSettle();
    expect(find.text('BUDGET_SETTINGS_STUB'), findsOneWidget);

    router.pop();
    await tester.pumpAndSettle();

    final fakeHome =
        container.read(homeViewModelProvider.notifier) as _FakeHomeViewModel;

    expect(fakeHome.fetchMonthlyDataCallCount, 1);
    expect(fakeHome.lastForceRefresh, true);
    expect(fakeHome.lastFetchedMonth, isNotNull);
    expect(fakeHome.lastFetchedMonth!.year, 2026);
    expect(fakeHome.lastFetchedMonth!.month, 2);
  });
}

class _FakeHomeViewModel extends HomeViewModel {
  int fetchMonthlyDataCallCount = 0;
  DateTime? lastFetchedMonth;
  bool? lastForceRefresh;

  @override
  HomeState build() {
    final focusedMonth = DateTime(2026, 2, 1);
    return HomeState(
      focusedMonth: focusedMonth,
      selectedDate: focusedMonth,
      monthlyData: const AsyncValue.data({}),
      budgetInfo: null,
      assetInfo: null,
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
