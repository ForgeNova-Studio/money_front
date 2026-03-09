// entities
import 'package:moamoa/features/auth/domain/entities/gender.dart';

/// 사용자 엔티티
///
/// 앱 내에서 인증된 사용자의 핵심 정보를 담고 있는 순수 비즈니스 모델입니다.
/// 보안을 위해 비밀번호와 같은 민감한 정보는 포함하지 않습니다.
///
/// **주요 속성 (Properties):**
/// - [userId]: 사용자 고유 식별자
/// - [email]: 이메일 주소
/// - [nickname]: 표시 이름 (닉네임)
/// - [gender]: 성별 ([Gender])
/// - [lastLoginAt]: 마지막 로그인 시각
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
