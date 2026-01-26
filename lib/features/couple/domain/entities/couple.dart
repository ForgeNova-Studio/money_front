/// 커플 정보 엔티티
class Couple {
  final String coupleId;
  final CoupleUser? user1;
  final CoupleUser? user2;
  final String? inviteCode;
  final DateTime? codeExpiresAt;
  final bool linked;
  final DateTime? linkedAt;
  final DateTime createdAt;

  Couple({
    required this.coupleId,
    this.user1,
    this.user2,
    this.inviteCode,
    this.codeExpiresAt,
    required this.linked,
    this.linkedAt,
    required this.createdAt,
  });

  /// 파트너 정보 가져오기 (현재 사용자 기준)
  CoupleUser? getPartner(String currentUserId) {
    if (user1?.userId == currentUserId) return user2;
    if (user2?.userId == currentUserId) return user1;
    return null;
  }
}

/// 커플 사용자 정보
class CoupleUser {
  final String userId;
  final String? nickname;
  final String? email;

  CoupleUser({
    required this.userId,
    this.nickname,
    this.email,
  });

  /// 표시할 이름 (닉네임 우선, 없으면 이메일)
  String get displayName => nickname ?? email ?? '사용자';
}

/// 초대 응답 엔티티
class InviteInfo {
  final String inviteCode;
  final DateTime expiresAt;
  final String? message;

  InviteInfo({
    required this.inviteCode,
    required this.expiresAt,
    this.message,
  });
}
