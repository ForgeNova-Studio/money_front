// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_password_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 비밀번호 찾기 ViewModel
///
/// 비밀번호 재설정을 위한 이메일 인증 프로세스를 관리합니다.
///
/// **주요 기능 (Key Features):**
/// - 이메일 주소 입력 및 관리
/// - 인증번호 전송 요청 (`sendVerificationCode`)
/// - 인증번호 검증 요청 (`verifyCode`)
/// - 상태 초기화 (`reset`)
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// await ref.read(findPasswordViewModelProvider.notifier).sendVerificationCode(email);
/// ```

@ProviderFor(FindPasswordViewModel)
const findPasswordViewModelProvider = FindPasswordViewModelProvider._();

/// 비밀번호 찾기 ViewModel
///
/// 비밀번호 재설정을 위한 이메일 인증 프로세스를 관리합니다.
///
/// **주요 기능 (Key Features):**
/// - 이메일 주소 입력 및 관리
/// - 인증번호 전송 요청 (`sendVerificationCode`)
/// - 인증번호 검증 요청 (`verifyCode`)
/// - 상태 초기화 (`reset`)
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// await ref.read(findPasswordViewModelProvider.notifier).sendVerificationCode(email);
/// ```
final class FindPasswordViewModelProvider
    extends $NotifierProvider<FindPasswordViewModel, FindPasswordFormState> {
  /// 비밀번호 찾기 ViewModel
  ///
  /// 비밀번호 재설정을 위한 이메일 인증 프로세스를 관리합니다.
  ///
  /// **주요 기능 (Key Features):**
  /// - 이메일 주소 입력 및 관리
  /// - 인증번호 전송 요청 (`sendVerificationCode`)
  /// - 인증번호 검증 요청 (`verifyCode`)
  /// - 상태 초기화 (`reset`)
  ///
  /// **사용 예시 (Usage Example):**
  /// ```dart
  /// await ref.read(findPasswordViewModelProvider.notifier).sendVerificationCode(email);
  /// ```
  const FindPasswordViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'findPasswordViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$findPasswordViewModelHash();

  @$internal
  @override
  FindPasswordViewModel create() => FindPasswordViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FindPasswordFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FindPasswordFormState>(value),
    );
  }
}

String _$findPasswordViewModelHash() =>
    r'8d257dfe254b2bd7784f0347543df07127524c03';

/// 비밀번호 찾기 ViewModel
///
/// 비밀번호 재설정을 위한 이메일 인증 프로세스를 관리합니다.
///
/// **주요 기능 (Key Features):**
/// - 이메일 주소 입력 및 관리
/// - 인증번호 전송 요청 (`sendVerificationCode`)
/// - 인증번호 검증 요청 (`verifyCode`)
/// - 상태 초기화 (`reset`)
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// await ref.read(findPasswordViewModelProvider.notifier).sendVerificationCode(email);
/// ```

abstract class _$FindPasswordViewModel
    extends $Notifier<FindPasswordFormState> {
  FindPasswordFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<FindPasswordFormState, FindPasswordFormState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<FindPasswordFormState, FindPasswordFormState>,
        FindPasswordFormState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
