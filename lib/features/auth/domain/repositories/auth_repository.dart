// entities
import 'package:moneyflow/features/auth/domain/entities/auth_result.dart';
import 'package:moneyflow/features/auth/domain/entities/auth_token.dart';
import 'package:moneyflow/features/auth/domain/entities/user.dart';

/// Auth Repository 인터페이스
///
/// 인증 관련 비즈니스 로직의 추상화 계층
/// Data Layer에서 이 인터페이스를 구현
///
/// Exception 처리:
/// - NetworkException: 네트워크 연결 오류
/// - UnauthorizedException: 인증 실패 (잘못된 이메일/비밀번호)
/// - ValidationException: 입력값 검증 오류
/// - ServerException: 서버 오류 (500번대)
/// - TokenExpiredException: 토큰 만료
abstract class AuthRepository {
  /// 로그인
  /// [email] 사용자 이메일
  /// [password] 사용자 비밀번호
  ///
  /// Returns: [AuthResult] (User + AuthToken)
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [UnauthorizedException] 잘못된 이메일/비밀번호
  /// - [ServerException] 서버 오류
  Future<AuthResult> login({
    required String email,
    required String password,
  });

  /// 회원가입
  /// [email] 사용자 이메일
  /// [password] 사용자 비밀번호
  /// [nickname] 사용자 닉네임
  ///
  /// Returns: [AuthResult] (User + AuthToken)
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [ValidationException] 입력값 검증 오류 (이메일 중복 등)
  /// - [ServerException] 서버 오류
  Future<AuthResult> register({
    required String email,
    required String password,
    required String nickname,
  });

  /// 로그아웃
  /// 저장된 토큰과 사용자 정보를 삭제
  ///
  /// Throws:
  /// - [StorageException] 로컬 저장소 오류
  Future<void> logout();

  /// 토큰 갱신
  /// [refreshToken] Refresh Token
  ///
  /// Returns: [AuthToken] 새로운 Access Token과 Refresh Token
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [TokenExpiredException] Refresh Token 만료
  /// - [ServerException] 서버 오류
  Future<AuthToken> refreshToken(String refreshToken);

  /// 현재 로그인한 사용자 정보 조회
  ///
  /// Returns: [User] 또는 null (로그인하지 않은 경우)
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [TokenExpiredException] 토큰 만료
  /// - [ServerException] 서버 오류
  Future<User?> getCurrentUser();

  /// 로컬에 저장된 토큰 조회
  ///
  /// Returns: [AuthToken] 또는 null (저장된 토큰이 없는 경우)
  ///
  /// Throws:
  /// - [StorageException] 로컬 저장소 오류
  Future<AuthToken?> getStoredToken();

  /// 토큰을 로컬에 저장
  /// [token] 저장할 토큰
  ///
  /// Throws:
  /// - [StorageException] 로컬 저장소 오류
  Future<void> saveToken(AuthToken token);

  /// 이메일 중복 확인
  /// [email] 확인할 이메일
  ///
  /// Returns: true (중복), false (사용 가능)
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [ServerException] 서버 오류
  Future<bool> checkEmailDuplicate(String email);

  /// Google 로그인
  /// [idToken] Google ID Token
  /// [nickname] 사용자 닉네임 (선택)
  ///
  /// Returns: [AuthResult] (User + AuthToken)
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [UnauthorizedException] Google 인증 실패
  /// - [ServerException] 서버 오류
  Future<AuthResult> loginWithGoogle({
    required String idToken,
    String? nickname,
  });

  /// Apple 로그인
  /// [authorizationCode] Apple Authorization Code
  /// [nickname] 사용자 닉네임 (선택)
  ///
  /// Returns: [AuthResult] (User + AuthToken)
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [UnauthorizedException] Apple 인증 실패
  /// - [ServerException] 서버 오류
  Future<AuthResult> loginWithApple({
    required String authorizationCode,
    String? nickname,
  });
}
