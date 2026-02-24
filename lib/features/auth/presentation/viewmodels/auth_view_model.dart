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
import 'package:moamoa/features/auth/presentation/states/auth_ui_event.dart';
import 'package:moamoa/features/auth/presentation/states/login_error_action.dart';
import 'package:moamoa/features/auth/presentation/viewmodels/auth_ui_event_view_model.dart';
import 'package:moamoa/features/account_book/presentation/providers/account_book_providers.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';

// entities
import 'package:moamoa/features/auth/domain/entities/gender.dart';

part 'auth_view_model.g.dart';

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
@Riverpod(keepAlive: true)
class AuthViewModel extends _$AuthViewModel {
  static const String _alreadyRegisteredWithOtherMethodMessage =
      '로그인으로 가입되어 있습니다';

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
          OneSignal.login(userEntity.email);
          if (kDebugMode) {
            debugPrint('[AuthViewModel] OneSignal 로그인: ${userEntity.email}');
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
      OneSignal.login(result.user.email);
      ref.invalidate(selectedAccountBookViewModelProvider);
    },
        loading: true,
        defaultErrorMessage: '로그인 중 오류가 발생했습니다',
        errorEventBuilder: _buildLoginErrorUiEvent);
  }

  /// 회원가입 인증번호 전송
  Future<bool> sendSignupCode(String email) async {
    return _handleAuthRequest(() async {
      final useCase = ref.read(sendSignupCodeUseCaseProvider);
      await useCase(email);
      state = AuthState.initial(); // 성공 시 초기 상태로 복귀
      return true;
    },
        loading: true,
        rethrowError: false,
        defaultErrorMessage: '인증번호 전송 중 오류가 발생했습니다',
        errorEventBuilder: _buildErrorToastUiEvent);
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
        defaultErrorMessage: '인증번호 확인 중 오류가 발생했습니다',
        errorEventBuilder: _buildErrorToastUiEvent);
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
        defaultErrorMessage: '인증번호 확인 중 오류가 발생했습니다',
        errorEventBuilder: _buildErrorToastUiEvent);
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
      OneSignal.login(result.user.email);
      ref.invalidate(selectedAccountBookViewModelProvider);
    },
        loading: true,
        rethrowError: false,
        defaultErrorMessage: '회원가입 중 오류가 발생했습니다',
        errorEventBuilder: _buildErrorToastUiEvent);
  }

  /// 로그아웃
  Future<void> logout() async {
    try {
      final useCase = ref.read(logoutUseCaseProvider);
      await useCase();

      forceUnauthenticated();
    } catch (e) {
      state = _setLoading(false);
      _emitUiEvent(AuthUiEvent.showErrorToast('로그아웃 중 오류가 발생했습니다: $e'));
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
      OneSignal.login(result.user.email);
      ref.invalidate(selectedAccountBookViewModelProvider);
    },
        loading: true,
        rethrowError: false,
        defaultErrorMessage: 'Google 로그인 중 오류가 발생했습니다',
        errorEventBuilder: _buildLoginErrorUiEvent);
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
      OneSignal.login(result.user.email);
      ref.invalidate(selectedAccountBookViewModelProvider);
    },
        loading: true,
        rethrowError: false,
        defaultErrorMessage: 'Naver 로그인 중 오류가 발생했습니다',
        errorEventBuilder: _buildLoginErrorUiEvent);
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
      if (kDebugMode) {
        debugPrint('[AuthViewModel] useCase 객체: $useCase');
        debugPrint('[AuthViewModel] useCase.call() 호출 직전...');
      }
      final result = await useCase();
      if (kDebugMode) {
        debugPrint('[AuthViewModel] useCase.call() 완료!');
      }
      if (kDebugMode) {
        debugPrint('[AuthViewModel] 카카오 로그인 성공: ${result.user.email}');
      }
      state = AuthState.authenticated(user: result.user);
      OneSignal.login(result.user.email);
      ref.invalidate(selectedAccountBookViewModelProvider);
    },
        loading: true,
        rethrowError: false,
        defaultErrorMessage: 'Kakao 로그인 중 오류가 발생했습니다',
        errorEventBuilder: _buildLoginErrorUiEvent);
  }

  LoginErrorAction resolveLoginErrorAction(String message) {
    if (!message.contains(_alreadyRegisteredWithOtherMethodMessage)) {
      return LoginErrorAction.showToast(message);
    }

    final provider = _extractLoginProvider(message);
    if (provider == LoginProviderType.unknown) {
      return LoginErrorAction.showToast(message);
    }

    return LoginErrorAction.showLoginMethodDialog(
      message: message,
      provider: provider,
    );
  }

  Future<void> loginWithProvider(LoginProviderType provider) async {
    switch (provider) {
      case LoginProviderType.naver:
        await loginWithNaver();
        return;
      case LoginProviderType.google:
        await loginWithGoogle();
        return;
      case LoginProviderType.kakao:
        await loginWithKakao();
        return;
      case LoginProviderType.email:
      case LoginProviderType.unknown:
        return;
    }
  }

  LoginProviderType _extractLoginProvider(String message) {
    if (message.contains('NAVER')) {
      return LoginProviderType.naver;
    }
    if (message.contains('GOOGLE')) {
      return LoginProviderType.google;
    }
    if (message.contains('KAKAO')) {
      return LoginProviderType.kakao;
    }
    if (message.contains('EMAIL')) {
      return LoginProviderType.email;
    }
    return LoginProviderType.unknown;
  }

  AuthUiEvent _buildLoginErrorUiEvent(String message) {
    final action = resolveLoginErrorAction(message);
    if (action.shouldShowDialog) {
      return AuthUiEvent.showLoginMethodDialog(
        message: action.message,
        provider: action.provider,
      );
    }

    return AuthUiEvent.showErrorToast(action.message);
  }

  AuthUiEvent _buildErrorToastUiEvent(String message) {
    return AuthUiEvent.showErrorToast(message);
  }

  void _emitUiEvent(AuthUiEvent event) {
    ref.read(authUiEventViewModelProvider.notifier).emit(event);
  }

  void _emitErrorUiEvent(
    AuthUiEvent Function(String message)? errorEventBuilder,
    String message,
  ) {
    if (errorEventBuilder == null) return;
    _emitUiEvent(errorEventBuilder(message));
  }

  /// 강제로 unauthenticated 상태로 변경
  /// (401 에러 발생 시 Interceptor에서 호출)
  void forceUnauthenticated({String? errorMessage}) {
    // OneSignal External User ID 정리
    OneSignal.logout();

    state = AuthState.unauthenticated();
    if (errorMessage != null && errorMessage.isNotEmpty) {
      _emitUiEvent(AuthUiEvent.showErrorToast(errorMessage));
    }

    // 강제 로그아웃(토큰 만료 등)에서도 사용자 캐시가 남지 않도록 동일 정리 수행
    _invalidateAllUserProviders();
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
        defaultErrorMessage: '인증번호 전송 중 오류가 발생했습니다',
        errorEventBuilder: _buildErrorToastUiEvent);
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
        defaultErrorMessage: '비밀번호 재설정 중 오류가 발생했습니다',
        errorEventBuilder: _buildErrorToastUiEvent);
  }

  AuthState _setLoading(bool isLoading) {
    return state.map(
      authenticated: (current) => current.copyWith(
        isLoading: isLoading,
      ),
      unauthenticated: (current) => current.copyWith(
        isLoading: isLoading,
      ),
    );
  }

  /// 공통 에러 처리 헬퍼 메서드
  Future<T> _handleAuthRequest<T>(
    Future<T> Function() request, {
    bool loading = false,
    bool rethrowError = false,
    String defaultErrorMessage = '오류가 발생했습니다',
    AuthUiEvent Function(String message)? errorEventBuilder,
  }) async {
    if (loading) {
      state = _setLoading(true);
    }
    try {
      return await request();
    } on ValidationException catch (e) {
      if (kDebugMode) {
        debugPrint('[AuthViewModel] ValidationException: ${e.message}');
      }
      state = _setLoading(false);
      _emitErrorUiEvent(errorEventBuilder, e.message);
      if (rethrowError) rethrow;
    } on UserCancelledException catch (e) {
      if (kDebugMode) {
        debugPrint('[AuthViewModel] UserCancelledException: $e');
      }
      state = _setLoading(false);
    } on UnauthorizedException catch (e) {
      if (kDebugMode) {
        debugPrint('[AuthViewModel] UnauthorizedException: ${e.message}');
      }
      state = _setLoading(false);
      _emitErrorUiEvent(errorEventBuilder, e.message);
      if (rethrowError) rethrow;
    } on NetworkException catch (e) {
      if (kDebugMode) {
        debugPrint('[AuthViewModel] NetworkException: ${e.message}');
      }
      state = _setLoading(false);
      _emitErrorUiEvent(errorEventBuilder, e.message);
      if (rethrowError) rethrow;
    } on ServerException catch (e) {
      if (kDebugMode) {
        debugPrint('[AuthViewModel] ServerException: ${e.message}');
      }
      state = _setLoading(false);
      _emitErrorUiEvent(errorEventBuilder, e.message);
      if (rethrowError) rethrow;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[AuthViewModel] 알 수 없는 에러: $e');
        debugPrint('[AuthViewModel] StackTrace: $stackTrace');
      }
      state = _setLoading(false);
      _emitErrorUiEvent(errorEventBuilder, defaultErrorMessage);
      if (rethrowError) rethrow;
    }
    // rethrowError=false인 경우의 안전한 fallback 처리
    if (T == bool) {
      return false as T;
    }
    if (null is T) {
      return null as T;
    }

    throw StateError(
      '_handleAuthRequest<$T> failed without fallback. '
      'Use rethrowError=true or a nullable/bool return type.',
    );
  }
}
