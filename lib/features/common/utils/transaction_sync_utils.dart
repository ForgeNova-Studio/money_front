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

/// 리스트의 금액 필드를 누적 합산한다.
int sumAmounts<T>(
  Iterable<T> items,
  int Function(T item) amountSelector,
) {
  return items.fold(0, (sum, item) => sum + amountSelector(item));
}
