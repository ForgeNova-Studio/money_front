// packages
import 'package:freezed_annotation/freezed_annotation.dart';

// entities
import 'package:moamoa/features/auth/domain/entities/user.dart';

part 'auth_state.freezed.dart';

/// 인증 상태 관리 클래스
///
/// 애플리케이션의 전역적인 인증 상태를 표현합니다.
/// `sealed class`와 `freezed`를 사용하여 상태를 불변 객체로 관리합니다.
///
/// **주요 상태 (States):**
/// - [AuthUnauthenticated]: 비로그인 상태. 기본 상태입니다.
/// - [AuthAuthenticated]: 로그인 성공 상태. 유효한 [User] 객체를 포함합니다.
///
/// **주요 속성 (Properties):**
/// - `isLoading`: 인증 요청(로그인, 회원가입 등) 진행 중 여부
/// - `errorMessage`: 인증 실패 시 반환된 에러 메시지
///
/// **사용 예시 (Usage Example):**
/// ```dart
/// ref.listen(authViewModelProvider, (previous, next) {
///   if (next.isAuthenticated) {
///     context.go(RouteNames.home);
///   }
/// });
/// ```
@freezed
sealed class AuthState with _$AuthState {
  /// 비로그인 상태
  const factory AuthState.unauthenticated({
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = AuthUnauthenticated;

  /// 로그인 상태 (user 필수)
  const factory AuthState.authenticated({
    required User user,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = AuthAuthenticated;

  const AuthState._();

  /// 초기 상태
  factory AuthState.initial() => const AuthState.unauthenticated();

  bool get isAuthenticated => this is AuthAuthenticated;

  User? get user => maybeMap(
        authenticated: (state) => state.user,
        orElse: () => null,
      );

  @override
  bool get isLoading => map(
        authenticated: (state) => state.isLoading,
        unauthenticated: (state) => state.isLoading,
      );

  @override
  String? get errorMessage => map(
        authenticated: (state) => state.errorMessage,
        unauthenticated: (state) => state.errorMessage,
      );
}
