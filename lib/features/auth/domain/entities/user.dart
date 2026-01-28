// entities
import 'package:moamoa/features/auth/domain/entities/gender.dart';

/// 순수 비즈니스 모델 (사용자)
/// - 앱에서 인증된 사용자 정보를 표현
/// - 비밀번호는 포함하지 않음
class User {
  final String userId;
  final String email;
  final String nickname;
  final Gender? gender;
  final DateTime? lastLoginAt;

  const User({
    required this.userId,
    required this.email,
    required this.nickname,
    this.gender,
    this.lastLoginAt,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          email == other.email &&
          nickname == other.nickname &&
          gender == other.gender &&
          lastLoginAt == other.lastLoginAt;

  @override
  int get hashCode =>
      userId.hashCode ^
      email.hashCode ^
      nickname.hashCode ^
      gender.hashCode ^
      lastLoginAt.hashCode;
}
