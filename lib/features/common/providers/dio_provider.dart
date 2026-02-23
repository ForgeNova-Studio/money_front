import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moamoa/core/constants/api_constants.dart';
import 'package:moamoa/core/services/sentry_service.dart';
import 'package:moamoa/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:moamoa/features/auth/data/models/auth_token_model.dart';
import 'package:moamoa/features/auth/presentation/providers/auth_providers.dart';
import 'package:moamoa/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:synchronized/synchronized.dart';

/// Dio Provider
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  dio.interceptors.add(_AuthInterceptor(ref));
  if (kDebugMode) {
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
      compact: true,
      // filter: (options, args) {
      //   options.headers['Authorization'] = 'Bearer ***';
      //   return true;
      // },
    ));
  }

  return dio;
});

class _AuthInterceptor extends Interceptor {
  final Ref ref;

  // Refresh Token 요청이 한 번만 실행되도록 관리 (Race Condition 방지)
  final Lock _lock = Lock();

  _AuthInterceptor(this.ref);

  // 401 세션 만료를 건너 뛰는 엔드포인트
  // 예) 로그인 실패를 세션 만료로 처리하지 않도록 추가
  static final Set<String> _skip401Paths = {
    ApiConstants.login,
    ApiConstants.register,
    ApiConstants.socialLogin,
    ApiConstants.mockSocialLogin,
    ApiConstants.sendSignupCode,
    ApiConstants.verifySignupCode,
    ApiConstants.sendPasswordResetCode,
    ApiConstants.verifyResetPasswordCode,
    ApiConstants.resetPassword,
    ApiConstants.authHealth,
    ApiConstants.devGetUserByEmail,
    ApiConstants.devGetAllUsers,
  };

