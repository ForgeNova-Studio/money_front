// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Auth ViewModel
///
/// 애플리케이션의 핵심 인증 로직을 처리하는 ViewModel입니다.
/// 로그인, 회원가입, 로그아웃, 사용자 정보 관리 기능을 제공합니다.
///
/// **주요 기능 (Key Features):**
/// - 이메일/비밀번호 로그인 (`login`)
/// - 소셜 로그인 (Google, Naver, Kakao)
/// - 회원가입 및 이메일 인증 (`register`, `sendSignupCode`, `verifySignupCode`)
/// - 비밀번호 재설정 (`sendPasswordResetCode`, `resetPassword`)
/// - 자동 로그인 및 세션 관리 (`_checkCurrentUser`, `logout`)
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// await ref.read(authViewModelProvider.notifier).login(
///   email: 'user@example.com',
///   password: 'password123!',
/// );
/// ```

@ProviderFor(AuthViewModel)
const authViewModelProvider = AuthViewModelProvider._();

/// Auth ViewModel
///
/// 애플리케이션의 핵심 인증 로직을 처리하는 ViewModel입니다.
/// 로그인, 회원가입, 로그아웃, 사용자 정보 관리 기능을 제공합니다.
///
/// **주요 기능 (Key Features):**
/// - 이메일/비밀번호 로그인 (`login`)
/// - 소셜 로그인 (Google, Naver, Kakao)
/// - 회원가입 및 이메일 인증 (`register`, `sendSignupCode`, `verifySignupCode`)
/// - 비밀번호 재설정 (`sendPasswordResetCode`, `resetPassword`)
/// - 자동 로그인 및 세션 관리 (`_checkCurrentUser`, `logout`)
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// await ref.read(authViewModelProvider.notifier).login(
///   email: 'user@example.com',
///   password: 'password123!',
/// );
/// ```
final class AuthViewModelProvider
    extends $NotifierProvider<AuthViewModel, AuthState> {
  /// Auth ViewModel
  ///
  /// 애플리케이션의 핵심 인증 로직을 처리하는 ViewModel입니다.
  /// 로그인, 회원가입, 로그아웃, 사용자 정보 관리 기능을 제공합니다.
  ///
  /// **주요 기능 (Key Features):**
  /// - 이메일/비밀번호 로그인 (`login`)
  /// - 소셜 로그인 (Google, Naver, Kakao)
  /// - 회원가입 및 이메일 인증 (`register`, `sendSignupCode`, `verifySignupCode`)
  /// - 비밀번호 재설정 (`sendPasswordResetCode`, `resetPassword`)
  /// - 자동 로그인 및 세션 관리 (`_checkCurrentUser`, `logout`)
  ///
  /// **사용 예시 (Usage Example):**
  /// ```dart
  /// await ref.read(authViewModelProvider.notifier).login(
  ///   email: 'user@example.com',
  ///   password: 'password123!',
  /// );
  /// ```
  const AuthViewModelProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'authViewModelProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$authViewModelHash();

  @$internal
  @override
  AuthViewModel create() => AuthViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthState>(value),
    );
  }
}

String _$authViewModelHash() => r'0972b12a8415bd385b40637bed3d19d98cbd42f3';

/// Auth ViewModel
///
/// 애플리케이션의 핵심 인증 로직을 처리하는 ViewModel입니다.
/// 로그인, 회원가입, 로그아웃, 사용자 정보 관리 기능을 제공합니다.
///
/// **주요 기능 (Key Features):**
/// - 이메일/비밀번호 로그인 (`login`)
/// - 소셜 로그인 (Google, Naver, Kakao)
/// - 회원가입 및 이메일 인증 (`register`, `sendSignupCode`, `verifySignupCode`)
/// - 비밀번호 재설정 (`sendPasswordResetCode`, `resetPassword`)
/// - 자동 로그인 및 세션 관리 (`_checkCurrentUser`, `logout`)
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// await ref.read(authViewModelProvider.notifier).login(
///   email: 'user@example.com',
///   password: 'password123!',
/// );
/// ```

abstract class _$AuthViewModel extends $Notifier<AuthState> {
  AuthState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AuthState, AuthState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AuthState, AuthState>, AuthState, Object?, Object?>;
    element.handleValue(ref, created);
  }
}
