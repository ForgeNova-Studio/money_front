// packages
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// core
import 'package:moneyflow/core/exceptions/exceptions.dart';

// models
import 'package:moneyflow/features/auth/data/models/models.dart';

// dataSources
import 'package:moneyflow/features/auth/data/datasources/local/auth_local_datasource.dart';

/// Auth Local Data Source 구현체
///
/// FlutterSecureStorage를 사용한 안전한 로컬 저장소 구현
/// - 민감한 인증 정보(JWT 토큰)를 암호화하여 저장
/// - iOS: Keychain 사용
/// - Android: EncryptedSharedPreferences 사용
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;

  // Storage Key 상수
  static const String _keyToken = 'auth_token';
  static const String _keyUser = 'auth_user';

  AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> saveToken(AuthTokenModel token) async {
    try {
      // Model을 JSON으로 변환하여 암호화된 저장소에 저장
      final json = token.toJson();
      final jsonString = jsonEncode(json);
      await secureStorage.write(key: _keyToken, value: jsonString);
    } catch (e) {
      throw StorageException('토큰 저장 실패: $e');
    }
  }

  @override
  Future<AuthTokenModel?> getToken() async {
    try {
      final jsonString = await secureStorage.read(key: _keyToken);
      if (jsonString == null) return null;

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      // Storage에서 불러올 때는 fromStorage 사용 (expiresAt DateTime 처리)
      return AuthTokenModel.fromStorage(json);
    } catch (e) {
      throw StorageException('토큰 불러오기 실패: $e');
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      await secureStorage.delete(key: _keyToken);
    } catch (e) {
      throw StorageException('토큰 삭제 실패: $e');
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      final json = user.toJson();
      final jsonString = jsonEncode(json);
      await secureStorage.write(key: _keyUser, value: jsonString);
    } catch (e) {
      throw StorageException('사용자 정보 저장 실패: $e');
    }
  }

  @override
  Future<UserModel?> getUser() async {
    try {
      final jsonString = await secureStorage.read(key: _keyUser);
      if (jsonString == null) return null;

      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return UserModel.fromJson(json);
    } catch (e) {
      throw StorageException('사용자 정보 불러오기 실패: $e');
    }
  }

  @override
  Future<void> deleteUser() async {
    try {
      await secureStorage.delete(key: _keyUser);
    } catch (e) {
      throw StorageException('사용자 정보 삭제 실패: $e');
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await Future.wait([
        secureStorage.delete(key: _keyToken),
        secureStorage.delete(key: _keyUser),
      ]);
    } catch (e) {
      throw StorageException('데이터 삭제 실패: $e');
    }
  }

  @override
  Future<bool> hasToken() async {
    try {
      return await secureStorage.containsKey(key: _keyToken);
    } catch (e) {
      throw StorageException('토큰 확인 실패: $e');
    }
  }
}
