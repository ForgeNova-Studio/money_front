// packages
import 'package:freezed_annotation/freezed_annotation.dart';

// entities
import 'package:moamoa/features/auth/domain/entities/user.dart';
import 'package:moamoa/features/auth/domain/entities/gender.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User Data Model
///
/// API 응답 및 로컬 저장소 데이터를 처리하는 모델
/// Domain Entity로 변환하는 역할
@freezed
sealed class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String userId,
    required String email,
    required String nickname,
    String? profileImageUrl,
    @GenderConverter() Gender? gender,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  // toJson은 자동 생성

  // ✅ 커스텀 메서드들은 그대로 유지
  /// Domain Entity로 변환
  User toEntity() {
    return User(
      userId: userId,
      email: email,
      nickname: nickname,
      gender: gender,
      lastLoginAt: null,
    );
  }

  /// Domain Entity로부터 생성
  factory UserModel.fromEntity(User user) {
    return UserModel(
      userId: user.userId,
      email: user.email,
      nickname: user.nickname,
      profileImageUrl: null,
      gender: user.gender,
    );
  }
}

/// Gender enum <-> String 변환을 위한 JsonConverter
class GenderConverter implements JsonConverter<Gender?, String?> {
  const GenderConverter();

  @override
  Gender? fromJson(String? json) {
    if (json == null) return null;
    switch (json.toUpperCase()) {
      case 'MALE':
        return Gender.male;
      case 'FEMALE':
        return Gender.female;
      case 'OTHER':
        return Gender.other;
      default:
        return null;
    }
  }

  @override
  String? toJson(Gender? gender) {
    return gender?.toServerString();
  }
}
