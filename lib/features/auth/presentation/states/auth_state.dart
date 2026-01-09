// packages
import 'package:freezed_annotation/freezed_annotation.dart';

// entities
import 'package:moneyflow/features/auth/domain/entities/user.dart';

part 'auth_state.freezed.dart';

/// Auth 상태 관리
///
/// - unauthenticated: 비로그인 상태
/// - authenticated: 로그인 상태 (user 보장)
/// - isLoading: 요청 진행 여부
/// - errorMessage: 에러 메시지
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
