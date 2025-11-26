import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneyflow/features/auth/domain/entities/user.dart';

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
    );
  }
}
