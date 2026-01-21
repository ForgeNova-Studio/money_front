// models
import 'package:moamoa/features/auth/data/models/models.dart';
import 'package:moamoa/features/auth/domain/entities/gender.dart';

/// Auth Remote Data Source 인터페이스
///
/// API 서버와 통신하는 계층
/// - 순수 Dart 인터페이스 (외부 패키지 의존 없음)
/// - Data Model 반환 (Domain Entity 아님)
/// - 구현체에서 예외 처리
abstract class AuthRemoteDataSource {
  /// 로그인 API 호출
  ///
  /// [email] 사용자 이메일
  /// [password] 사용자 비밀번호
  ///
  /// Returns: [AuthResponseModel] API 응답 모델
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [UnauthorizedException] 인증 실패
  /// - [ServerException] 서버 오류
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  /// 회원가입 API 호출
  ///
  /// [email] 사용자 이메일
  /// [password] 사용자 비밀번호
  /// [nickname] 사용자 닉네임
  ///
  /// Returns: [RegisterResponseModel] 회원가입 API 응답 모델 (토큰만 포함)
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [ValidationException] 입력값 검증 오류
  /// - [ServerException] 서버 오류
  Future<RegisterResponseModel> register({
    required String email,
    required String password,
    required String nickname,
    required Gender gender,
  });

  /// 현재 사용자 정보 조회
  ///
  /// Returns: [UserModel] 사용자 정보 모델
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [TokenExpiredException] 토큰 만료
  /// - [ServerException] 서버 오류
  Future<UserModel> getCurrentUser();

  /// 토큰 갱신
  ///
  /// [refreshToken] Refresh Token
  ///
  /// Returns: [AuthTokenModel] 새로운 토큰 모델
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [TokenExpiredException] Refresh Token 만료
  /// - [ServerException] 서버 오류
  Future<AuthTokenModel> refreshToken(String refreshToken);

  /// 회원가입 인증번호 전송
  ///
  /// [email] 사용자 이메일
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [ValidationException] 이메일 형식 오류 또는 이미 가입된 이메일
  /// - [ServerException] 서버 오류
  Future<void> sendSignupCode(String email);

  /// 회원가입 인증번호 검증
  ///
  /// [email] 사용자 이메일
  /// [code] 6자리 인증번호
  ///
  /// Returns: true (검증 성공), false (검증 실패)
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [ValidationException] 인증번호 불일치 또는 만료
  /// - [ServerException] 서버 오류
  Future<bool> verifySignupCode(String email, String code);

  /// 소셜 로그인 API 호출 (통합 엔드포인트)
  ///
  /// [provider] 소셜 로그인 제공자 (GOOGLE, APPLE 등)
  /// [idToken] 소셜 로그인 ID Token
  /// [nickname] 사용자 닉네임
  ///
  /// Returns: [AuthResponseModel] API 응답 모델
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [UnauthorizedException] 소셜 인증 실패
  /// - [ServerException] 서버 오류
  Future<AuthResponseModel> socialLogin({
    required String provider,
    required String idToken,
    required String nickname,
  });

  /// 비밀번호 재설정 인증번호 전송
  ///
  /// [email] 사용자 이메일
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [ValidationException] 가입되지 않은 이메일 또는 소셜 로그인 사용자
  /// - [ServerException] 서버 오류
  Future<void> sendPasswordResetCode(String email);

  /// 비밀번호 재설정 인증번호 검증
  ///
  /// [email] 사용자 이메일
  /// [code] 6자리 인증번호
  ///
  /// Returns: true (검증 성공), false (검증 실패)
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [ValidationException] 인증번호 불일치, 만료, 또는 소셜 로그인 사용자
  /// - [ServerException] 서버 오류
  Future<bool> verifyPasswordResetCode(String email, String code);

  /// 비밀번호 재설정
  ///
  /// [email] 사용자 이메일
  /// [newPassword] 새로운 비밀번호
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [ValidationException] 인증번호 불일치, 만료, 또는 소셜 로그인 사용자
  /// - [ServerException] 서버 오류
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  });

  /// 로그아웃
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [TokenExpiredException] 토큰 만료
  /// - [ServerException] 서버 오류
  Future<void> logout(String refreshToken);
}
