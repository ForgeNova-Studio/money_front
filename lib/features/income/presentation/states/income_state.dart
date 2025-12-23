import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneyflow/features/income/domain/entities/income.dart';

part 'income_state.freezed.dart';

@freezed
sealed class IncomeState with _$IncomeState {
  const factory IncomeState({
    /// 수입 목록 (AsyncValue로 로딩/에러 상태 관리)
    @Default(AsyncValue.loading()) AsyncValue<List<Income>> incomes,

    /// 현재 보여지는 달력의 기준 날짜 (월 단위 조회를 위함)
    required DateTime focusedDay,

    /// 사용자가 선택한 특정 날짜 (null이면 해당 월 전체)
    DateTime? selectedDate,

    /// 총 수입 금액 (현재 조회된 목록 기준)
    @Default(0) double totalAmount,
  }) = _IncomeState;
}
