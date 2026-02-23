import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moamoa/core/constants/api_constants.dart';
import 'package:moamoa/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:moamoa/features/auth/data/models/auth_token_model.dart';
import 'package:moamoa/features/auth/data/models/user_model.dart';
import 'package:moamoa/features/auth/presentation/providers/auth_providers.dart';
import 'package:moamoa/features/common/providers/dio_provider.dart';

class _InMemoryAuthLocalDataSource implements AuthLocalDataSource {
  _InMemoryAuthLocalDataSource({AuthTokenModel? initialToken})
      : _token = initialToken;

  AuthTokenModel? _token;
  UserModel? _user;
  String? _lastLoginProvider;
  int clearAllCount = 0;

  @override
  Future<void> clearAll() async {
    clearAllCount += 1;
    _token = null;
    _user = null;
    _lastLoginProvider = null;
  }

  @override
  Future<void> deleteToken() async {
    _token = null;
  }

  @override
  Future<void> deleteUser() async {
    _user = null;
  }

  @override
  Future<String?> getLastLoginProvider() async => _lastLoginProvider;

  @override
  Future<AuthTokenModel?> getToken() async => _token;

  @override
  Future<UserModel?> getUser() async => _user;

  @override
  Future<bool> hasToken() async => _token != null;

  @override
  Future<void> saveLastLoginProvider(String provider) async {
    _lastLoginProvider = provider;
  }

  @override
  Future<void> saveToken(AuthTokenModel token) async {
    _token = token;
  }

  @override
  Future<void> saveUser(UserModel user) async {
    _user = user;
  }
}

class _RaceConditionAdapter implements HttpClientAdapter {
  int refreshCallCount = 0;
  int protectedCallCount = 0;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (options.path == ApiConstants.refreshToken) {
      refreshCallCount += 1;

      // 동시 401 상황에서 한 번의 refresh만 발생하는지 확인하기 위한 인위적 지연
      await Future<void>.delayed(const Duration(milliseconds: 40));

      return _json(
        statusCode: 200,
        data: {
          'accessToken': 'new_access',
          'refreshToken': 'new_refresh',
        },
      );
    }

    if (options.path == '/race-protected') {
      protectedCallCount += 1;
      final authHeader = options.headers['Authorization'];

      if (authHeader == 'Bearer new_access') {
        return _json(
          statusCode: 200,
          data: {'ok': true},
        );
      }

      return _json(
        statusCode: 401,
        data: {'code': 'A002', 'message': 'TOKEN_EXPIRED'},
      );
    }

    return _json(
      statusCode: 404,
      data: {'code': 'NOT_FOUND'},
    );
  }

  ResponseBody _json({
    required int statusCode,
    required Map<String, dynamic> data,
  }) {
    return ResponseBody.fromString(
      jsonEncode(data),
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType]
      },
    );
  }
}

void main() {
  test('여러 401 요청이 동시에 발생해도 refresh token 요청은 1번만 실행된다', () async {
    final localDataSource = _InMemoryAuthLocalDataSource(
      initialToken: const AuthTokenModel(
        accessToken: 'old_access',
        refreshToken: 'old_refresh',
      ),
    );
    final adapter = _RaceConditionAdapter();

    final container = ProviderContainer(
      overrides: [
        authLocalDataSourceProvider.overrideWithValue(localDataSource),
        authInterceptorBasicDioFactoryProvider.overrideWithValue(() {
          final dio = Dio(
            BaseOptions(
              baseUrl: ApiConstants.baseUrl,
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
            ),
          );
          dio.httpClientAdapter = adapter;
          return dio;
        }),
      ],
    );
    addTearDown(container.dispose);

    final dio = container.read(dioProvider);
    dio.httpClientAdapter = adapter;

    final responses = await Future.wait(
      List.generate(5, (_) => dio.get('/race-protected')),
    );

    expect(responses.every((response) => response.statusCode == 200), isTrue);
    expect(adapter.refreshCallCount, 1);
    expect(localDataSource.clearAllCount, 0);
    expect((await localDataSource.getToken())?.accessToken, 'new_access');
  });
}
