// packages
import 'package:dio/dio.dart';

// core
import 'package:moneyflow/core/constants/api_constants.dart';
import 'package:moneyflow/core/exceptions/exceptions.dart';

// models
import 'package:moneyflow/features/auth/data/models/models.dart';

// dataSources
import 'package:moneyflow/features/auth/data/datasources/remote/auth_remote_datasource.dart';

/// Auth Remote Data Source 구현체
///
/// Dio를 사용한 API 통신 구현
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String nickname,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.register,
        data: {
          'email': email,
          'password': password,
          'nickname': nickname,
        },
      );

      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await dio.get(ApiConstants.currentUser);

      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<AuthTokenModel> refreshToken(String refreshToken) async {
    // TODO: 백엔드에 refreshToken API가 없음. JWT 토큰 갱신 방법 확인 필요
    throw UnimplementedError('refreshToken API not implemented in backend');
    // try {
    //   final response = await dio.post(
    //     ApiConstants.refreshToken,
    //     data: {
    //       'refreshToken': refreshToken,
    //     },
    //   );
    //
    //   return AuthTokenModel.fromJson(response.data);
    // } on DioException catch (e) {
    //   throw ExceptionHandler.handleDioException(e);
    // }
  }

  @override
  Future<void> sendSignupCode(String email) async {
    try {
      await dio.post(
        ApiConstants.sendSignupCode,
        data: {
          'email': email,
        },
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<bool> verifySignupCode(String email, String code) async {
    try {
      final response = await dio.post(
        ApiConstants.verifySignupCode,
        data: {
          'email': email,
          'code': code,
        },
      );

      // API 응답이 { "success": true/false } 형태라고 가정
      return response.data['success'] as bool? ?? false;
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<AuthResponseModel> socialLogin({
    required String provider,
    required String idToken,
    required String nickname,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.socialLogin,
        data: {
          'provider': provider,
          'idToken': idToken,
          'nickname': nickname,
        },
      );

      return AuthResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }
}
