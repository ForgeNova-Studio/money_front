// packages
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

// core
import 'package:moamoa/core/exceptions/exceptions.dart';

// providers/states
import 'package:moamoa/features/auth/presentation/providers/auth_providers.dart';
import 'package:moamoa/features/auth/presentation/states/auth_state.dart';
import 'package:moamoa/features/account_book/presentation/providers/account_book_providers.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';

// entities
import 'package:moamoa/features/auth/domain/entities/gender.dart';

part 'auth_view_model.g.dart';

/// Auth ViewModel
///
/// 인증 관련 비즈니스 로직 처리
/// - 로그인
/// - 회원가입
/// - 로그아웃
/// - 현재 사용자 정보 조회
@Riverpod(keepAlive: true)
class AuthViewModel extends _$AuthViewModel {
  @override
  AuthState build() {
    // 초기화 시 로딩 상태로 시작
    // Future.microtask를 사용하여 비동기 초기화 실행
    Future.microtask(_checkCurrentUser);
    return const AuthState.unauthenticated(isLoading: true);
  }

  /// 현재 사용자 정보 확인 (로컬 토큰 기반)
  ///
  /// 앱 시작 시 로컬 저장소의 토큰과 사용자 정보를 확인하여
  /// 빠른 초기화를 제공합니다.
  /// - 토큰이 있으면: authenticated 상태로 변경
  /// - 토큰이 없으면: unauthenticated 상태로 변경
  Future<void> _checkCurrentUser() async {
    try {
      if (kDebugMode) {
        debugPrint('[AuthViewModel] 토큰 확인 시작');
      }
      // 로컬 저장소에서 토큰 확인 (원격 API 호출 없이)
      final localDataSource = ref.read(authLocalDataSourceProvider);
      final hasToken = await localDataSource.hasToken();

      if (kDebugMode) {
        debugPrint('[AuthViewModel] 토큰 존재 여부: $hasToken');
      }

      if (hasToken) {
        // 토큰이 있으면 로컬 사용자 정보 불러오기
        final user = await localDataSource.getUser();
        if (kDebugMode) {
          debugPrint('[AuthViewModel] 사용자 정보: ${user?.email}');
        }

        if (!ref.mounted) return; // Provider가 해제되었으면 작업 중단

        if (user != null) {
          final userEntity = user.toEntity();
          state = AuthState.authenticated(user: userEntity);

          // OneSignal에 External User ID 등록 (개인 푸시 알림용)
          OneSignal.login(userEntity.userId);
          if (kDebugMode) {
            debugPrint('[AuthViewModel] OneSignal 로그인: ${userEntity.userId}');
            debugPrint('[AuthViewModel] 인증된 상태로 변경됨');
          }
        } else {
          // 토큰은 있지만 사용자 정보가 없는 경우 (비정상 상태)
          state = AuthState.unauthenticated();
          if (kDebugMode) {
            debugPrint('[AuthViewModel] 사용자 정보 없음 - 미인증 상태로 변경');
          }
        }
      } else {
        if (!ref.mounted) return; // Provider가 해제되었으면 작업 중단
        // 토큰이 없으면 로그아웃 상태
        state = AuthState.unauthenticated();
        if (kDebugMode) {
          debugPrint('[AuthViewModel] 토큰 없음 - 미인증 상태로 변경');
        }
      }
    } catch (e) {
      // 에러 발생 시 로그아웃 상태로 처리
      if (!ref.mounted) return; // Provider가 해제되었으면 작업 중단
      if (kDebugMode) {
        debugPrint('[AuthViewModel] 에러 발생: $e');
      }
      state = AuthState.unauthenticated();
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
      state = AuthState.authenticated(user: result.user);

      // OneSignal에 External User ID 등록
      OneSignal.login(result.user.userId);
      ref.invalidate(selectedAccountBookViewModelProvider);
    }, loading: true, defaultErrorMessage: '로그인 중 오류가 발생했습니다');
  }

  /// 회원가입 인증번호 전송
  Future<void> sendSignupCode(String email) async {
    await _handleAuthRequest(() async {
      final useCase = ref.read(sendSignupCodeUseCaseProvider);
      await useCase(email);
      state = AuthState.initial(); // 성공 시 초기 상태로 복귀
    },
        loading: true,
        rethrowError: false,
        defaultErrorMessage: '인증번호 전송 중 오류가 발생했습니다');
  }

  /// 회원가입 인증번호 검증
  Future<bool> verifySignupCode({
    required String email,
    required String code,
  }) async {
    return _handleAuthRequest(() async {
      final useCase = ref.read(verifySignupCodeUseCaseProvider);
      final result = await useCase(email: email, code: code);
      state = AuthState.initial(); // 성공 시 초기 상태로 복귀
      return result;
    },
        loading: true,
        rethrowError: false,
        defaultErrorMessage: '인증번호 확인 중 오류가 발생했습니다');
  }

  /// 비밀번호 찾기 인증번호 검증
  Future<bool> verifyFindPasswordCode({
    required String email,
    required String code,
  }) async {
    return _handleAuthRequest(() async {
      final useCase = ref.read(verifyFindPasswordCodeUseCaseProvider);
      final result = await useCase(email: email, code: code);
      state = AuthState.initial(); // 성공 시 초기 상태로 복귀
      return result;
    },
        loading: true,
        rethrowError: false,
        defaultErrorMessage: '인증번호 확인 중 오류가 발생했습니다');
  }

  /// 회원가입
  Future<void> register({
    required String email,
    required String password,
    required String confirmPassword,
    required String nickname,
    required Gender gender,
  }) async {
    await _handleAuthRequest(() async {
      final useCase = ref.read(registerUseCaseProvider);
      final result = await useCase(
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        nickname: nickname,
        gender: gender,
      );
      state = AuthState.authenticated(user: result.user);

      // OneSignal에 External User ID 등록
      OneSignal.login(result.user.userId);
      ref.invalidate(selectedAccountBookViewModelProvider);
    },
        loading: true,
        rethrowError: false,
        defaultErrorMessage: '회원가입 중 오류가 발생했습니다');
  }

  /// 로그아웃
  Future<void> logout() async {
    try {
      final useCase = ref.read(logoutUseCaseProvider);
      await useCase();

      // OneSignal 로그아웃 (External User ID 해제)
      OneSignal.logout();

      // 🔴 중요: 모든 사용자 관련 Provider들을 무효화하여 이전 계정 데이터 완전 초기화
      // 로그아웃 후 다른 계정 로그인 시 이전 데이터가 남지 않도록 함
      _invalidateAllUserProviders();

      state = AuthState.unauthenticated();
    } catch (e) {
      state = _setErrorMessage('로그아웃 중 오류가 발생했습니다: $e');
      rethrow;
    }
  }

  /// 모든 사용자 관련 Provider 무효화
  void _invalidateAllUserProviders() {
    // 가계부 관련
    ref.invalidate(accountBooksProvider);
    ref.invalidate(selectedAccountBookViewModelProvider);

    // 주석 처리한 이유는 이미 잘 처리되고 있어 명시적으로 할 필요 없기 때문
    // 추후 필요시 명시적으로 제거 가능
    // 홈/거래 관련 (autoDispose이지만 명시적 초기화)
    // ref.invalidate(homeViewModelProvider); // 필요시 import 추가

    // 알림 관련
    // ref.invalidate(notificationViewModelProvider); // 필요시 import 추가

    // 자산 관련
    // ref.invalidate(assetViewModelProvider); // 필요시 import 추가

    // 커플 관련
    // ref.invalidate(coupleViewModelProvider); // 필요시 import 추가
  }

  /// Google 로그인
  Future<void> loginWithGoogle() async {
    await _handleAuthRequest(() async {
      final useCase = ref.read(googleLoginUseCaseProvider);
      final result = await useCase();
      state = AuthState.authenticated(user: result.user);
      OneSignal.login(result.user.userId);
      ref.invalidate(selectedAccountBookViewModelProvider);
    },
        loading: true,
        rethrowError: false,
        defaultErrorMessage: 'Google 로그인 중 오류가 발생했습니다');
  }

  /// Naver 로그인
  Future<void> loginWithNaver() async {
    if (kDebugMode) {
      debugPrint('[AuthViewModel] 네이버 로그인 시작');
    }
    await _handleAuthRequest(() async {
      if (kDebugMode) {
        debugPrint('[AuthViewModel] NaverLoginUseCase 호출');
      }
      final useCase = ref.read(naverLoginUseCaseProvider);
      final result = await useCase();
      if (kDebugMode) {
        debugPrint('[AuthViewModel] 네이버 로그인 성공: ${result.user.email}');
      }
      state = AuthState.authenticated(user: result.user);
      OneSignal.login(result.user.userId);
      ref.invalidate(selectedAccountBookViewModelProvider);
    },
        loading: true,
        rethrowError: false,
        defaultErrorMessage: 'Naver 로그인 중 오류가 발생했습니다');
  }

  /// Kakao 로그인
  Future<void> loginWithKakao() async {
    if (kDebugMode) {
      debugPrint('[AuthViewModel] 카카오 로그인 시작');
    }
    await _handleAuthRequest(() async {
      if (kDebugMode) {
        debugPrint('[AuthViewModel] KakaoLoginUseCase 호출');
      }
      final useCase = ref.read(kakaoLoginUseCaseProvider);
      final result = await useCase();
      if (kDebugMode) {
        debugPrint('[AuthViewModel] 카카오 로그인 성공: ${result.user.email}');
      }
      state = AuthState.authenticated(user: result.user);
      OneSignal.login(result.user.userId);
      ref.invalidate(selectedAccountBookViewModelProvider);
    },
        loading: true,
        rethrowError: false,
        defaultErrorMessage: 'Kakao 로그인 중 오류가 발생했습니다');
  }

  /// 에러 메시지 초기화
  void clearError() {
    state = _clearError();
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
        state = AuthState.authenticated(user: user);
      } else {
        state = AuthState.unauthenticated();
      }
    } catch (e) {
      // 에러 발생 시 현재 상태 유지
    }
  }

  /// 비밀번호 재설정 인증번호 전송
  Future<void> sendPasswordResetCode(String email) async {
    await _handleAuthRequest(() async {
      final useCase = ref.read(sendPasswordResetCodeUseCaseProvider);
      await useCase(email);
      state = AuthState.initial(); // 성공 시 초기 상태로 복귀
    },
        loading: true,
        rethrowError: true,
        defaultErrorMessage: '인증번호 전송 중 오류가 발생했습니다');
  }

  /// 비밀번호 재설정
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    if (kDebugMode) {
      debugPrint("======== email: ${state.user?.email} =======");
    }

    await _handleAuthRequest(() async {
      final useCase = ref.read(resetPasswordUseCaseProvider);
      await useCase(email: email, newPassword: newPassword);
      state = AuthState.initial(); // 성공 시 초기 상태로 복귀
    },
        loading: true,
        rethrowError: false,
        defaultErrorMessage: '비밀번호 재설정 중 오류가 발생했습니다');
  }

  AuthState _setLoading(bool isLoading) {
    return state.map(
      authenticated: (current) => current.copyWith(
        isLoading: isLoading,
        errorMessage: null,
      ),
      unauthenticated: (current) => current.copyWith(
        isLoading: isLoading,
        errorMessage: null,
      ),
    );
  }

  AuthState _setErrorMessage(String message) {
    return state.map(
      authenticated: (current) => current.copyWith(
        isLoading: false,
        errorMessage: message,
      ),
      unauthenticated: (current) => current.copyWith(
        isLoading: false,
        errorMessage: message,
      ),
    );
  }

  AuthState _clearError() {
    return state.map(
      authenticated: (current) => current.copyWith(errorMessage: null),
      unauthenticated: (current) => current.copyWith(errorMessage: null),
    );
  }

  /// 공통 에러 처리 헬퍼 메서드
  Future<T> _handleAuthRequest<T>(
    Future<T> Function() request, {
    bool loading = false,
    bool rethrowError = false,
    String defaultErrorMessage = '오류가 발생했습니다',
  }) async {
    if (loading) {
      state = _setLoading(true);
    }
    try {
      return await request();
    } on ValidationException catch (e) {
      state = _setErrorMessage(e.message);
      if (rethrowError) rethrow;
    } on UserCancelledException {
      state = _setLoading(false);
    } on UnauthorizedException catch (e) {
      state = _setErrorMessage(e.message);
      if (rethrowError) rethrow;
    } on NetworkException catch (e) {
      state = _setErrorMessage(e.message);
      if (rethrowError) rethrow;
    } on ServerException catch (e) {
      state = _setErrorMessage(e.message);
      if (rethrowError) rethrow;
    } catch (e) {
      state = _setErrorMessage(defaultErrorMessage);
      if (kDebugMode) {
        debugPrint('$defaultErrorMessage: $e');
      }
      if (rethrowError) rethrow;
    }
    // rethrowError가 false이고 에러가 발생한 경우,
    // Future<T>의 타입에 맞는 기본값을 반환해야 합니다.
    // T가 bool이면 false, void면 아무것도 반환하지 않습니다.
    // 여기서는 호출하는 쪽에서 rethrowError=true를 사용하거나 Future<void>이므로,
    // 이 라인에 도달하는 경우는 Future<void>의 에러 케이스입니다.
    // 따라서 예외를 던지는 대신 조용히 종료합니다.
    // 만약 bool을 반환하는데 rethrowError=false라면 `return false as T;`와 같은 처리가 필요합니다.
    return null
        as T; // Future<void>의 경우 null을 반환해도 문제가 없으며, bool의 경우 컴파일 에러를 유발하여 실수를 방지합니다.
  }
}
