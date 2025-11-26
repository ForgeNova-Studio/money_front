import 'package:moneyflow/core/exceptions/exceptions.dart';
import 'package:moneyflow/features/auth/presentation/providers/auth_providers.dart';
import 'package:moneyflow/features/auth/presentation/states/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_view_model.g.dart';

/// Auth ViewModel
///
/// 인증 관련 비즈니스 로직 처리
/// - 로그인
/// - 회원가입
/// - 로그아웃
/// - 현재 사용자 정보 조회
@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  AuthState build() {
    // 초기화 시 현재 사용자 정보 확인
    _checkCurrentUser();
    return AuthState.initial();
  }

  /// 현재 사용자 정보 확인
  Future<void> _checkCurrentUser() async {
    try {
      final useCase = ref.read(getCurrentUserUseCaseProvider);
      final user = await useCase();

      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = AuthState.unauthenticated();
      }
    } catch (e) {
      // 에러 발생 시 로그아웃 상태로 처리
      state = AuthState.unauthenticated();
    }
  }

  /// 로그인
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = AuthState.loading();

    try {
      final useCase = ref.read(loginUseCaseProvider);
      final result = await useCase(email: email, password: password);

      state = AuthState.authenticated(result.user);
    } on ValidationException catch (e) {
      state = AuthState.error(e.message);
      rethrow;
    } on UnauthorizedException catch (e) {
      state = AuthState.error(e.message);
      rethrow;
    } on NetworkException catch (e) {
      state = AuthState.error(e.message);
      rethrow;
    } on ServerException catch (e) {
      state = AuthState.error(e.message);
      rethrow;
    } catch (e) {
      state = AuthState.error('로그인 중 오류가 발생했습니다: $e');
      rethrow;
    }
  }

  /// 회원가입
  Future<void> register({
    required String email,
    required String password,
    required String nickname,
  }) async {
    state = AuthState.loading();

    try {
      final useCase = ref.read(registerUseCaseProvider);
      final result = await useCase(
        email: email,
        password: password,
        nickname: nickname,
      );

      state = AuthState.authenticated(result.user);
    } on ValidationException catch (e) {
      state = AuthState.error(e.message);
      rethrow;
    } on NetworkException catch (e) {
      state = AuthState.error(e.message);
      rethrow;
    } on ServerException catch (e) {
      state = AuthState.error(e.message);
      rethrow;
    } catch (e) {
      state = AuthState.error('회원가입 중 오류가 발생했습니다: $e');
      rethrow;
    }
  }

  /// 로그아웃
  Future<void> logout() async {
    try {
      final useCase = ref.read(logoutUseCaseProvider);
      await useCase();

      state = AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error('로그아웃 중 오류가 발생했습니다: $e');
      rethrow;
    }
  }

  /// 에러 메시지 초기화
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// 현재 사용자 정보 새로고침
  Future<void> refreshUser() async {
    try {
      final useCase = ref.read(getCurrentUserUseCaseProvider);
      final user = await useCase();

      if (user != null) {
        state = state.copyWith(user: user, isAuthenticated: true);
      } else {
        state = AuthState.unauthenticated();
      }
    } catch (e) {
      // 에러 발생 시 현재 상태 유지
    }
  }
}
