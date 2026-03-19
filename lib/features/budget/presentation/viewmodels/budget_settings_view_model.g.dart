// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_settings_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 예산 설정 화면 뷰모델
///
/// 사용자의 월간 예산을 설정하고 관리하기 위한 상태와 비즈니스 로직을 제공하는 Riverpod Notifier 기반의 뷰모델입니다.
/// 화면의 상태를 [BudgetSettingsState]로 관리하며, 예산 데이터의 조회, 캐싱, 저장, 삭제 등의 비동기 작업을 수행합니다.
///
/// **Key Features:**
/// *   현재 월 및 선택된 월의 예산 데이터 관리
/// *   빠른 탐색을 위한 인접 월 예산 백그라운드 프리페치(Prefetch)
/// *   월 변경 시 연속 요청 방지를 위한 디바운스(Debounce) 및 중복 요청 제어(Dedupe)
/// *   예산 신규 저장 및 기존 예산 수정, 삭제 처리
/// *   UI 피드백을 위한 토스트 메시지 및 에러 이벤트([BudgetSettingsEvent]) 발행
///
/// **Usage Example:**
/// ```dart
/// // UI 레이어에서 ViewModel의 상태를 구독하고 액션을 호출
/// final state = ref.watch(budgetSettingsViewModelProvider);
/// final viewModel = ref.read(budgetSettingsViewModelProvider.notifier);
///
/// // 월 변경 액션 호출
/// viewModel.changeMonth(1); // 다음 달로 이동
///
/// // 예산 저장 액션 호출
/// await viewModel.saveBudget(500000);
/// ```

@ProviderFor(BudgetSettingsViewModel)
const budgetSettingsViewModelProvider = BudgetSettingsViewModelProvider._();

/// 예산 설정 화면 뷰모델
///
/// 사용자의 월간 예산을 설정하고 관리하기 위한 상태와 비즈니스 로직을 제공하는 Riverpod Notifier 기반의 뷰모델입니다.
/// 화면의 상태를 [BudgetSettingsState]로 관리하며, 예산 데이터의 조회, 캐싱, 저장, 삭제 등의 비동기 작업을 수행합니다.
///
/// **Key Features:**
/// *   현재 월 및 선택된 월의 예산 데이터 관리
/// *   빠른 탐색을 위한 인접 월 예산 백그라운드 프리페치(Prefetch)
/// *   월 변경 시 연속 요청 방지를 위한 디바운스(Debounce) 및 중복 요청 제어(Dedupe)
/// *   예산 신규 저장 및 기존 예산 수정, 삭제 처리
/// *   UI 피드백을 위한 토스트 메시지 및 에러 이벤트([BudgetSettingsEvent]) 발행
///
/// **Usage Example:**
/// ```dart
/// // UI 레이어에서 ViewModel의 상태를 구독하고 액션을 호출
/// final state = ref.watch(budgetSettingsViewModelProvider);
/// final viewModel = ref.read(budgetSettingsViewModelProvider.notifier);
///
/// // 월 변경 액션 호출
/// viewModel.changeMonth(1); // 다음 달로 이동
///
/// // 예산 저장 액션 호출
/// await viewModel.saveBudget(500000);
/// ```
final class BudgetSettingsViewModelProvider
    extends $NotifierProvider<BudgetSettingsViewModel, BudgetSettingsState> {
  /// 예산 설정 화면 뷰모델
  ///
  /// 사용자의 월간 예산을 설정하고 관리하기 위한 상태와 비즈니스 로직을 제공하는 Riverpod Notifier 기반의 뷰모델입니다.
  /// 화면의 상태를 [BudgetSettingsState]로 관리하며, 예산 데이터의 조회, 캐싱, 저장, 삭제 등의 비동기 작업을 수행합니다.
  ///
  /// **Key Features:**
  /// *   현재 월 및 선택된 월의 예산 데이터 관리
  /// *   빠른 탐색을 위한 인접 월 예산 백그라운드 프리페치(Prefetch)
  /// *   월 변경 시 연속 요청 방지를 위한 디바운스(Debounce) 및 중복 요청 제어(Dedupe)
  /// *   예산 신규 저장 및 기존 예산 수정, 삭제 처리
  /// *   UI 피드백을 위한 토스트 메시지 및 에러 이벤트([BudgetSettingsEvent]) 발행
  ///
  /// **Usage Example:**
  /// ```dart
  /// // UI 레이어에서 ViewModel의 상태를 구독하고 액션을 호출
  /// final state = ref.watch(budgetSettingsViewModelProvider);
  /// final viewModel = ref.read(budgetSettingsViewModelProvider.notifier);
  ///
  /// // 월 변경 액션 호출
  /// viewModel.changeMonth(1); // 다음 달로 이동
  ///
  /// // 예산 저장 액션 호출
  /// await viewModel.saveBudget(500000);
  /// ```
  const BudgetSettingsViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'budgetSettingsViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$budgetSettingsViewModelHash();

  @$internal
  @override
  BudgetSettingsViewModel create() => BudgetSettingsViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BudgetSettingsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BudgetSettingsState>(value),
    );
  }
}

String _$budgetSettingsViewModelHash() =>
    r'c2b5a5c3ced988c4994e10346c7cbe5954309f0f';

/// 예산 설정 화면 뷰모델
///
/// 사용자의 월간 예산을 설정하고 관리하기 위한 상태와 비즈니스 로직을 제공하는 Riverpod Notifier 기반의 뷰모델입니다.
/// 화면의 상태를 [BudgetSettingsState]로 관리하며, 예산 데이터의 조회, 캐싱, 저장, 삭제 등의 비동기 작업을 수행합니다.
///
/// **Key Features:**
/// *   현재 월 및 선택된 월의 예산 데이터 관리
/// *   빠른 탐색을 위한 인접 월 예산 백그라운드 프리페치(Prefetch)
/// *   월 변경 시 연속 요청 방지를 위한 디바운스(Debounce) 및 중복 요청 제어(Dedupe)
/// *   예산 신규 저장 및 기존 예산 수정, 삭제 처리
/// *   UI 피드백을 위한 토스트 메시지 및 에러 이벤트([BudgetSettingsEvent]) 발행
///
/// **Usage Example:**
/// ```dart
/// // UI 레이어에서 ViewModel의 상태를 구독하고 액션을 호출
/// final state = ref.watch(budgetSettingsViewModelProvider);
/// final viewModel = ref.read(budgetSettingsViewModelProvider.notifier);
///
/// // 월 변경 액션 호출
/// viewModel.changeMonth(1); // 다음 달로 이동
///
/// // 예산 저장 액션 호출
/// await viewModel.saveBudget(500000);
/// ```

abstract class _$BudgetSettingsViewModel
    extends $Notifier<BudgetSettingsState> {
  BudgetSettingsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<BudgetSettingsState, BudgetSettingsState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<BudgetSettingsState, BudgetSettingsState>,
        BudgetSettingsState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
