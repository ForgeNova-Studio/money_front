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
    try {
      final response = await dio.post(
        ApiConstants.refreshToken,
        data: {
          'refreshToken': refreshToken,
        },
      );

      return AuthTokenModel.fromJson(response.data);
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }

  @override
  Future<bool> checkEmailDuplicate(String email) async {
    try {
      final response = await dio.get(
        ApiConstants.checkEmail,
        queryParameters: {
          'email': email,
        },
      );

      // API 응답이 { "isDuplicate": true/false } 형태라고 가정
      return response.data['isDuplicate'] as bool? ?? false;
    } on DioException catch (e) {
      throw ExceptionHandler.handleDioException(e);
    }
  }
}
