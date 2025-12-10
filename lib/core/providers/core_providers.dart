import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moneyflow/core/constants/api_constants.dart';
import 'package:moneyflow/features/auth/presentation/providers/auth_providers.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences Provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
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
  ));

  return dio;
});

/// Auth Interceptor with Token Refresh
class _AuthInterceptor extends Interceptor {
  final Ref ref;
  static bool _isRefreshing = false;
  static final List<void Function()> _pendingCallbacks = [];

  _AuthInterceptor(this.ref);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // AuthLocalDataSource에서 토큰 가져오기
    final authLocalDataSource = ref.read(authLocalDataSourceProvider);
    final tokenModel = await authLocalDataSource.getToken();

    if (tokenModel != null) {
      options.headers['Authorization'] = 'Bearer ${tokenModel.accessToken}';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 에러가 아니거나, refresh 엔드포인트 자체에서 401이 발생한 경우는 처리하지 않음
    if (err.response?.statusCode != 401 ||
        err.requestOptions.path == ApiConstants.refreshToken) {
      return handler.next(err);
    }

    // 401 에러 처리: Token Refresh 시도
    try {
      // 이미 Refresh 중인 경우, 완료될 때까지 대기
      if (_isRefreshing) {
        await _waitForRefresh();
        return _retryRequest(err.requestOptions, handler);
      }

      // Refresh 시작
      _isRefreshing = true;

      // 현재 저장된 토큰 가져오기
      final authLocalDataSource = ref.read(authLocalDataSourceProvider);
      final tokenModel = await authLocalDataSource.getToken();

      if (tokenModel == null || tokenModel.refreshToken.isEmpty) {
        // 토큰이 없으면 로그아웃 처리
        throw Exception('No refresh token available');
      }

      // Refresh Token으로 새 토큰 요청
      final authRemoteDataSource = ref.read(authRemoteDataSourceProvider);
      final newTokenModel = await authRemoteDataSource.refreshToken(
        tokenModel.refreshToken,
      );

      // 새 토큰 저장
      await authLocalDataSource.saveToken(newTokenModel);

      // 대기 중인 요청들에게 알림
      _notifyPendingCallbacks();

      // 원래 요청 재시도
      return _retryRequest(err.requestOptions, handler);
    } catch (e) {
      // Refresh 실패: 로그아웃 처리
      final authLocalDataSource = ref.read(authLocalDataSourceProvider);
      await authLocalDataSource.clearAll();

      // 대기 중인 요청들에게 실패 알림
      _notifyPendingCallbacks();

      // 에러 전파
      return handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  /// Refresh가 완료될 때까지 대기
  Future<void> _waitForRefresh() async {
    final completer = Completer<void>();
    _pendingCallbacks.add(() => completer.complete());
    await completer.future;
  }

  /// 대기 중인 콜백들 실행
  void _notifyPendingCallbacks() {
    for (final callback in _pendingCallbacks) {
      callback();
    }
    _pendingCallbacks.clear();
  }

  /// 원래 요청 재시도
  Future<void> _retryRequest(
    RequestOptions requestOptions,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      // 새 토큰으로 헤더 업데이트
      final authLocalDataSource = ref.read(authLocalDataSourceProvider);
      final tokenModel = await authLocalDataSource.getToken();

      if (tokenModel != null) {
        requestOptions.headers['Authorization'] =
            'Bearer ${tokenModel.accessToken}';
      }

      // 요청 재시도
      final dio = ref.read(dioProvider);
      final response = await dio.fetch(requestOptions);
      handler.resolve(response);
    } catch (e) {
      handler.reject(e as DioException);
    }
  }
}
