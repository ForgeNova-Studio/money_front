import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences Provider
///
/// 주의: 보안이 필요한 데이터는 FlutterSecureStorage를 사용하세요
/// - 사용 용도: 일반 앱 설정, 테마, 언어 등 민감하지 않은 데이터
/// - 사용 금지: JWT 토큰, 비밀번호, 개인정보 등 민감한 데이터
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider must be overridden');
});

/// FlutterSecureStorage Provider
/// - 민감한 데이터(JWT 토큰, 사용자 인증 정보)를 암호화하여 저장
/// - iOS: Keychain 사용
/// - Android: Custom AES encryption (v10+, 자동 마이그레이션)
final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  const iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  const androidOptions = AndroidOptions();

  return const FlutterSecureStorage(
    iOptions: iosOptions,
    aOptions: androidOptions,
  );
});
