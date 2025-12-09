// packages
import 'package:dio/dio.dart';

// core
import 'package:moneyflow/core/constants/api_constants.dart';
import 'package:moneyflow/core/exceptions/exceptions.dart';

// models
import 'package:moneyflow/features/auth/data/models/models.dart';
import 'package:moneyflow/features/auth/domain/entities/gender.dart';

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
  Future<RegisterResponseModel> register({
    required String email,
    required String password,
    required String nickname,
    required Gender gender,
  }) async {
    try {
      final response = await dio.post(
        ApiConstants.register,
        data: {
          'email': email,
          'password': password,
          'nickname': nickname,
          'gender': gender.toServerString(),
        },
      );

      return RegisterResponseModel.fromJson(response.data);
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
    try {
      final response = await dio.post(
        ApiConstants.refreshToken,
        data: {
          'refreshToken': refreshToken,
        },
      );

      // 백엔드는 LoginResponse 형식으로 응답 (accessToken, refreshToken, userId, profile 포함)
      // AuthTokenModel은 accessToken, refreshToken만 필요
      return AuthTokenModel.fromJson({
        'accessToken': response.data['accessToken'],
        'refreshToken': response.data['refreshToken'],
        // expiresIn은 백엔드에서 제공하지 않으므로 생략
      });
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
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

  @override
  Future<void> sendPasswordResetCode(String email) async {
    try {
      await dio.post(
        ApiConstants.sendPasswordResetCode,
        data: {
          'email': email,
        },
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<bool> verifyPasswordResetCode(String email, String code) async {
    try {
      final response = await dio.post(
        ApiConstants.verifyResetPasswordCode,
        data: {
          'email': email,
          'code': code,
        },
      );

      return response.data['success'] as bool? ?? false;
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      await dio.post(
        ApiConstants.resetPassword,
        data: {
          'email': email,
          'newPassword': newPassword,
        },
      );
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }
}
