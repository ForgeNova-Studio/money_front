// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 지출 기능의 비즈니스 로직을 관리하는 ViewModel
///
/// 지출 목록 조회, 상세 조회, 등록, 수정을 처리하며,
/// 성공 시 [HomeViewModel] 데이터를 자동으로 갱신합니다.
///
/// **주요 기능:**
/// - 월간 지출 목록 조회 및 정렬 ([loadExpenses])
/// - 지출 상세 조회 ([getExpenseDetail])
/// - 지출 등록/수정 통합 처리 ([submitExpense])
/// - 지출 생성 시 가계부 ID 자동 주입 ([createExpense])
///
/// **사용 예시:**
/// ```dart
/// // 목록 조회
/// ref.read(expenseViewModelProvider.notifier).loadExpenses();
///
/// // 등록
/// ref.read(expenseViewModelProvider.notifier).submitExpense(
///   amount: 15000,
///   date: DateTime.now(),
///   category: 'FOOD',
///   paymentMethod: 'CARD',
/// );
/// ```

@ProviderFor(ExpenseViewModel)
const expenseViewModelProvider = ExpenseViewModelProvider._();

/// 지출 기능의 비즈니스 로직을 관리하는 ViewModel
///
/// 지출 목록 조회, 상세 조회, 등록, 수정을 처리하며,
/// 성공 시 [HomeViewModel] 데이터를 자동으로 갱신합니다.
///
/// **주요 기능:**
/// - 월간 지출 목록 조회 및 정렬 ([loadExpenses])
/// - 지출 상세 조회 ([getExpenseDetail])
/// - 지출 등록/수정 통합 처리 ([submitExpense])
/// - 지출 생성 시 가계부 ID 자동 주입 ([createExpense])
///
/// **사용 예시:**
/// ```dart
/// // 목록 조회
/// ref.read(expenseViewModelProvider.notifier).loadExpenses();
///
/// // 등록
/// ref.read(expenseViewModelProvider.notifier).submitExpense(
///   amount: 15000,
///   date: DateTime.now(),
///   category: 'FOOD',
///   paymentMethod: 'CARD',
/// );
/// ```
final class ExpenseViewModelProvider
    extends $NotifierProvider<ExpenseViewModel, ExpenseState> {
  /// 지출 기능의 비즈니스 로직을 관리하는 ViewModel
  ///
  /// 지출 목록 조회, 상세 조회, 등록, 수정을 처리하며,
  /// 성공 시 [HomeViewModel] 데이터를 자동으로 갱신합니다.
  ///
  /// **주요 기능:**
  /// - 월간 지출 목록 조회 및 정렬 ([loadExpenses])
  /// - 지출 상세 조회 ([getExpenseDetail])
  /// - 지출 등록/수정 통합 처리 ([submitExpense])
  /// - 지출 생성 시 가계부 ID 자동 주입 ([createExpense])
  ///
  /// **사용 예시:**
  /// ```dart
  /// // 목록 조회
  /// ref.read(expenseViewModelProvider.notifier).loadExpenses();
  ///
  /// // 등록
  /// ref.read(expenseViewModelProvider.notifier).submitExpense(
  ///   amount: 15000,
  ///   date: DateTime.now(),
  ///   category: 'FOOD',
  ///   paymentMethod: 'CARD',
  /// );
  /// ```
  const ExpenseViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'expenseViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$expenseViewModelHash();

  @$internal
  @override
  ExpenseViewModel create() => ExpenseViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExpenseState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExpenseState>(value),
    );
  }
}

String _$expenseViewModelHash() => r'a5bd807f9d92276b22435f0c3ade27b531171437';

/// 지출 기능의 비즈니스 로직을 관리하는 ViewModel
///
/// 지출 목록 조회, 상세 조회, 등록, 수정을 처리하며,
/// 성공 시 [HomeViewModel] 데이터를 자동으로 갱신합니다.
///
/// **주요 기능:**
/// - 월간 지출 목록 조회 및 정렬 ([loadExpenses])
/// - 지출 상세 조회 ([getExpenseDetail])
/// - 지출 등록/수정 통합 처리 ([submitExpense])
/// - 지출 생성 시 가계부 ID 자동 주입 ([createExpense])
///
/// **사용 예시:**
/// ```dart
/// // 목록 조회
/// ref.read(expenseViewModelProvider.notifier).loadExpenses();
///
/// // 등록
/// ref.read(expenseViewModelProvider.notifier).submitExpense(
///   amount: 15000,
///   date: DateTime.now(),
///   category: 'FOOD',
///   paymentMethod: 'CARD',
/// );
/// ```

abstract class _$ExpenseViewModel extends $Notifier<ExpenseState> {
  ExpenseState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ExpenseState, ExpenseState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<ExpenseState, ExpenseState>,
        ExpenseState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
