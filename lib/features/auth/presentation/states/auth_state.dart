import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneyflow/features/auth/domain/entities/user.dart';

part 'auth_state.freezed.dart';

/// Auth 상태 관리
///
/// - isLoading: 로딩 중 여부
/// - isAuthenticated: 인증 여부
/// - user: 현재 로그인한 사용자 정보
/// - errorMessage: 에러 메시지
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isLoading,
    @Default(false) bool isAuthenticated,
    User? user,
    String? errorMessage,
  }) = _AuthState;

  const AuthState._();

  /// 초기 상태
  factory AuthState.initial() => const AuthState();

  /// 로딩 상태
  factory AuthState.loading() => const AuthState(isLoading: true);

  /// 인증 성공 상태
  factory AuthState.authenticated(User user) => AuthState(
        isAuthenticated: true,
        user: user,
      );

  /// 인증 실패/로그아웃 상태
  factory AuthState.unauthenticated({String? errorMessage}) => AuthState(
        isAuthenticated: false,
        user: null,
        errorMessage: errorMessage,
      );

  /// 에러 상태
  factory AuthState.error(String message) => AuthState(
        errorMessage: message,
      );
}
