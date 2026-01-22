// models
import 'package:moamoa/features/auth/data/models/models.dart';

/// Auth Local Data Source 인터페이스
///
/// 로컬 저장소 관리 계층
/// - FlutterSecureStorage 사용 (암호화된 안전한 저장소)
/// - 순수 Dart 인터페이스 (외부 패키지 의존 없음)
/// - Data Model 사용
abstract class AuthLocalDataSource {
  /// 토큰 저장
  ///
  /// [token] 저장할 토큰 모델
  ///
  /// Throws:
  /// - [StorageException] 저장소 오류
  Future<void> saveToken(AuthTokenModel token);

  /// 토큰 불러오기
  ///
  /// Returns: [AuthTokenModel] 또는 null (저장된 토큰이 없는 경우)
  ///
  /// Throws:
  /// - [StorageException] 저장소 오류
  Future<AuthTokenModel?> getToken();

  /// 토큰 삭제
  ///
  /// Throws:
  /// - [StorageException] 저장소 오류
  Future<void> deleteToken();

  /// 사용자 정보 저장
  ///
  /// [user] 저장할 사용자 모델
  ///
  /// Throws:
  /// - [StorageException] 저장소 오류
  Future<void> saveUser(UserModel user);

  /// 사용자 정보 불러오기
  ///
  /// Returns: [UserModel] 또는 null (저장된 사용자 정보가 없는 경우)
  ///
  /// Throws:
  /// - [StorageException] 저장소 오류
  Future<UserModel?> getUser();

  /// 사용자 정보 삭제
  ///
  /// Throws:
  /// - [StorageException] 저장소 오류
  Future<void> deleteUser();

  /// 모든 인증 데이터 삭제 (로그아웃 시 사용)
  ///
  /// Throws:
  /// - [StorageException] 저장소 오류
  Future<void> clearAll();

  /// 저장된 토큰이 있는지 확인
  ///
  /// Returns: true (토큰 있음), false (토큰 없음)
  Future<bool> hasToken();

  /// 마지막 로그인 방법 저장
  ///
  /// [provider] 로그인 방법 (GOOGLE, APPLE, NAVER, KAKAO, EMAIL)
  Future<void> saveLastLoginProvider(String provider);

  /// 마지막 로그인 방법 불러오기
  ///
  /// Returns: provider 문자열 또는 null
  Future<String?> getLastLoginProvider();
}
