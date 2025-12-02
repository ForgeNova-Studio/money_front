// packages
import 'package:freezed_annotation/freezed_annotation.dart';

// models
import 'package:moneyflow/features/auth/data/models/models.dart';

// entities
import 'package:moneyflow/features/auth/domain/entities/auth_result.dart';
import 'package:moneyflow/features/auth/domain/entities/user.dart';

part 'register_response_model.freezed.dart';
part 'register_response_model.g.dart';

/// 회원가입 API 응답 Model
///
/// 회원가입은 토큰만 반환 (사용자 정보는 클라이언트가 이미 알고 있음)
@freezed
sealed class RegisterResponseModel with _$RegisterResponseModel {
  const RegisterResponseModel._();

  const factory RegisterResponseModel({
    required String accessToken,
    required String refreshToken,
    String? expiresIn,
    required String userId,
  }) = _RegisterResponseModel;

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseModelFromJson(json);

  /// Domain AuthResult로 변환
  /// email, nickname은 회원가입 시 사용한 값을 매개변수로 받음
  AuthResult toEntity({
    required String email,
    required String nickname,
  }) {
    // Token Model 생성 후 Entity로 변환
    final tokenModel = AuthTokenModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
    );

    // User Entity 생성 (회원가입 시 입력한 정보 사용)
    final user = User(
      userId: userId,
      email: email,
      nickname: nickname,
      lastLoginAt: DateTime.now(),
    );

    return AuthResult(
      user: user,
      token: tokenModel.toEntity(),
    );
  }
}
