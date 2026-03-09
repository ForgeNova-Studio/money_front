/// 인증 토큰 엔티티
///
/// 서버로부터 발급받은 인증 토큰 정보를 관리하는 순수 비즈니스 모델입니다.
/// Access Token, Refresh Token 및 만료 시간을 포함하며, 토큰의 유효성 검사 로직을 제공합니다.
///
/// **주요 속성 (Properties):**
/// - [accessToken]: API 요청 인증에 사용되는 토큰
/// - [refreshToken]: Access Token 갱신에 사용되는 토큰
/// - [expiresAt]: Access Token 만료 시간
///
/// **주요 기능 (Key Features):**
/// - 토큰 만료 여부 확인 (`isExpired`)
/// - 토큰 만료 임박 확인 (`isExpiredSoon` - 5분 전)
/// - 토큰 유효성 종합 검사 (`isValid`)
class AuthToken {
  final String accessToken;
  final String refreshToken;
  final DateTime? expiresAt;

  const AuthToken({
    required this.accessToken,
    required this.refreshToken,
    this.expiresAt,
  });

  // 토큰 만료 체크
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  // 토큰이 곧 만료 체크(5분)
  bool get isExpiredSoon {
    if (expiresAt == null) return false;
    final fiveMinutesFromNow = DateTime.now().add(const Duration(minutes: 5));
    return fiveMinutesFromNow.isAfter(expiresAt!);
  }

  // 유효한 토큰인지 확인
  bool get isValid => accessToken.isNotEmpty && !isExpired;

  // Equatable을 위한 props (선택사항)
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthToken &&
          runtimeType == other.runtimeType &&
          accessToken == other.accessToken &&
          refreshToken == other.refreshToken;

  @override
  int get hashCode => accessToken.hashCode ^ refreshToken.hashCode;
}
