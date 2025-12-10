import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Storage Service - AuthLocalDataSource의 'auth_token' 키에서 토큰을 읽음
///
/// 이 서비스는 BaseApiService와 호환성을 위해 유지됩니다.
/// AuthLocalDataSource가 저장한 JSON에서 토큰을 추출합니다.
class StorageService {
  static const String _keyAuthToken = 'auth_token';  // AuthLocalDataSource와 동일한 키
  static const String _keyUserId = 'user_id';

  /// AuthLocalDataSource에서 저장한 토큰을 읽어서 accessToken 반환
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenJson = prefs.getString(_keyAuthToken);

    if (tokenJson == null) return null;

    try {
      final tokenData = json.decode(tokenJson) as Map<String, dynamic>;
      return tokenData['accessToken'] as String?;
    } catch (e) {
      return null;
    }
  }

  /// AuthLocalDataSource에서 저장한 토큰을 읽어서 refreshToken 반환
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenJson = prefs.getString(_keyAuthToken);

    if (tokenJson == null) return null;

    try {
      final tokenData = json.decode(tokenJson) as Map<String, dynamic>;
      return tokenData['refreshToken'] as String?;
    } catch (e) {
      return null;
    }
  }

  /// 레거시 메서드 - AuthLocalDataSource를 사용하세요
  @Deprecated('Use AuthLocalDataSource.saveToken() instead')
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    // 이 메서드는 더 이상 사용되지 않습니다.
    // AuthLocalDataSource.saveToken()을 사용하세요.
    throw UnimplementedError(
      'Use AuthLocalDataSource.saveToken() instead'
    );
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, userId);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
