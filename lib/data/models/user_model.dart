class UserModel {
  final String userId;
  final String email;
  final String nickname;
  final String? profileImageUrl;

  UserModel({
    required this.userId,
    required this.email,
    required this.nickname,
    this.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      email: json['email'],
      nickname: json['nickname'],
      profileImageUrl: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'nickname': nickname,
      'profileImage': profileImageUrl,
    };
  }
}
