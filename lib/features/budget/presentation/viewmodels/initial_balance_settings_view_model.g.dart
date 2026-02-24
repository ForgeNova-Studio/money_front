// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'initial_balance_settings_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 초기 잔액 설정 화면 뷰모델
///
/// 사용자의 가계부 초기 잔액(자산의 시작 금액)을 설정하고 관리하기 위한 상태와 비즈니스 로직을 제공하는 Riverpod Notifier 기반의 뷰모델입니다.
/// 화면의 상태를 [InitialBalanceSettingsState]로 관리하며, 초기 잔액의 조회, 부호 변경, 저장 등의 작업을 수행합니다.
///
/// **Key Features:**
/// *   현재 가계부의 총 자산 및 설정된 초기 잔액 정보 로드
/// *   사용자 입력에 따른 초기 잔액 부호(양수/음수) 상태 관리
/// *   입력된 금액 파싱 및 가계부 초기 잔액 업데이트 처리
/// *   UI 피드백을 위한 토스트 메시지 및 에러 이벤트([InitialBalanceSettingsEvent]) 발행
///
/// **Usage Example:**
/// ```dart
/// // UI 레이어에서 ViewModel의 상태를 구독하고 액션을 호출
/// final state = ref.watch(initialBalanceSettingsViewModelProvider);
/// final viewModel = ref.read(initialBalanceSettingsViewModelProvider.notifier);
///
/// // 금액 부호 변경
/// viewModel.setNegative(true);
///
/// // 초기 잔액 저장 액션 호출
/// await viewModel.saveInitialBalance(rawText: '1,500,000');
/// ```

@ProviderFor(InitialBalanceSettingsViewModel)
const initialBalanceSettingsViewModelProvider =
    InitialBalanceSettingsViewModelProvider._();

/// 초기 잔액 설정 화면 뷰모델
///
/// 사용자의 가계부 초기 잔액(자산의 시작 금액)을 설정하고 관리하기 위한 상태와 비즈니스 로직을 제공하는 Riverpod Notifier 기반의 뷰모델입니다.
/// 화면의 상태를 [InitialBalanceSettingsState]로 관리하며, 초기 잔액의 조회, 부호 변경, 저장 등의 작업을 수행합니다.
///
/// **Key Features:**
/// *   현재 가계부의 총 자산 및 설정된 초기 잔액 정보 로드
/// *   사용자 입력에 따른 초기 잔액 부호(양수/음수) 상태 관리
/// *   입력된 금액 파싱 및 가계부 초기 잔액 업데이트 처리
/// *   UI 피드백을 위한 토스트 메시지 및 에러 이벤트([InitialBalanceSettingsEvent]) 발행
///
/// **Usage Example:**
/// ```dart
/// // UI 레이어에서 ViewModel의 상태를 구독하고 액션을 호출
/// final state = ref.watch(initialBalanceSettingsViewModelProvider);
/// final viewModel = ref.read(initialBalanceSettingsViewModelProvider.notifier);
///
/// // 금액 부호 변경
/// viewModel.setNegative(true);
///
/// // 초기 잔액 저장 액션 호출
/// await viewModel.saveInitialBalance(rawText: '1,500,000');
/// ```
final class InitialBalanceSettingsViewModelProvider extends $NotifierProvider<
    InitialBalanceSettingsViewModel, InitialBalanceSettingsState> {
  /// 초기 잔액 설정 화면 뷰모델
  ///
  /// 사용자의 가계부 초기 잔액(자산의 시작 금액)을 설정하고 관리하기 위한 상태와 비즈니스 로직을 제공하는 Riverpod Notifier 기반의 뷰모델입니다.
  /// 화면의 상태를 [InitialBalanceSettingsState]로 관리하며, 초기 잔액의 조회, 부호 변경, 저장 등의 작업을 수행합니다.
  ///
  /// **Key Features:**
  /// *   현재 가계부의 총 자산 및 설정된 초기 잔액 정보 로드
  /// *   사용자 입력에 따른 초기 잔액 부호(양수/음수) 상태 관리
  /// *   입력된 금액 파싱 및 가계부 초기 잔액 업데이트 처리
  /// *   UI 피드백을 위한 토스트 메시지 및 에러 이벤트([InitialBalanceSettingsEvent]) 발행
  ///
  /// **Usage Example:**
  /// ```dart
  /// // UI 레이어에서 ViewModel의 상태를 구독하고 액션을 호출
  /// final state = ref.watch(initialBalanceSettingsViewModelProvider);
  /// final viewModel = ref.read(initialBalanceSettingsViewModelProvider.notifier);
  ///
  /// // 금액 부호 변경
  /// viewModel.setNegative(true);
  ///
  /// // 초기 잔액 저장 액션 호출
  /// await viewModel.saveInitialBalance(rawText: '1,500,000');
  /// ```
  const InitialBalanceSettingsViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'initialBalanceSettingsViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$initialBalanceSettingsViewModelHash();

  @$internal
  @override
  InitialBalanceSettingsViewModel create() => InitialBalanceSettingsViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InitialBalanceSettingsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InitialBalanceSettingsState>(value),
    );
  }
}

String _$initialBalanceSettingsViewModelHash() =>
    r'4a2e2d5b847dfcced1855f39a2146b41e446d48f';

/// 초기 잔액 설정 화면 뷰모델
///
/// 사용자의 가계부 초기 잔액(자산의 시작 금액)을 설정하고 관리하기 위한 상태와 비즈니스 로직을 제공하는 Riverpod Notifier 기반의 뷰모델입니다.
/// 화면의 상태를 [InitialBalanceSettingsState]로 관리하며, 초기 잔액의 조회, 부호 변경, 저장 등의 작업을 수행합니다.
///
/// **Key Features:**
/// *   현재 가계부의 총 자산 및 설정된 초기 잔액 정보 로드
/// *   사용자 입력에 따른 초기 잔액 부호(양수/음수) 상태 관리
/// *   입력된 금액 파싱 및 가계부 초기 잔액 업데이트 처리
/// *   UI 피드백을 위한 토스트 메시지 및 에러 이벤트([InitialBalanceSettingsEvent]) 발행
///
/// **Usage Example:**
/// ```dart
/// // UI 레이어에서 ViewModel의 상태를 구독하고 액션을 호출
/// final state = ref.watch(initialBalanceSettingsViewModelProvider);
/// final viewModel = ref.read(initialBalanceSettingsViewModelProvider.notifier);
///
/// // 금액 부호 변경
/// viewModel.setNegative(true);
///
/// // 초기 잔액 저장 액션 호출
/// await viewModel.saveInitialBalance(rawText: '1,500,000');
/// ```

abstract class _$InitialBalanceSettingsViewModel
    extends $Notifier<InitialBalanceSettingsState> {
  InitialBalanceSettingsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref
        as $Ref<InitialBalanceSettingsState, InitialBalanceSettingsState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<InitialBalanceSettingsState, InitialBalanceSettingsState>,
        InitialBalanceSettingsState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
