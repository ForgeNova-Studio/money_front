class MemberInfo {
  final String userId;
  final String nickname;
  final String email;
  final String role;
  final DateTime joinedAt;

  MemberInfo({
    required this.userId,
    required this.nickname,
    required this.email,
    required this.role,
    required this.joinedAt,
  });
}
