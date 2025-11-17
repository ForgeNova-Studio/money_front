/// 커플 정보 모델
class CoupleModel {
  final String coupleId;
  final UserInfo user1;
  final UserInfo? user2;
  final String? inviteCode;
  final DateTime? codeExpiresAt;
  final bool linked;
  final DateTime? linkedAt;
  final DateTime createdAt;

  CoupleModel({
    required this.coupleId,
    required this.user1,
    this.user2,
    this.inviteCode,
    this.codeExpiresAt,
    required this.linked,
    this.linkedAt,
    required this.createdAt,
  });

  factory CoupleModel.fromJson(Map<String, dynamic> json) {
    return CoupleModel(
      coupleId: json['coupleId'],
      user1: UserInfo.fromJson(json['user1']),
      user2: json['user2'] != null ? UserInfo.fromJson(json['user2']) : null,
      inviteCode: json['inviteCode'],
      codeExpiresAt: json['codeExpiresAt'] != null
          ? DateTime.parse(json['codeExpiresAt'])
          : null,
      linked: json['linked'],
      linkedAt:
          json['linkedAt'] != null ? DateTime.parse(json['linkedAt']) : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coupleId': coupleId,
      'user1': user1.toJson(),
      'user2': user2?.toJson(),
      'inviteCode': inviteCode,
      'codeExpiresAt': codeExpiresAt?.toIso8601String(),
      'linked': linked,
      'linkedAt': linkedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

/// 사용자 정보 (간략)
class UserInfo {
  final String userId;
  final String nickname;
  final String email;

  UserInfo({
    required this.userId,
    required this.nickname,
    required this.email,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userId: json['userId'],
      nickname: json['nickname'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'nickname': nickname,
      'email': email,
    };
  }
}

/// 초대 응답 모델
class InviteResponse {
  final String inviteCode;
  final DateTime expiresAt;
  final String message;

  InviteResponse({
    required this.inviteCode,
    required this.expiresAt,
    required this.message,
  });

  factory InviteResponse.fromJson(Map<String, dynamic> json) {
    return InviteResponse(
      inviteCode: json['inviteCode'],
      expiresAt: DateTime.parse(json['expiresAt']),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inviteCode': inviteCode,
      'expiresAt': expiresAt.toIso8601String(),
      'message': message,
    };
  }
}
