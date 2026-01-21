import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moamoa/core/constants/api_constants.dart';
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

    if (statusCode == 404 && _isUserNotFound(err.response?.data)) {
      await localDataSource.clearAll();
      ref.read(authViewModelProvider.notifier).forceUnauthenticated(
            errorMessage: '사용자를 찾을 수 없습니다. 다시 로그인해주세요.',
          );
      if (kDebugMode) {
        debugPrint('[AuthInterceptor] 사용자 없음 → 자동 로그아웃 처리');
      }
      return handler.next(err);
    }

    if (statusCode == 403 &&
        _isAccountBookAccessForbidden(err.response?.data)) {
      await localDataSource.clearAll();
      ref.read(authViewModelProvider.notifier).forceUnauthenticated(
            errorMessage: '계정이 유효하지 않습니다. 다시 로그인해주세요.',
          );
      if (kDebugMode) {
        debugPrint('[AuthInterceptor] 계정 접근 불가(403 A003) → 자동 로그아웃 처리');
      }
      return handler.next(err);
    }

    if (err.requestOptions.path == ApiConstants.refreshToken &&
        statusCode == 400 &&
        _isInvalidRefreshToken(err.response?.data)) {
      await localDataSource.clearAll();
      ref
          .read(authViewModelProvider.notifier)
          .forceUnauthenticated(errorMessage: '세션이 만료되었습니다. 다시 로그인해주세요.');
      if (kDebugMode) {
        debugPrint('[AuthInterceptor] Refresh Token 400 → 자동 로그아웃 처리');
      }
      return handler.next(err);
    }

    if (statusCode != 401) {
      return handler.next(err);
    }

    if (_skip401Paths.contains(err.requestOptions.path)) {
      return handler.next(err);
    }

    // Refresh Token 엔드포인트 자체에서 401 발생 → 로그아웃 처리
    if (err.requestOptions.path == ApiConstants.refreshToken) {
      await localDataSource.clearAll();

      ref
          .read(authViewModelProvider.notifier)
          .forceUnauthenticated(errorMessage: '세션이 만료되었습니다. 다시 로그인해주세요.');

      if (kDebugMode) {
        debugPrint('[AuthInterceptor] Refresh Token 엔드포인트 401 → 자동 로그아웃 처리');
      }
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
      // Lock으로 보호: 동시에 여러 요청이 401을 받더라도 refresh는 한 번만 실행
      final newToken = await _lock.synchronized(() async {
        // 1. 현재 저장된 토큰 다시 확인
        final currentToken = await localDataSource.getToken();
        if (currentToken == null) {
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
            debugPrint('[AuthInterceptor] 토큰이 이미 갱신되었습니다. (Storage Check)');
          }
          return currentToken;
        }

        // 3. 진짜 갱신이 필요한 경우에만 요청 실행
        if (kDebugMode) {
          debugPrint('[AuthInterceptor] 새로운 Refresh Token 요청 실행');
        }
        final refreshDio = _createBasicDio();

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
      });

      // 원래 실패했던 요청을 새 토큰으로 재시도
      final newOptions =
          _applyNewToken(err.requestOptions, newToken.accessToken);
      final retryDio = _createBasicDio();
      final response = await retryDio.fetch(newOptions);

      if (kDebugMode) {
        debugPrint('[AuthInterceptor] 원래 요청 재시도 성공');
      }
      return handler.resolve(response);
    } catch (e) {
      // TODO(auth): Refresh Token 실패 원인별 로깅 분리
      // 1️⃣ 네트워크 오류 (인터넷 끊김, 타임아웃)
      //    - e is DioException && e.type == DioExceptionType.connectionTimeout
      //
      // 2️⃣ 서버 오류 (5xx)
      //    - e is DioException && e.response?.statusCode >= 500
      //
      // 3️⃣ Refresh Token 만료 / 무효 (401)
      //    - e is DioException && e.response?.statusCode == 401
      //    - 서버에서 refreshToken expired / invalid 응답
      //
      // 4️⃣ 기타 예외 (파싱 오류, 예상 못한 에러)
      //
      // 👉 추후 Crashlytics / Sentry 연동 시
      //    원인별 tag 또는 error code로 분리 수집 권장

      // 1. 로컬 데이터 삭제 (토큰 + 사용자 정보)
      await localDataSource.clearAll();

      // 2. AuthViewModel 상태를 unauthenticated로 변경
      // → GoRouter의 redirect가 자동으로 /login으로 이동
      ref
          .read(authViewModelProvider.notifier)
          .forceUnauthenticated(errorMessage: '세션이 만료되었습니다. 다시 로그인해주세요.');

      if (kDebugMode) {
        debugPrint('[AuthInterceptor] Refresh Token 실패 → 자동 로그아웃 처리');
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
      final message = data['message'];
      if (message is String) {
        return message.contains('사용자를 찾을 수 없습니다');
      }
    }
    return false;
  }

  bool _isInvalidRefreshToken(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String) {
        return message.contains('유효하지 않은 Refresh Token');
      }
    }
    return false;
  }

  bool _isAccountBookAccessForbidden(dynamic data) {
    if (data is Map<String, dynamic>) {
      final code = data['code'];
      if (code is String) {
        return code == 'A003';
      }
    }
    return false;
  }
}
