import 'user.dart';
import 'auth_token.dart';

/// 인증 결과 엔티티
///
/// 로그인 또는 회원가입 성공 시 반환되는 결과 데이터입니다.
/// 인증된 사용자 정보([User])와 발급된 토큰([AuthToken])을 포함합니다.
///
/// **주요 속성 (Properties):**
/// - [user]: 인증된 사용자 정보
/// - [token]: 발급된 인증 토큰 (Access/Refresh Token)
class AuthResult {
  final User user;
  final AuthToken token;

  const AuthResult({
    required this.user,
    required this.token,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthResult &&
          runtimeType == other.runtimeType &&
          user == other.user &&
          token == other.token;

  @override
  int get hashCode => user.hashCode ^ token.hashCode;

  @override
  String toString() => 'AuthResult(user: $user, token: $token)';
}
