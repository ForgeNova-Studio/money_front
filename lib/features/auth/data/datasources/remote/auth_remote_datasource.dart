import '../../models/models.dart';

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
  /// Returns: [AuthResponseModel] API 응답 모델
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [ValidationException] 입력값 검증 오류
  /// - [ServerException] 서버 오류
  Future<AuthResponseModel> register({
    required String email,
    required String password,
    required String nickname,
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

  /// 이메일 중복 확인
  ///
  /// [email] 확인할 이메일
  ///
  /// Returns: true (중복), false (사용 가능)
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [ServerException] 서버 오류
  Future<bool> checkEmailDuplicate(String email);
}
