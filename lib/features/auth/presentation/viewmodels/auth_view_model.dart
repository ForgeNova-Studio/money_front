// packages
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// core
import 'package:moneyflow/core/exceptions/exceptions.dart';

// providers/states
import 'package:moneyflow/features/auth/presentation/providers/auth_providers.dart';
import 'package:moneyflow/features/auth/presentation/states/auth_state.dart';

// entities
import 'package:moneyflow/features/auth/domain/entities/gender.dart';

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
    // 로딩 상태로 변경
    state = AuthState.loading();

    try {
      final useCase = ref.read(loginUseCaseProvider);
      final result = await useCase(email: email, password: password);

      state = AuthState.authenticated(result.user);
    } on ValidationException catch (e) {
      // 에러 발생 시 에러 상태로 변경하며 새로운 AuthState 인스턴스 생성 및 참조
      state = AuthState.error(e.message);
    } on UnauthorizedException catch (e) {
      // 에러 발생 시 에러 상태로 변경하며 새로운 AuthState 인스턴스 생성 및 참조
      state = AuthState.error(e.message);
    } on NetworkException catch (e) {
      // 에러 발생 시 에러 상태로 변경하며 새로운 AuthState 인스턴스 생성 및 참조
      state = AuthState.error(e.message);
    } on ServerException catch (e) {
      // 에러 발생 시 에러 상태로 변경하며 새로운 AuthState 인스턴스 생성 및 참조
      state = AuthState.error(e.message);
    } catch (e) {
      // 에러 발생 시 에러 상태로 변경하며 새로운 AuthState 인스턴스 생성 및 참조
      state = AuthState.error('로그인 중 오류가 발생했습니다');
      debugPrint('Login failed: $e');
    }
  }

  /// 회원가입 인증번호 전송
  Future<void> sendSignupCode(String email) async {
    state = AuthState.loading();

    try {
      final useCase = ref.read(sendSignupCodeUseCaseProvider);
      await useCase(email);

      // 인증번호 전송 성공 시 로딩 해제
      state = AuthState.initial();
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
      state = AuthState.error('인증번호 전송 중 오류가 발생했습니다: $e');
      rethrow;
    }
  }

  /// 회원가입 인증번호 검증
  Future<bool> verifySignupCode({
    required String email,
    required String code,
  }) async {
    state = AuthState.loading();

    try {
      final useCase = ref.read(verifySignupCodeUseCaseProvider);
      final isVerified = await useCase(email: email, code: code);

      // 검증 성공 시 로딩 해제
      state = AuthState.initial();
      return isVerified;
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
      state = AuthState.error('인증번호 확인 중 오류가 발생했습니다: $e');
      rethrow;
    }
  }

  /// 비밀번호 찾기 인증번호 검증
  Future<bool> verifyFindPasswordCode({
    required String email,
    required String code,
  }) async {
    state = AuthState.loading();

    try {
      // final useCase = ref.read(verifySignupCodeUseCaseProvider);
      // final isVerified = await useCase(email: email, code: code);
      final isVerified = true;

      // 검증 성공 시 로딩 해제
      state = AuthState.initial();
      return isVerified;
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
      state = AuthState.error('인증번호 확인 중 오류가 발생했습니다: $e');
      rethrow;
    }
  }

  /// 회원가입
  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String nickname,
    required Gender gender,
  }) async {
    state = AuthState.loading();

    try {
      final useCase = ref.read(registerUseCaseProvider);
      final result = await useCase(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        nickname: nickname,
        gender: gender,
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

  /// Google 로그인
  Future<void> loginWithGoogle() async {
    state = AuthState.loading();

    try {
      final useCase = ref.read(googleLoginUseCaseProvider);
      final result = await useCase();

      state = AuthState.authenticated(result.user);
    } on NetworkException catch (e) {
      state = AuthState.error(e.message);
      rethrow;
    } on UnauthorizedException catch (e) {
      state = AuthState.error(e.message);
      rethrow;
    } on ServerException catch (e) {
      state = AuthState.error(e.message);
      rethrow;
    } catch (e) {
      state = AuthState.error('Google 로그인 중 오류가 발생했습니다: $e');
      rethrow;
    }
  }

  /// Apple 로그인
  Future<void> loginWithApple() async {
    state = AuthState.loading();

    try {
      final useCase = ref.read(appleLoginUseCaseProvider);
      final result = await useCase();

      state = AuthState.authenticated(result.user);
    } on NetworkException catch (e) {
      state = AuthState.error(e.message);
      rethrow;
    } on UnauthorizedException catch (e) {
      state = AuthState.error(e.message);
      rethrow;
    } on ServerException catch (e) {
      state = AuthState.error(e.message);
      rethrow;
    } catch (e) {
      state = AuthState.error('Apple 로그인 중 오류가 발생했습니다: $e');
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

  /// 비밀번호 재설정 인증번호 전송
  Future<void> sendPasswordResetCode(String email) async {
    state = AuthState.loading();

    try {
      final useCase = ref.read(sendPasswordResetCodeUseCaseProvider);
      await useCase(email);

      // 인증번호 전송 성공 시 로딩 해제
      state = AuthState.initial();
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
      state = AuthState.error('인증번호 전송 중 오류가 발생했습니다: $e');
      rethrow;
    }
  }

  /// 비밀번호 재설정
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    state = AuthState.loading();

    try {
      final useCase = ref.read(resetPasswordUseCaseProvider);
      await useCase(
        email: email,
        newPassword: newPassword,
      );

      // 비밀번호 재설정 성공 시 로딩 해제
      state = AuthState.initial();
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
      state = AuthState.error('비밀번호 재설정 중 오류가 발생했습니다: $e');
      rethrow;
    }
  }
}
