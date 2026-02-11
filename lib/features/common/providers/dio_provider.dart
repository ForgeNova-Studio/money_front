import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moamoa/core/constants/api_constants.dart';
import 'package:moamoa/core/services/sentry_service.dart';
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

    // 5xx 서버 에러는 Sentry에 전송
    if (statusCode != null && statusCode >= 500) {
      final sentryService = ref.read(sentryServiceProvider);
      sentryService.captureApiError(
        url: err.requestOptions.path,
        statusCode: statusCode,
        method: err.requestOptions.method,
        responseBody: err.response?.data?.toString(),
      );
    }

    // 404 사용자 없음 처리: 현재 로그인 세션에 직접 관련된 API에서만 수행
    final path = err.requestOptions.path;
    final isCurrentUserPath = path == ApiConstants.currentUser ||
        path == ApiConstants.usersMe ||
        path == ApiConstants.refreshToken;

    if (statusCode == 404 &&
        isCurrentUserPath &&
        _isUserNotFound(err.response?.data)) {
      await localDataSource.clearAll();
      ref.read(authViewModelProvider.notifier).forceUnauthenticated(
            errorMessage: '사용자를 찾을 수 없습니다. 다시 로그인해주세요.',
          );
      if (kDebugMode) {
        debugPrint('[AuthInterceptor] 현재 사용자 데이터 없음(U001) → 자동 로그아웃 처리');
      }
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

    if (statusCode == 401) {
      // 1. 스킵 대상 경로 확인
      if (_skip401Paths.contains(err.requestOptions.path)) {
        return handler.next(err);
      }

      // 2. 토큰 만료 에러 코드(A002)가 명시적으로 있는 경우에만 갱신 시도
      // 그 외의 401(잘못된 로그인 정보 등)은 갱신 없이 에러 전달
      if (!_isTokenExpired(err.response?.data)) {
        if (kDebugMode) {
          debugPrint('[AuthInterceptor] 401 에러이나 토큰 만료(A002) 아님 → 갱신 생략');
        }
        return handler.next(err);
      }

      // 3. Refresh Token 엔드포인트 자체에서 401 발생 (A002) → 로그아웃 처리
      if (err.requestOptions.path == ApiConstants.refreshToken) {
        await localDataSource.clearAll();
        ref.read(authViewModelProvider.notifier).forceUnauthenticated(
              errorMessage: '세션이 만료되었습니다. 다시 로그인해주세요.',
            );
        if (kDebugMode) {
          debugPrint(
              '[AuthInterceptor] Refresh Token 엔드포인트 401(A002) → 자동 로그아웃 처리');
        }
        return handler.next(err);
      }
    } else if (statusCode == 400 &&
        err.requestOptions.path == ApiConstants.refreshToken &&
        _isInvalidRefreshToken(err.response?.data)) {
      // 4. Refresh Token 엔드포인트에서 400(A002) 발생 → 로그아웃 처리
      await localDataSource.clearAll();
      ref.read(authViewModelProvider.notifier).forceUnauthenticated(
            errorMessage: '세션이 만료되었습니다. 다시 로그인해주세요.',
          );
      if (kDebugMode) {
        debugPrint('[AuthInterceptor] Refresh Token 400(A002) → 자동 로그아웃 처리');
      }
      return handler.next(err);
    }

    if (statusCode != 401) {
      return handler.next(err);
    }

    // 저장된 토큰이 없는 경우 → 로그아웃 처리
    final token = await localDataSource.getToken();
    if (token == null || token.refreshToken.isEmpty) {
      await localDataSource.clearAll();

      ref
          .read(authViewModelProvider.notifier)
          .forceUnauthenticated(errorMessage: '세션이 만료되었습니다. 다시 로그인해주세요.');

      if (kDebugMode) {
        debugPrint('[AuthInterceptor] 토큰 없음 → 자동 로그아웃 처리');
      }
      return handler.next(err);
    }

    try {
      if (kDebugMode) {
        debugPrint(
            '[AuthInterceptor] 401 발생: 토큰 갱신 시도 시작 (${err.requestOptions.path})');
      }

      // Lock으로 보호: 동시에 여러 요청이 401을 받더라도 refresh는 한 번만 실행
      final newToken = await _lock.synchronized(() async {
        // 1. 현재 저장된 토큰 다시 확인
        final currentToken = await localDataSource.getToken();
        if (currentToken == null || currentToken.refreshToken.isEmpty) {
          if (kDebugMode) {
            debugPrint('[AuthInterceptor] 갱신 시도 중 토큰이 삭제됨');
          }
          throw DioException(
            requestOptions: err.requestOptions,
            error: 'Token cleared during refresh',
          );
        }

        // 2. Race Condition 방지 로직
        // 실패한 요청의 토큰과 현재 저장된 토큰을 비교
        final failedRequestTokenHeader =
            err.requestOptions.headers['Authorization'];
        final currentTokenHeader = 'Bearer ${currentToken.accessToken}';

        if (failedRequestTokenHeader != currentTokenHeader) {
          if (kDebugMode) {
            debugPrint(
                '[AuthInterceptor] 토큰이 이미 다른 요청에 의해 갱신되었습니다. (Storage Check)');
          }
          return currentToken;
        }

        // 3. 진짜 갱신이 필요한 경우에만 요청 실행
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
          return newAuthToken;
        } on DioException catch (refreshErr) {
          if (kDebugMode) {
            debugPrint(
                '[AuthInterceptor] ❌ Refresh Token API 호출 실패: ${refreshErr.response?.statusCode}');
            debugPrint('[AuthInterceptor] 에러 응답: ${refreshErr.response?.data}');
          }
          rethrow;
        }
      });

      // 원래 실패했던 요청을 새 토큰으로 재시도
      final newOptions =
          _applyNewToken(err.requestOptions, newToken.accessToken);

      if (kDebugMode) {
        debugPrint('[AuthInterceptor] 원래 요청 재시도: ${err.requestOptions.path}');
      }

      final retryDio = _createBasicDio();
      final response = await retryDio.fetch(newOptions);

      if (kDebugMode) {
        debugPrint('[AuthInterceptor] 원래 요청 재시도 성공');
      }
      return handler.resolve(response);
    } catch (e) {
      // 재시도 실패 상세 로그
      if (kDebugMode) {
        debugPrint('[AuthInterceptor] ⚠️ Refresh Token 또는 재시도 프로세스 실패: $e');
        if (e is DioException) {
          debugPrint('[AuthInterceptor] 상태 코드: ${e.response?.statusCode}');
          debugPrint('[AuthInterceptor] 응답 데이터: ${e.response?.data}');
        }
      }

      // 401 오류가 발생했다고 해서 무조건 로그아웃 시키는 대신,
      // Refresh Token 요청 자체가 실패했거나 (401/400), 토큰이 아예 없는 경우에만 로그아웃 수행
      bool shouldForceLogout = false;

      if (e is DioException) {
        final path = e.requestOptions.path;

        // Refresh Token 요청에서 에러가 난 경우
        if (path == ApiConstants.refreshToken) {
          shouldForceLogout = true;
          if (kDebugMode) {
            debugPrint('[AuthInterceptor] Refresh Token API 오류로 인한 강제 로그아웃 결정');
          }
        }
      } else if (e.toString().contains('Token cleared')) {
        shouldForceLogout = true;
      }

      if (shouldForceLogout) {
        await localDataSource.clearAll();
        ref
            .read(authViewModelProvider.notifier)
            .forceUnauthenticated(errorMessage: '세션이 만료되었습니다. 다시 로그인해주세요.');

        if (kDebugMode) {
          debugPrint('[AuthInterceptor] 프로세스 완료 → 자동 로그아웃 처리됨');
        }
      } else {
        if (kDebugMode) {
          debugPrint('[AuthInterceptor] 비로그인 관련 오류로 판단 → 로그아웃 건너뜀 (에러 전달)');
        }
      }

      if (e is DioException) return handler.reject(e);
      return handler.next(err);
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
      return code == 'A002';
    }
    return false;
  }

  bool _isInvalidRefreshToken(dynamic data) {
    if (data is Map<String, dynamic>) {
      final code = data['code'];
      // A002: TOKEN_EXPIRED (또는 전용 코드)
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
