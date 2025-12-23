import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:moneyflow/core/constants/api_constants.dart';
import 'package:moneyflow/features/auth/data/models/auth_token_model.dart';
import 'package:moneyflow/features/auth/presentation/providers/auth_providers.dart';
import 'package:moneyflow/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences Provider
///
/// 주의: 보안이 필요한 데이터는 FlutterSecureStorage를 사용하세요
/// - 사용 용도: 일반 앱 설정, 테마, 언어 등 민감하지 않은 데이터
/// - 사용 금지: JWT 토큰, 비밀번호, 개인정보 등 민감한 데이터
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

/// FlutterSecureStorage Provider
/// - 민감한 데이터(JWT 토큰, 사용자 인증 정보)를 암호화하여 저장
/// - iOS: Keychain 사용
/// - Android: Custom AES encryption (v10+, 자동 마이그레이션)
final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  const iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  const androidOptions = AndroidOptions();

  return const FlutterSecureStorage(
    iOptions: iosOptions,
    aOptions: androidOptions,
  );
});

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
  dio.interceptors.add(PrettyDioLogger(
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
    responseBody: true,
    error: true,
    compact: true,
    filter: (options, args) {
      options.headers['Authorization'] = 'Bearer ***';
      return true;
    },
  ));

  return dio;
});

class _AuthInterceptor extends Interceptor {
  final Ref ref;

  // Refresh Token 요청이 한 번만 실행되도록 관리
  Completer<AuthTokenModel>? _refreshCompleter;

  _AuthInterceptor(this.ref);

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

    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Refresh Token 엔드포인트 자체에서 401 발생 → 로그아웃 처리
    if (err.requestOptions.path == ApiConstants.refreshToken) {
      await localDataSource.clearAll();

      ref
          .read(authViewModelProvider.notifier)
          .forceUnauthenticated(errorMessage: '세션이 만료되었습니다. 다시 로그인해주세요.');

      debugPrint('[AuthInterceptor] Refresh Token 엔드포인트 401 → 자동 로그아웃 처리');
      return handler.next(err);
    }

    // 저장된 토큰이 없는 경우 → 로그아웃 처리
    final token = await localDataSource.getToken();
    if (token == null || token.refreshToken.isEmpty) {
      await localDataSource.clearAll();

      ref
          .read(authViewModelProvider.notifier)
          .forceUnauthenticated(errorMessage: '세션이 만료되었습니다. 다시 로그인해주세요.');

      debugPrint('[AuthInterceptor] 토큰 없음 → 자동 로그아웃 처리');
      return handler.next(err);
    }

    try {
      // refresh 요청이 이미 실행 중이면 기다리기
      if (_refreshCompleter != null) {
        debugPrint("다른 refresh 요청을 기다리는 중");
        final newToken = await _refreshCompleter!.future;

        final newOptions =
            _applyNewToken(err.requestOptions, newToken.accessToken);
        final retryDio = _createBasicDio();

        final response = await retryDio.fetch(newOptions);
        return handler.resolve(response);
      }

      // 새로운 refresh 요청 실행
      _refreshCompleter = Completer<AuthTokenModel>();

      debugPrint("새로운 refresh 요청 실행");
      final refreshDio = _createBasicDio();

      final response = await refreshDio.post(
        ApiConstants.refreshToken,
        data: {'refreshToken': token.refreshToken},
      );

      final newAuthToken = AuthTokenModel.fromJson(response.data);

      await localDataSource.saveToken(newAuthToken);

      _refreshCompleter?.complete(newAuthToken);

      final newOptions =
          _applyNewToken(err.requestOptions, newAuthToken.accessToken);
      final retryDio = _createBasicDio();

      final newResponse = await retryDio.fetch(newOptions);
      return handler.resolve(newResponse);
    } catch (e) {
      // Refresh Token 과정 중 에러가 발생했고, 아직 Completer가 완료되지 않은 경우에만 처리
      if (_refreshCompleter != null && !_refreshCompleter!.isCompleted) {
        _refreshCompleter?.completeError(e);

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

        debugPrint('[AuthInterceptor] Refresh Token 실패 → 자동 로그아웃 처리');
      }

      if (e is DioException) return handler.reject(e);
      return handler.next(err);
    } finally {
      _refreshCompleter = null;
    }
  }

  RequestOptions _applyNewToken(RequestOptions options, String accessToken) {
    final newHeaders = Map<String, dynamic>.from(options.headers);
    newHeaders['Authorization'] = 'Bearer $accessToken';

    return options.copyWith(headers: newHeaders);
  }
}
