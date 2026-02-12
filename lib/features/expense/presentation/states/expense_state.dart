import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moamoa/features/expense/domain/entities/expense.dart';

part 'expense_state.freezed.dart';

@freezed

/// 지출 상태 관리 클래스
///
/// 지출 목록, 현재 조회 중인 날짜, 선택된 날짜, 총 지출 금액 등
/// 지출 화면(ExpenseScreen)에서 필요한 모든 상태를 불변 객체로 관리합니다.
///
/// **주요 상태:**
/// - [expenses]: API로 조회된 지출 목록 (Loading/Error/Data 상태 포함)
/// - [focusedDay]: 캘린더/월별 조회 시 기준이 되는 날짜
/// - [selectedDate]: 사용자가 구체적으로 선택한 날짜 (필터링 용도)
/// - [totalAmount]: 조회된 목록의 총 합계 금액
///
/// **사용 예시:**
/// ```dart
/// // 상태 생성
/// state = ExpenseState(
///   focusedDay: DateTime.now(),
///   expenses: AsyncValue.data([]),
/// );
///
/// // 상태 업데이트
/// state = state.copyWith(
///   selectedDate: newDate,
///   totalAmount: 50000,
/// );
/// ```
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
