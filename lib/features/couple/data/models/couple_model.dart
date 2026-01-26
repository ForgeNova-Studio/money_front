import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moamoa/features/couple/domain/entities/couple.dart';

part 'couple_model.freezed.dart';
part 'couple_model.g.dart';

/// 커플 응답 모델
@freezed
sealed class CoupleModel with _$CoupleModel {
  const CoupleModel._();

  const factory CoupleModel({
    required String coupleId,
    CoupleUserModel? user1,
    CoupleUserModel? user2,
    String? inviteCode,
    DateTime? codeExpiresAt,
    required bool linked,
    DateTime? linkedAt,
    required DateTime createdAt,
  }) = _CoupleModel;

  factory CoupleModel.fromJson(Map<String, dynamic> json) =>
      _$CoupleModelFromJson(json);

  /// 도메인 엔티티로 변환
  Couple toEntity() => Couple(
        coupleId: coupleId,
        user1: user1?.toEntity(),
        user2: user2?.toEntity(),
        inviteCode: inviteCode,
        codeExpiresAt: codeExpiresAt,
        linked: linked,
        linkedAt: linkedAt,
        createdAt: createdAt,
      );
}

/// 커플 사용자 모델
@freezed
sealed class CoupleUserModel with _$CoupleUserModel {
  const CoupleUserModel._();

  const factory CoupleUserModel({
    required String userId,
    String? nickname,
    String? email,
  }) = _CoupleUserModel;

  factory CoupleUserModel.fromJson(Map<String, dynamic> json) =>
      _$CoupleUserModelFromJson(json);

  /// 도메인 엔티티로 변환
  CoupleUser toEntity() => CoupleUser(
        userId: userId,
        nickname: nickname,
        email: email,
      );
}

/// 초대 응답 모델
@freezed
sealed class InviteModel with _$InviteModel {
  const InviteModel._();

  const factory InviteModel({
    required String inviteCode,
    required DateTime expiresAt,
    String? message,
  }) = _InviteModel;

  factory InviteModel.fromJson(Map<String, dynamic> json) =>
      _$InviteModelFromJson(json);

  /// 도메인 엔티티로 변환
  InviteInfo toEntity() => InviteInfo(
        inviteCode: inviteCode,
        expiresAt: expiresAt,
        message: message,
      );
}

/// 커플 가입 요청 모델
@freezed
sealed class JoinCoupleRequest with _$JoinCoupleRequest {
  const factory JoinCoupleRequest({
    required String inviteCode,
  }) = _JoinCoupleRequest;

  factory JoinCoupleRequest.fromJson(Map<String, dynamic> json) =>
      _$JoinCoupleRequestFromJson(json);
}
