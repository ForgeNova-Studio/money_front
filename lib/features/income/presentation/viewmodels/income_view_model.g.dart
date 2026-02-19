// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'income_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 수입 기능의 비즈니스 로직을 관리하는 ViewModel
///
/// 수입 목록 조회, 상세 조회, 등록/수정을 처리하며,
/// 성공 시 [HomeViewModel] 데이터를 자동으로 갱신합니다.
///
/// **주요 기능:**
/// - 월간 수입 목록 조회 및 정렬 ([loadIncome])
/// - 수입 상세 조회 ([getIncomeDetail])
/// - 수입 등록/수정 통합 처리 ([submitIncome])
/// - 수입 생성 시 가계부 ID 자동 주입 ([createIncome])
///
/// **사용 예시:**
/// ```dart
/// // 목록 조회
/// ref.read(incomeViewModelProvider.notifier).loadIncome();
///
/// // 등록
/// ref.read(incomeViewModelProvider.notifier).submitIncome(
///   amount: 3000000,
///   date: DateTime.now(),
///   source: 'SALARY',
/// );
/// ```

@ProviderFor(IncomeViewModel)
const incomeViewModelProvider = IncomeViewModelProvider._();

/// 수입 기능의 비즈니스 로직을 관리하는 ViewModel
///
/// 수입 목록 조회, 상세 조회, 등록/수정을 처리하며,
/// 성공 시 [HomeViewModel] 데이터를 자동으로 갱신합니다.
///
/// **주요 기능:**
/// - 월간 수입 목록 조회 및 정렬 ([loadIncome])
/// - 수입 상세 조회 ([getIncomeDetail])
/// - 수입 등록/수정 통합 처리 ([submitIncome])
/// - 수입 생성 시 가계부 ID 자동 주입 ([createIncome])
///
/// **사용 예시:**
/// ```dart
/// // 목록 조회
/// ref.read(incomeViewModelProvider.notifier).loadIncome();
///
/// // 등록
/// ref.read(incomeViewModelProvider.notifier).submitIncome(
///   amount: 3000000,
///   date: DateTime.now(),
///   source: 'SALARY',
/// );
/// ```
final class IncomeViewModelProvider
    extends $NotifierProvider<IncomeViewModel, IncomeState> {
  /// 수입 기능의 비즈니스 로직을 관리하는 ViewModel
  ///
  /// 수입 목록 조회, 상세 조회, 등록/수정을 처리하며,
  /// 성공 시 [HomeViewModel] 데이터를 자동으로 갱신합니다.
  ///
  /// **주요 기능:**
  /// - 월간 수입 목록 조회 및 정렬 ([loadIncome])
  /// - 수입 상세 조회 ([getIncomeDetail])
  /// - 수입 등록/수정 통합 처리 ([submitIncome])
  /// - 수입 생성 시 가계부 ID 자동 주입 ([createIncome])
  ///
  /// **사용 예시:**
  /// ```dart
  /// // 목록 조회
  /// ref.read(incomeViewModelProvider.notifier).loadIncome();
  ///
  /// // 등록
  /// ref.read(incomeViewModelProvider.notifier).submitIncome(
  ///   amount: 3000000,
  ///   date: DateTime.now(),
  ///   source: 'SALARY',
  /// );
  /// ```
  const IncomeViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'incomeViewModelProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$incomeViewModelHash();

  @$internal
  @override
  IncomeViewModel create() => IncomeViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IncomeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IncomeState>(value),
    );
  }
}

String _$incomeViewModelHash() => r'92a3b34b0d2a0f153684ac60139d9fb17fa9bd22';

/// 수입 기능의 비즈니스 로직을 관리하는 ViewModel
///
/// 수입 목록 조회, 상세 조회, 등록/수정을 처리하며,
/// 성공 시 [HomeViewModel] 데이터를 자동으로 갱신합니다.
///
/// **주요 기능:**
/// - 월간 수입 목록 조회 및 정렬 ([loadIncome])
/// - 수입 상세 조회 ([getIncomeDetail])
/// - 수입 등록/수정 통합 처리 ([submitIncome])
/// - 수입 생성 시 가계부 ID 자동 주입 ([createIncome])
///
/// **사용 예시:**
/// ```dart
/// // 목록 조회
/// ref.read(incomeViewModelProvider.notifier).loadIncome();
///
/// // 등록
/// ref.read(incomeViewModelProvider.notifier).submitIncome(
///   amount: 3000000,
///   date: DateTime.now(),
///   source: 'SALARY',
/// );
/// ```

abstract class _$IncomeViewModel extends $Notifier<IncomeState> {
  IncomeState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<IncomeState, IncomeState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<IncomeState, IncomeState>, IncomeState, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
