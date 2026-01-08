// packages
import 'package:freezed_annotation/freezed_annotation.dart';

// entities
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
  /// 기본 생성자가 아닌 생성자로 AuthState 인스턴스 생성할 때,
  /// @Default 어노테이션을 사용하여 필드의 기본값을 설정
  /// 예) AuthState(errorMessage: e.message)로 인스턴스 생성할 때,
  /// errorMessage 필드만 명시적으로 전달하고,
  /// isLoading, isAuthenticated, user 필드는 @Default 어노테이션으로 자동으로 설정됨

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

  /// factory 생성자로 AuthState 인스턴스 생성
}
