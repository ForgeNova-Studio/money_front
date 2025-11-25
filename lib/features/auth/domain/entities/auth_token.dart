/// 순수 비즈니스 모델 (인증 토큰)
/// - 앱에서 사용자 인증을 위한 토큰 정보를 표현
/// - 토큰 만료 시간, 유효성 검사 등의 비즈니스 로직 포함
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
