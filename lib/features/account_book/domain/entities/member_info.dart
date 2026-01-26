import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_info.freezed.dart';

@freezed
sealed class MemberInfo with _$MemberInfo {
  const factory MemberInfo({
    required String userId,
    required String nickname,
    required String email,
    required String role,
    required DateTime joinedAt,
  }) = _MemberInfo;
}
