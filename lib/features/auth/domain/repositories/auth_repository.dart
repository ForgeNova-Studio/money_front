// entities
import 'package:moneyflow/features/auth/domain/entities/auth_result.dart';
import 'package:moneyflow/features/auth/domain/entities/auth_token.dart';
import 'package:moneyflow/features/auth/domain/entities/user.dart';
import 'package:moneyflow/features/auth/domain/entities/gender.dart';

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
    required Gender gender,
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

  /// 회원가입 인증번호 전송
  /// [email] 사용자 이메일
  ///
  /// 6자리 인증번호를 이메일로 전송 (10분 유효)
  /// 이메일 중복 체크 포함 (이미 가입된 이메일이면 오류 반환)
  ///
  /// Throws:
  /// - [ValidationException] 이메일 형식 오류 또는 이미 가입된 이메일
  /// - [NetworkException] 네트워크 오류
  /// - [ServerException] 서버 오류
  Future<void> sendSignupCode(String email);

  /// 회원가입 인증번호 검증
  /// [email] 사용자 이메일
  /// [code] 6자리 인증번호
  ///
  /// Returns: true (검증 성공), false (검증 실패)
  ///
  /// Throws:
  /// - [ValidationException] 인증번호 불일치 또는 만료
  /// - [NetworkException] 네트워크 오류
  /// - [ServerException] 서버 오류
  Future<bool> verifySignupCode(String email, String code);

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
