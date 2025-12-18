// packages
import 'dart:async';
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
  // 초기화 완료를 알리기 위한 Completer
  final _initCompleter = Completer<void>();

  // 외부에서 초기화 완료를 기다릴 수 있도록 Future 제공
  Future<void> get isInitialized => _initCompleter.future;

  @override
  AuthState build() {
    // 초기화 시 로딩 상태로 시작
    // Future.microtask를 사용하여 비동기 초기화 실행
    Future.microtask(() async {
      await _checkCurrentUser();
      if (!_initCompleter.isCompleted) _initCompleter.complete();
    });
    return AuthState.loading();
  }

  /// 현재 사용자 정보 확인 (로컬 토큰 기반)
  ///
  /// 앱 시작 시 로컬 저장소의 토큰과 사용자 정보를 확인하여
  /// 빠른 초기화를 제공합니다.
  /// - 토큰이 있으면: authenticated 상태로 변경
  /// - 토큰이 없으면: unauthenticated 상태로 변경
  Future<void> _checkCurrentUser() async {
    try {
      debugPrint('[AuthViewModel] 토큰 확인 시작');
      // 로컬 저장소에서 토큰 확인 (원격 API 호출 없이)
      final localDataSource = ref.read(authLocalDataSourceProvider);
      final hasToken = await localDataSource.hasToken();

      debugPrint('[AuthViewModel] 토큰 존재 여부: $hasToken');

      if (hasToken) {
        // 토큰이 있으면 로컬 사용자 정보 불러오기
        final user = await localDataSource.getUser();
        debugPrint('[AuthViewModel] 사용자 정보: ${user?.email}');

        if (!ref.mounted) return; // Provider가 해제되었으면 작업 중단

        if (user != null) {
          state = AuthState.authenticated(user.toEntity());
          debugPrint('[AuthViewModel] 인증된 상태로 변경됨');
        } else {
          // 토큰은 있지만 사용자 정보가 없는 경우 (비정상 상태)
          state = AuthState.unauthenticated();
          debugPrint('[AuthViewModel] 사용자 정보 없음 - 미인증 상태로 변경');
        }
      } else {
        if (!ref.mounted) return; // Provider가 해제되었으면 작업 중단
        // 토큰이 없으면 로그아웃 상태
        state = AuthState.unauthenticated();
        debugPrint('[AuthViewModel] 토큰 없음 - 미인증 상태로 변경');
      }
    } catch (e) {
      // 에러 발생 시 로그아웃 상태로 처리
      if (!ref.mounted) return; // Provider가 해제되었으면 작업 중단
      debugPrint('[AuthViewModel] 에러 발생: $e');
      state = AuthState.unauthenticated();
    } finally {
      // 어떤 경우에도 초기화가 완료되었음을 보장
      if (!_initCompleter.isCompleted) _initCompleter.complete();
    }
  }

  /// 로그인
  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _handleAuthRequest(() async {
      final useCase = ref.read(loginUseCaseProvider);
      final result = await useCase(email: email, password: password);
      state = AuthState.authenticated(result.user);
    }, loading: true, defaultErrorMessage: '로그인 중 오류가 발생했습니다');
  }

  /// 회원가입 인증번호 전송
  Future<void> sendSignupCode(String email) async {
    state = AuthState.loading();

    await _handleAuthRequest(() async {
      final useCase = ref.read(sendSignupCodeUseCaseProvider);
      await useCase(email);
      state = AuthState.initial();
    }, rethrowError: true, defaultErrorMessage: '인증번호 전송 중 오류가 발생했습니다');
  }

  /// 회원가입 인증번호 검증
  Future<bool> verifySignupCode({
    required String email,
    required String code,
  }) async {
    state = AuthState.loading();

    return _handleAuthRequest(() async {
      final useCase = ref.read(verifySignupCodeUseCaseProvider);
      state = AuthState.initial();
      return await useCase(email: email, code: code);
    }, rethrowError: true, defaultErrorMessage: '인증번호 확인 중 오류가 발생했습니다');
  }

  /// 비밀번호 찾기 인증번호 검증
  Future<bool> verifyFindPasswordCode({
    required String email,
    required String code,
  }) async {
    state = AuthState.loading();

    return _handleAuthRequest(() async {
      final useCase = ref.read(verifyFindPasswordCodeUseCaseProvider);
      state = AuthState.initial();
      return await useCase(email: email, code: code);
    }, rethrowError: true, defaultErrorMessage: '인증번호 확인 중 오류가 발생했습니다');
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

    await _handleAuthRequest(() async {
      final useCase = ref.read(registerUseCaseProvider);
      final result = await useCase(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        nickname: nickname,
        gender: gender,
      );
      state = AuthState.authenticated(result.user);
    }, rethrowError: true, defaultErrorMessage: '회원가입 중 오류가 발생했습니다');
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
    await _handleAuthRequest(() async {
      final useCase = ref.read(googleLoginUseCaseProvider);
      final result = await useCase();
      state = AuthState.authenticated(result.user);
    }, rethrowError: true, defaultErrorMessage: 'Google 로그인 중 오류가 발생했습니다');
  }

  /// Apple 로그인
  Future<void> loginWithApple() async {
    await _handleAuthRequest(() async {
      final useCase = ref.read(appleLoginUseCaseProvider);
      final result = await useCase();
      state = AuthState.authenticated(result.user);
    }, rethrowError: true, defaultErrorMessage: 'Apple 로그인 중 오류가 발생했습니다');
  }

  /// 에러 메시지 초기화
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// 강제로 unauthenticated 상태로 변경
  /// (401 에러 발생 시 Interceptor에서 호출)
  void forceUnauthenticated({String? errorMessage}) {
    state = AuthState.unauthenticated(errorMessage: errorMessage);
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

    await _handleAuthRequest(() async {
      final useCase = ref.read(sendPasswordResetCodeUseCaseProvider);
      await useCase(email);
      state = AuthState.initial();
    }, rethrowError: true, defaultErrorMessage: '인증번호 전송 중 오류가 발생했습니다');
  }

  /// 비밀번호 재설정
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    state = AuthState.loading();

    debugPrint("======== email: ${state.user?.email} =======");

    await _handleAuthRequest(() async {
      final useCase = ref.read(resetPasswordUseCaseProvider);
      await useCase(email: email, newPassword: newPassword);
      state = AuthState.initial();
    }, rethrowError: true, defaultErrorMessage: '비밀번호 재설정 중 오류가 발생했습니다');
  }

  /// 공통 에러 처리 헬퍼 메서드
  Future<T> _handleAuthRequest<T>(
    Future<T> Function() request, {
    bool loading = false,
    bool rethrowError = false,
    String defaultErrorMessage = '오류가 발생했습니다',
  }) async {
    if (loading) {
      state = AuthState.loading();
    }
    try {
      return await request();
    } on ValidationException catch (e) {
      state = AuthState.error(e.message);
      if (rethrowError) rethrow;
    } on NetworkException catch (e) {
      state = AuthState.error(e.message);
      if (rethrowError) rethrow;
    } on ServerException catch (e) {
      state = AuthState.error(e.message);
      if (rethrowError) rethrow;
    } catch (e) {
      state = AuthState.error(defaultErrorMessage);
      debugPrint('$defaultErrorMessage: $e');
      if (rethrowError) rethrow;
    }
    // 에러 발생 시 T 타입의 기본값을 반환해야 함 (Future<void>가 아닌 경우)
    // 이 예제에서는 rethrow 하거나 Future<void>가 대부분이라 문제가 덜하지만,
    // Future<bool> 같은 경우를 위해 기본값 처리가 필요할 수 있습니다.
    // 여기서는 rethrowError=true로 처리하여 호출부에서 처리하도록 유도합니다.
    throw Exception(defaultErrorMessage);
  }
}
