import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moneyflow/features/account_book/data/models/account_book_member_info_model.dart';
import 'package:moneyflow/features/account_book/domain/entities/account_book.dart';
import 'package:moneyflow/features/account_book/domain/entities/book_type.dart';


part 'account_book_model.g.dart';
part 'account_book_model.freezed.dart';

@freezed
sealed class AccountBookModel with _$AccountBookModel {
  const AccountBookModel._();

  const factory AccountBookModel({
    String? accountBookId,
    required String name,
    required String bookType,
    String? coupleId,
    int? memberCount,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    DateTime? createdAt,
    List<AccountBookMemberInfoModel>? members,
  }) = _AccountBookModel;

  factory AccountBookModel.fromJson(Map<String, dynamic> json) =>
      _$AccountBookModelFromJson(json);

  AccountBook toEntity() {
    return AccountBook(
      accountBookId: accountBookId,
      name: name,
      bookType: BookType.fromCode(bookType),
      coupleId: coupleId,
      memberCount: memberCount,
      description: description,
      startDate: startDate,
      endDate: endDate,
      isActive: isActive,
      createdAt: createdAt,
      members: members?.map((member) => member.toEntity()).toList(),
    );
  }

  factory AccountBookModel.fromEntity(AccountBook accountBook) {
    return AccountBookModel(
      accountBookId: accountBook.accountBookId,
      name: accountBook.name,
      bookType: accountBook.bookType.code,
      coupleId: accountBook.coupleId,
      memberCount: accountBook.memberCount,
      description: accountBook.description,
      startDate: accountBook.startDate,
      endDate: accountBook.endDate,
      isActive: accountBook.isActive,
      createdAt: accountBook.createdAt,
      members: accountBook.members
          ?.map(AccountBookMemberInfoModel.fromEntity)
          .toList(),
    );
  }
}
