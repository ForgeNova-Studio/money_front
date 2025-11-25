import 'dart:convert';

import 'package:moneyflow/core/exceptions/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/models.dart';
import 'auth_local_datasource.dart';

/// Auth Local Data Source 구현체
///
/// SharedPreferences를 사용한 로컬 저장소 구현
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences prefs;

  // Storage Key 상수
  static const String _keyToken = 'auth_token';
  static const String _keyUser = 'auth_user';

  AuthLocalDataSourceImpl({required this.prefs});

  @override
  Future<void> saveToken(AuthTokenModel token) async {
    try {
      // Model을 JSON으로 변환하여 저장
      final json = token.toJson();
      final jsonString = jsonEncode(json);
      await prefs.setString(_keyToken, jsonString);
    } catch (e) {
      throw StorageException('토큰 저장 실패: $e');
    }
  }

  @override
  Future<AuthTokenModel?> getToken() async {
    try {
      final jsonString = prefs.getString(_keyToken);
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
      await prefs.remove(_keyToken);
    } catch (e) {
      throw StorageException('토큰 삭제 실패: $e');
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      final json = user.toJson();
      final jsonString = jsonEncode(json);
      await prefs.setString(_keyUser, jsonString);
    } catch (e) {
      throw StorageException('사용자 정보 저장 실패: $e');
    }
  }

  @override
  Future<UserModel?> getUser() async {
    try {
      final jsonString = prefs.getString(_keyUser);
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
      await prefs.remove(_keyUser);
    } catch (e) {
      throw StorageException('사용자 정보 삭제 실패: $e');
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await Future.wait([
        prefs.remove(_keyToken),
        prefs.remove(_keyUser),
      ]);
    } catch (e) {
      throw StorageException('데이터 삭제 실패: $e');
    }
  }

  @override
  Future<bool> hasToken() async {
    try {
      return prefs.containsKey(_keyToken);
    } catch (e) {
      throw StorageException('토큰 확인 실패: $e');
    }
  }
}
