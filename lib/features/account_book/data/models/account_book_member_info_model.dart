import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:moamoa/features/account_book/domain/entities/member_info.dart';

part 'account_book_member_info_model.g.dart';
part 'account_book_member_info_model.freezed.dart';

@freezed
sealed class AccountBookMemberInfoModel with _$AccountBookMemberInfoModel {
  const AccountBookMemberInfoModel._();

  const factory AccountBookMemberInfoModel({
    required String userId,
    required String nickname,
    required String email,
    required String role,
    required DateTime joinedAt,
  }) = _AccountBookMemberInfoModel;

  factory AccountBookMemberInfoModel.fromJson(Map<String, dynamic> json) =>
      _$AccountBookMemberInfoModelFromJson(json);

  MemberInfo toEntity() {
    return MemberInfo(
      userId: userId,
      nickname: nickname,
      email: email,
      role: role,
      joinedAt: joinedAt,
    );
  }

  factory AccountBookMemberInfoModel.fromEntity(MemberInfo memberInfo) {
    return AccountBookMemberInfoModel(
      userId: memberInfo.userId,
      nickname: memberInfo.nickname,
      email: memberInfo.email,
      role: memberInfo.role,
      joinedAt: memberInfo.joinedAt,
    );
  }
}
