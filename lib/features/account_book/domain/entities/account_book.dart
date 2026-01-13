import 'package:moneyflow/features/account_book/domain/entities/book_type.dart';
import 'package:moneyflow/features/account_book/domain/entities/member_info.dart';

class AccountBook {
  final String? accountBookId;
  final String name;
  final BookType bookType;
  final String? coupleId;
  final int? memberCount;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool? isActive;
  final DateTime? createdAt;
  final List<MemberInfo>? members;

  AccountBook({
    this.accountBookId,
    required this.name,
    required this.bookType,
    this.coupleId,
    this.memberCount,
    this.description,
    this.startDate,
    this.endDate,
    this.isActive,
    this.createdAt,
    this.members,
  });
}
