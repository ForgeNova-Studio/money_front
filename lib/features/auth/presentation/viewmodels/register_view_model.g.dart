// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 회원가입 ViewModel
///
/// 회원가입 화면의 UI 상태 관리 및 데이터 처리를 담당합니다.
///
/// **주요 기능 (Key Features):**
/// - 입력 폼 상태 관리 (닉네임, 이메일, 비밀번호, 성별 등)
/// - 유효성 검사 (`validateForSignup`)
/// - 이메일 인증 (`sendVerificationCode`, `verifyCode`)
/// - 약관 동의 및 비밀번호 가시성 토글
/// - 약관 조회 (`loadTerms`)
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// final errorMessage = ref.read(registerViewModelProvider.notifier)
///     .validateForSignup(password: pw, confirmPassword: cp);
/// ```

@ProviderFor(RegisterViewModel)
const registerViewModelProvider = RegisterViewModelProvider._();

/// 회원가입 ViewModel
///
/// 회원가입 화면의 UI 상태 관리 및 데이터 처리를 담당합니다.
///
/// **주요 기능 (Key Features):**
/// - 입력 폼 상태 관리 (닉네임, 이메일, 비밀번호, 성별 등)
/// - 유효성 검사 (`validateForSignup`)
/// - 이메일 인증 (`sendVerificationCode`, `verifyCode`)
/// - 약관 동의 및 비밀번호 가시성 토글
/// - 약관 조회 (`loadTerms`)
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// final errorMessage = ref.read(registerViewModelProvider.notifier)
///     .validateForSignup(password: pw, confirmPassword: cp);
/// ```
final class RegisterViewModelProvider
    extends $NotifierProvider<RegisterViewModel, RegisterFormState> {
  /// 회원가입 ViewModel
  ///
  /// 회원가입 화면의 UI 상태 관리 및 데이터 처리를 담당합니다.
  ///
  /// **주요 기능 (Key Features):**
  /// - 입력 폼 상태 관리 (닉네임, 이메일, 비밀번호, 성별 등)
  /// - 유효성 검사 (`validateForSignup`)
  /// - 이메일 인증 (`sendVerificationCode`, `verifyCode`)
  /// - 약관 동의 및 비밀번호 가시성 토글
  /// - 약관 조회 (`loadTerms`)
  ///
  /// **사용 예시 (Usage Example):**
  /// ```dart
  /// final errorMessage = ref.read(registerViewModelProvider.notifier)
  ///     .validateForSignup(password: pw, confirmPassword: cp);
  /// ```
  const RegisterViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'registerViewModelProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$registerViewModelHash();

  @$internal
  @override
  RegisterViewModel create() => RegisterViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegisterFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegisterFormState>(value),
    );
  }
}

String _$registerViewModelHash() => r'7c23df5d0f858c22beca947e3293eb77cfef64ee';

/// 회원가입 ViewModel
///
/// 회원가입 화면의 UI 상태 관리 및 데이터 처리를 담당합니다.
///
/// **주요 기능 (Key Features):**
/// - 입력 폼 상태 관리 (닉네임, 이메일, 비밀번호, 성별 등)
/// - 유효성 검사 (`validateForSignup`)
/// - 이메일 인증 (`sendVerificationCode`, `verifyCode`)
/// - 약관 동의 및 비밀번호 가시성 토글
/// - 약관 조회 (`loadTerms`)
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// final errorMessage = ref.read(registerViewModelProvider.notifier)
///     .validateForSignup(password: pw, confirmPassword: cp);
/// ```

abstract class _$RegisterViewModel extends $Notifier<RegisterFormState> {
  RegisterFormState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<RegisterFormState, RegisterFormState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<RegisterFormState, RegisterFormState>,
        RegisterFormState,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
