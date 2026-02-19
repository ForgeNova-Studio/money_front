import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';

typedef MonthDateRange = ({
  DateTime startDate,
  DateTime endDate,
});

/// 특정 날짜가 속한 월의 시작일/종료일을 반환한다.
MonthDateRange buildMonthDateRange(DateTime focusedDay) {
  return (
    startDate: DateTime(focusedDay.year, focusedDay.month, 1),
    endDate: DateTime(focusedDay.year, focusedDay.month + 1, 0),
  );
}

/// 홈 화면의 월간 데이터/예산/자산을 트랜잭션 변경 직후 동기화한다.
void syncHomeAfterTransaction({
  required Ref ref,
  required DateTime date,
}) {
  final homeViewModel = ref.read(homeViewModelProvider.notifier);
  unawaited(homeViewModel.fetchMonthlyData(date, forceRefresh: true));
  homeViewModel.refreshBudgetAndAsset();
}

/// 리스트의 금액 필드를 누적 합산한다.
int sumAmounts<T>(
  Iterable<T> items,
  int Function(T item) amountSelector,
) {
  return items.fold(0, (sum, item) => sum + amountSelector(item));
}
