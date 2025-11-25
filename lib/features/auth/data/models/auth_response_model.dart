import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneyflow/features/auth/data/models/user_model.dart';
import 'package:moneyflow/features/auth/data/models/auth_token_model.dart';
import 'package:moneyflow/features/auth/domain/entities/auth_result.dart';

part 'auth_response_model.freezed.dart';
part 'auth_response_model.g.dart';

/// 로그인/회원가입 API 응답 Model
///
/// API 응답을 파싱하고 Domain AuthResult로 변환
@freezed
class AuthResponseModel with _$AuthResponseModel {
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

  /// Domain AuthResult로 변환
  AuthResult toEntity() {
    // Token Model 생성 후 Entity로 변환
    final tokenModel = AuthTokenModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
    );

    // User Model 생성 후 Entity로 변환
    // profile에 userId가 없을 수 있으므로 추가
    final profileWithUserId = Map<String, dynamic>.from(profile);
    if (!profileWithUserId.containsKey('userId')) {
      profileWithUserId['userId'] = userId;
    }

    final userModel = UserModel.fromJson(profileWithUserId);

    return AuthResult(
      user: userModel.toEntity(),
      token: tokenModel.toEntity(),
    );
  }
}
