import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:moneyflow/features/auth/data/services/auth_api_service.dart';
import '../../domain/entities/user_model.dart';
import '../../../../core/services/storage_service.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _errorMessage;

  final AuthApiService _apiService = AuthApiService();
  final StorageService _storageService = StorageService();

  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;

  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> register({
    required String email,
    required String password,
    required String nickname,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.register(
        email: email,
        password: password,
        nickname: nickname,
      );

      // 토큰 저장
      await _storageService.saveTokens(
        response['accessToken'],
        response['refreshToken'],
      );
      await _storageService.saveUserId(response['userId']);

      // 사용자 정보 설정
      _user = UserModel(
        userId: response['userId'],
        email: email,
        nickname: nickname,
      );

      _status = AuthStatus.authenticated;
      notifyListeners();
    } on DioException catch (e) {
      _status = AuthStatus.error;
      _errorMessage = _handleError(e);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      print('🔐 로그인 시도: $email');
      final response = await _apiService.login(
        email: email,
        password: password,
      );

      print('✅ API 응답 받음: ${response.keys}');

      // 토큰 저장
      await _storageService.saveTokens(
        response['accessToken'],
        response['refreshToken'],
      );
      print('💾 토큰 저장 완료');

      await _storageService.saveUserId(response['userId']);
      print('💾 userId 저장 완료: ${response['userId']}');

      // 사용자 정보 설정
      final profileData = Map<String, dynamic>.from(response['profile']);
      profileData['userId'] = response['userId'];
      print('👤 프로필 데이터: $profileData');

      _user = UserModel.fromJson(profileData);
      print('✅ UserModel 생성 완료: ${_user?.nickname}');

      _status = AuthStatus.authenticated;
      print('✅ 인증 상태 변경: $_status');
      notifyListeners();
      print('✅ 로그인 완료!');
    } on DioException catch (e) {
      print('❌ DioException 발생: ${e.message}');
      _status = AuthStatus.error;
      _errorMessage = _handleError(e);
      notifyListeners();
      rethrow;
    } catch (e, stackTrace) {
      print('❌ 예외 발생: $e');
      print('📍 스택 트레이스: $stackTrace');
      _status = AuthStatus.error;
      _errorMessage = '로그인 처리 중 오류가 발생했습니다: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> socialLogin({
    required String provider,
    required String idToken,
    required String nickname,
  }) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      print('🔐 소셜 로그인 시도: $provider');
      final response = await _apiService.socialLogin(
        provider: provider,
        idToken: idToken,
        nickname: nickname,
      );

      print('✅ 소셜 로그인 API 응답 받음');

      // 토큰 저장
      await _storageService.saveTokens(
        response['accessToken'],
        response['refreshToken'],
      );
      await _storageService.saveUserId(response['userId']);

      // 사용자 정보 설정
      final profileData = Map<String, dynamic>.from(response['profile']);
      profileData['userId'] = response['userId'];
      _user = UserModel.fromJson(profileData);

      _status = AuthStatus.authenticated;
      notifyListeners();
      print('✅ 소셜 로그인 완료!');
    } on DioException catch (e) {
      print('❌ 소셜 로그인 DioException: ${e.message}');
      _status = AuthStatus.error;
      _errorMessage = _handleError(e);
      notifyListeners();
      rethrow;
    } catch (e) {
      print('❌ 소셜 로그인 예외: $e');
      _status = AuthStatus.error;
      _errorMessage = '소셜 로그인 처리 중 오류가 발생했습니다: $e';
      notifyListeners();
      rethrow;
    }
  }

  Future<void> logout() async {
    await _storageService.clear();
    _user = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  String _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      if (data is Map && data.containsKey('message')) {
        return data['message'];
      }
      return '서버 오류가 발생했습니다';
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return '서버 연결 시간이 초과되었습니다';
    } else if (error.type == DioExceptionType.connectionError) {
      return '서버에 연결할 수 없습니다';
    }
    return '알 수 없는 오류가 발생했습니다';
  }
}
