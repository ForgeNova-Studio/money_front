import 'user.dart';
import 'auth_token.dart';

/// 인증 결과
///
/// 로그인 또는 회원가입 성공 시 반환되는 결과
/// User 정보와 AuthToken을 함께 포함
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