  Dio _createBasicDio() {
    return Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final authLocalDataSource = ref.read(authLocalDataSourceProvider);
    final tokenModel = await authLocalDataSource.getToken();

    if (tokenModel != null) {
      options.headers['Authorization'] = 'Bearer ${tokenModel.accessToken}';
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final localDataSource = ref.read(authLocalDataSourceProvider);
    final statusCode = err.response?.statusCode;
    final path = err.requestOptions.path;

    // 5xx 서버 에러는 Sentry에 전송
    if (statusCode != null && statusCode >= 500) {
      final sentryService = ref.read(sentryServiceProvider);
      sentryService.captureApiError(
        url: path,
        statusCode: statusCode,
        method: err.requestOptions.method,
        responseBody: err.response?.data?.toString(),
      );
    }

    // 404 사용자 없음 처리: 현재 로그인 세션에 직접 관련된 API에서만 수행
    final isCurrentUserPath = path == ApiConstants.currentUser ||
        path == ApiConstants.usersMe ||
        path == ApiConstants.refreshToken;

    if (statusCode == 404 &&
        isCurrentUserPath &&
        _isUserNotFound(err.response?.data)) {
      await _forceLogout(
          localDataSource, '사용자를 찾을 수 없습니다. 다시 로그인해주세요.', 'U001');
      return handler.next(err);
    }

    if (statusCode == 403 &&
        _isAccountBookAccessForbidden(err.response?.data)) {
      // 장부 접근 권한 없음 → 로그아웃하지 않고, 에러만 전달
      // (다른 사용자의 장부 ID가 캐시되어 있을 때 발생)
      if (kDebugMode) {
        debugPrint('[AuthInterceptor] 장부 접근 불가(AB001) → 에러 전달 (로그아웃 X)');
      }
      return handler.next(err);
    }

    // 401 Unauthorized 처리 (토큰 만료 등)
    if (statusCode == 401) {
      // 1. 스킵 대상 경로 확인
      if (_skip401Paths.contains(path)) {
        return handler.next(err);
      }

      // 2. Refresh Token 엔드포인트 자체에서 401 발생 → 로그아웃 처리
      if (path == ApiConstants.refreshToken) {
        await _forceLogout(
            localDataSource, '세션이 만료되었습니다. 다시 로그인해주세요.', 'Refresh Token 401');
        return handler.next(err);
      }

      // 3. 토큰 만료 에러 코드(A002) 또는 인증 에러(A007 - 백엔드 이슈 대응) 확인
      // 그 외의 401은 갱신 없이 에러 전달
      if (!_isTokenExpired(err.response?.data)) {
        if (kDebugMode) {
          debugPrint('[AuthInterceptor] 401 에러이나 토큰 만료 아님 → 갱신 생략');
        }
        return handler.next(err);
      }

      // 3-1. 이미 로그아웃된 상태(토큰 삭제됨)에서의 401은 조용히 에러 전달
      // (로그아웃 후 Provider invalidate로 인한 불필요한 API 호출 방지)
      final currentToken = await localDataSource.getToken();
      if (currentToken == null || currentToken.refreshToken.isEmpty) {
        if (kDebugMode) {
          debugPrint('[AuthInterceptor] 401 발생했으나 토큰이 이미 삭제됨 → 갱신 생략');
        }
        return handler.next(err);
      }

      // 4. 토큰 갱신 시도
      try {
        if (kDebugMode) {
          debugPrint('[AuthInterceptor] 401 발생: 토큰 갱신 시도 시작 ($path)');
        }

        final response = await _refreshTokenAndRetry(err, localDataSource);
        return handler.resolve(response);
      } catch (e) {
        // 재시도 실패 처리 logic
        return _handleRefreshError(e, handler, err, localDataSource);
      }
    } else if (statusCode == 400 &&
        path == ApiConstants.refreshToken &&
        _isInvalidRefreshToken(err.response?.data)) {
      // Refresh Token 엔드포인트에서 400 발생 → 로그아웃 처리
      await _forceLogout(
          localDataSource, '세션이 만료되었습니다. 다시 로그인해주세요.', 'Refresh Token 400');
      return handler.next(err);
    }

    return handler.next(err);
  }

  /// 토큰 갱신 및 재시도 로직 (Lock으로 보호됨)
  Future<Response> _refreshTokenAndRetry(
      DioException originalErr, AuthLocalDataSource localDataSource) async {
    // 저장된 토큰이 없는 경우 확인
    final token = await localDataSource.getToken();
    if (token == null || token.refreshToken.isEmpty) {
      throw TokenClearedException('Initial check: Token is missing');
    }

    return _lock.synchronized(() async {
      // 1. 현재 저장된 토큰 다시 확인 (Double-checked locking)
      final currentToken = await localDataSource.getToken();
      if (currentToken == null || currentToken.refreshToken.isEmpty) {
        if (kDebugMode) {
          debugPrint('[AuthInterceptor] 갱신 시도 중 토큰이 삭제됨');
        }
        throw TokenClearedException('Sync check: Token is missing');
      }

      // 2. Race Condition 방지: 실패한 요청의 토큰과 현재 저장된 토큰 비교
      final failedRequestTokenHeader =
          originalErr.requestOptions.headers['Authorization'];
      final currentTokenHeader = 'Bearer ${currentToken.accessToken}';

      if (failedRequestTokenHeader != currentTokenHeader) {
        // 이미 갱신된 토큰이 있음 -> 바로 재시도
        if (kDebugMode) {
          debugPrint(
              '[AuthInterceptor] 토큰이 이미 다른 요청에 의해 갱신되었습니다. (Storage Check)');
        }
        return _retryRequest(
            originalErr.requestOptions, currentToken.accessToken);
      }

      // 3. 토큰 갱신 요청 실행
      if (kDebugMode) {
        debugPrint('[AuthInterceptor] 새로운 Refresh Token 요청 실행');
      }
      final refreshDio = _createBasicDio();

      try {
        final response = await refreshDio.post(
          ApiConstants.refreshToken,
          data: {'refreshToken': currentToken.refreshToken},
        );

        final newAuthToken = AuthTokenModel.fromJson(response.data);
        await localDataSource.saveToken(newAuthToken);

        if (kDebugMode) {
          debugPrint('[AuthInterceptor] 토큰 갱신 성공');
        }

        // 4. 원래 요청 재시도
        return _retryRequest(
            originalErr.requestOptions, newAuthToken.accessToken);
      } on DioException catch (refreshErr) {
        if (kDebugMode) {
          debugPrint(
              '[AuthInterceptor] ❌ Refresh Token API 호출 실패: ${refreshErr.response?.statusCode}');
          debugPrint('[AuthInterceptor] 에러 응답: ${refreshErr.response?.data}');
        }
        rethrow;
      }
    });
  }

  Future<Response> _retryRequest(
      RequestOptions requestOptions, String accessToken) async {
    final newOptions = _applyNewToken(requestOptions, accessToken);

    if (kDebugMode) {
      debugPrint('[AuthInterceptor] 원래 요청 재시도: ${requestOptions.path}');
    }

    final retryDio = _createBasicDio();
    final response = await retryDio.fetch(newOptions);

    if (kDebugMode) {
      debugPrint('[AuthInterceptor] 원래 요청 재시도 성공');
    }
    return response;
  }

  Future<void> _handleRefreshError(
      Object error,
      ErrorInterceptorHandler handler,
      DioException originalErr,
      AuthLocalDataSource localDataSource) async {
    // 재시도 실패 상세 로그
    if (kDebugMode) {
      debugPrint('[AuthInterceptor] ⚠️ Refresh Token 또는 재시도 프로세스 실패: $error');
      if (error is DioException) {
        debugPrint('[AuthInterceptor] 상태 코드: ${error.response?.statusCode}');
        debugPrint('[AuthInterceptor] 응답 데이터: ${error.response?.data}');
      }
    }

    bool shouldForceLogout = false;

    if (error is DioException) {
      final path = error.requestOptions.path;
      // Refresh Token 요청에서 에러가 난 경우
      if (path == ApiConstants.refreshToken) {
        shouldForceLogout = true;
        if (kDebugMode) {
          debugPrint('[AuthInterceptor] Refresh Token API 오류로 인한 강제 로그아웃 결정');
        }
      }
    } else if (error is TokenClearedException) {
      shouldForceLogout = true;
    }

    if (shouldForceLogout) {
      await _forceLogout(localDataSource, '세션이 만료되었습니다. 다시 로그인해주세요.',
          'Refresh Process Failed');
    } else {
      if (kDebugMode) {
        debugPrint('[AuthInterceptor] 비로그인 관련 오류로 판단 → 로그아웃 건너뜀 (에러 전달)');
      }
    }

    if (error is DioException) return handler.reject(error);
    return handler.next(originalErr);
  }

  Future<void> _forceLogout(AuthLocalDataSource localDataSource, String message,
      String reason) async {
    await localDataSource.clearAll();
    ref.read(authViewModelProvider.notifier).forceUnauthenticated(
          errorMessage: message,
        );
    if (kDebugMode) {
      debugPrint('[AuthInterceptor] $reason → 자동 로그아웃 처리됨');
    }
  }

  RequestOptions _applyNewToken(RequestOptions options, String accessToken) {
    final newHeaders = Map<String, dynamic>.from(options.headers);
    newHeaders['Authorization'] = 'Bearer $accessToken';

    return options.copyWith(headers: newHeaders);
  }

  bool _isUserNotFound(dynamic data) {
    if (data is Map<String, dynamic>) {
      final code = data['code'];
      // U001: USER_NOT_FOUND
      return code == 'U001';
    }
    return false;
  }

  bool _isTokenExpired(dynamic data) {
    if (data is Map<String, dynamic>) {
      final code = data['code'];
      // A002: TOKEN_EXPIRED
      // A007: AUTHENTICATION_ERROR (백엔드에서 만료된 토큰에 대해 A007을 줄 수 있음)
      return code == 'A002' || code == 'A007';
    }
    // 코드가 없으면 일단 만료로 간주하지 않음 (단순 401일 수도 있음)
    return false;
  }

  bool _isInvalidRefreshToken(dynamic data) {
    if (data is Map<String, dynamic>) {
      final code = data['code'];
      return code == 'A002';
    }
    return false;
  }

  bool _isAccountBookAccessForbidden(dynamic data) {
    if (data is Map<String, dynamic>) {
      final code = data['code'];
      // AB003: ACCOUNT_BOOK_ACCESS_DENIED
      return code == 'AB003';
    }
    return false;
  }
}

/// 토큰이 갱신 과정 중 삭제되었을 때 발생하는 예외
class TokenClearedException implements Exception {
  final String message;
  TokenClearedException(this.message);

  @override
  String toString() => 'TokenClearedException: $message';
}
