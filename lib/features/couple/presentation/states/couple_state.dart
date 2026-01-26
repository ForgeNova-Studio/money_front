import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moamoa/features/couple/domain/entities/couple.dart';

part 'couple_state.freezed.dart';

/// 커플 화면 상태
@freezed
sealed class CoupleState with _$CoupleState {
  const CoupleState._();

  const factory CoupleState({
    Couple? couple,
    InviteInfo? inviteInfo,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _CoupleState;

  /// 커플 연동 여부
  bool get isLinked => couple?.linked ?? false;

  /// 초대 코드 유효 여부
  bool get hasValidInviteCode {
    if (inviteInfo == null) return false;
    return inviteInfo!.expiresAt.isAfter(DateTime.now());
  }
}
