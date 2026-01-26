import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moamoa/features/account_book/domain/entities/book_type.dart';
import 'package:moamoa/features/account_book/domain/entities/member_info.dart';

part 'account_book.freezed.dart';

@freezed
sealed class AccountBook with _$AccountBook {
  const factory AccountBook({
    String? accountBookId,
    required String name,
    required BookType bookType,
    String? coupleId,
    int? memberCount,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    DateTime? createdAt,
    List<MemberInfo>? members,
  }) = _AccountBook;
}
