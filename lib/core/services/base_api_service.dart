import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import 'storage_service.dart';

abstract class BaseApiService {
  late Dio dio;
  final StorageService _storageService = StorageService();

  BaseApiService() {
    dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // 인터셉터 추가
    dio.interceptors.add(_AuthInterceptor(_storageService, dio));
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
    ));
  }

  // Dio get dio => _dio;
}

class _AuthInterceptor extends Interceptor {
  final StorageService _storageService;
  final Dio _dio;
  static bool _isRefreshing = false;
  static final List<void Function()> _pendingCallbacks = [];

  _AuthInterceptor(this._storageService, this._dio);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storageService.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
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

      // 현재 저장된 Refresh Token 가져오기
      final refreshToken = await _storageService.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        // 토큰이 없으면 로그아웃 처리
        throw Exception('No refresh token available');
      }

      // Refresh Token으로 새 토큰 요청
      final response = await _dio.post(
        ApiConstants.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      // 새 토큰 저장
      final prefs = await SharedPreferences.getInstance();
      final newTokenJson = json.encode({
        'accessToken': response.data['accessToken'],
        'refreshToken': response.data['refreshToken'],
      });
      await prefs.setString('auth_token', newTokenJson);

      // 대기 중인 요청들에게 알림
      _notifyPendingCallbacks();

      // 원래 요청 재시도
      return _retryRequest(err.requestOptions, handler);
    } catch (e) {
      // Refresh 실패: 로그아웃 처리
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

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
      final token = await _storageService.getAccessToken();

      if (token != null) {
        requestOptions.headers['Authorization'] = 'Bearer $token';
      }

      // 요청 재시도
      final response = await _dio.fetch(requestOptions);
      handler.resolve(response);
    } catch (e) {
      handler.reject(e as DioException);
    }
  }
}
