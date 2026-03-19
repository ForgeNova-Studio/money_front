// packages
import 'package:freezed_annotation/freezed_annotation.dart';

// models
import 'package:moamoa/features/auth/data/models/models.dart';

// entities
import 'package:moamoa/features/auth/domain/entities/auth_result.dart';

part 'auth_response_model.freezed.dart';
part 'auth_response_model.g.dart';

/// 로그인/회원가입 API 응답 Model
///
/// API 응답을 파싱하고 Domain AuthResult로 변환
@freezed
sealed class AuthResponseModel with _$AuthResponseModel {
  const AuthResponseModel._();

  const factory AuthResponseModel({
    required String accessToken,
    required String refreshToken,
    String? expiresIn,
    required String userId,
    required Map<String, dynamic> profile,
  }) = _AuthResponseModel;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  /// 로그인 응답의 프로필 스키마를 앱 내부 표준으로 정규화
  /// - `profile.userId` 누락 시 응답 루트의 `userId`를 주입
  /// - 레거시 키 `profileImage`를 `profileImageUrl`로 매핑
  Map<String, dynamic> toNormalizedProfileJson() {
    final normalized = Map<String, dynamic>.from(profile);

    if (!normalized.containsKey('userId')) {
      normalized['userId'] = userId;
    }

    final legacyProfileImage = normalized['profileImage'];
    if (!normalized.containsKey('profileImageUrl') &&
        legacyProfileImage is String &&
        legacyProfileImage.isNotEmpty) {
      normalized['profileImageUrl'] = legacyProfileImage;
    }

    return normalized;
  }

  /// Domain AuthResult로 변환
  AuthResult toEntity() {
    // Token Model 생성 후 Entity로 변환
    final tokenModel = AuthTokenModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
    );

    // User Model 생성 후 Entity로 변환
    final profileWithUserId = toNormalizedProfileJson();

    final userModel = UserModel.fromJson(profileWithUserId);

    return AuthResult(
      user: userModel.toEntity(),
      token: tokenModel.toEntity(),
    );
  }
}
