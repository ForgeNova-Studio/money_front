import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moamoa/features/expense/domain/entities/expense.dart';

part 'expense_state.freezed.dart';

@freezed
sealed class ExpenseState with _$ExpenseState {
  const factory ExpenseState({
    /// 지출 목록 (AsyncValue로 로딩/에러 상태 관리)
    @Default(AsyncValue.loading()) AsyncValue<List<Expense>> expenses,

    /// 현재 보여지는 달력의 기준 날짜 (월 단위 조회를 위함)
    required DateTime focusedDay,

    /// 사용자가 선택한 특정 날짜 (null이면 해당 월 전체)
    DateTime? selectedDate,

    /// 총 지출 금액 (현재 조회된 목록 기준)
    @Default(0) int totalAmount,
  }) = _ExpenseState;
}
