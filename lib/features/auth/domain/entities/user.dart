/// 순수 비즈니스 모델 (사용자)
/// - 앱에서 인증된 사용자 정보를 표현
/// - 비밀번호는 포함하지 않음
class User {
  final String userId;
  final String email;
  final String nickname;
  final DateTime? lastLoginAt;

  const User(
      {required this.userId,
      required this.email,
      required this.nickname,
      this.lastLoginAt});
}
