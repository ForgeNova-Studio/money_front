// packages
import 'package:freezed_annotation/freezed_annotation.dart';

// entities
import 'package:moneyflow/features/auth/domain/entities/auth_token.dart';

part 'auth_token_model.freezed.dart';
part 'auth_token_model.g.dart';

/// AuthToken Data Model
///
/// API 응답 및 로컬 저장소의 토큰 데이터를 처리하는 모델
/// Domain Entity로 변환하는 역할
@freezed
sealed class AuthTokenModel with _$AuthTokenModel {
  const AuthTokenModel._();

  const factory AuthTokenModel({
    required String accessToken,
    required String refreshToken,
    String? expiresIn, // API 응답용 (초단위 문자열)
    DateTime? expiresAt, // Storage 저장용 (DateTime)
  }) = _AuthTokenModel;

  /// API 응답에서 생성
  factory AuthTokenModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenModelFromJson(json);

  /// Storage에서 불러올 때
  factory AuthTokenModel.fromStorage(Map<String, dynamic> json) {
    DateTime? expiresAt;
    if (json['expiresAt'] != null) {
      try {
        expiresAt = DateTime.parse(json['expiresAt'] as String);
      } catch (e) {
        expiresAt = null;
      }
    }

    return AuthTokenModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: expiresAt,
    );
  }

  /// Domain Entity로 변환
  AuthToken toEntity() {
    // expiresAt가 있으면 사용 (Storage에서 온 경우)
    // 없으면 expiresIn으로 계산 (API에서 온 경우)
    DateTime? finalExpiresAt = expiresAt;

    if (finalExpiresAt == null && expiresIn != null && expiresIn!.isNotEmpty) {
      try {
        final seconds = int.parse(expiresIn!);
        finalExpiresAt = DateTime.now().add(Duration(seconds: seconds));
      } catch (e) {
        finalExpiresAt = null;
      }
    }

    return AuthToken(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresAt: finalExpiresAt,
    );
  }

  /// Domain Entity로부터 생성 (Storage 저장용)
  factory AuthTokenModel.fromEntity(AuthToken token) {
    return AuthTokenModel(
      accessToken: token.accessToken,
      refreshToken: token.refreshToken,
      expiresAt: token.expiresAt, // DateTime 그대로 저장
    );
  }
}
