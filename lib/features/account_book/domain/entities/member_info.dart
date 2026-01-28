class MemberInfo {
  final String userId;
  final String nickname;
  final String email;
  final String role;
  final DateTime joinedAt;

  const MemberInfo({
    required this.userId,
    required this.nickname,
    required this.email,
    required this.role,
    required this.joinedAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MemberInfo &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          nickname == other.nickname &&
          email == other.email &&
          role == other.role &&
          joinedAt == other.joinedAt;

  @override
  int get hashCode =>
      userId.hashCode ^
      nickname.hashCode ^
      email.hashCode ^
      role.hashCode ^
      joinedAt.hashCode;
}
