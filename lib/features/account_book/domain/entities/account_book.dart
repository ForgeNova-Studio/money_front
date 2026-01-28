import 'package:flutter/foundation.dart';
import 'package:moamoa/features/account_book/domain/entities/book_type.dart';
import 'package:moamoa/features/account_book/domain/entities/member_info.dart';

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

  const AccountBook({
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

  AccountBook copyWith({
    String? accountBookId,
    String? name,
    BookType? bookType,
    String? coupleId,
    int? memberCount,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    DateTime? createdAt,
    List<MemberInfo>? members,
  }) {
    return AccountBook(
      accountBookId: accountBookId ?? this.accountBookId,
      name: name ?? this.name,
      bookType: bookType ?? this.bookType,
      coupleId: coupleId ?? this.coupleId,
      memberCount: memberCount ?? this.memberCount,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      members: members ?? this.members,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountBook &&
          runtimeType == other.runtimeType &&
          accountBookId == other.accountBookId &&
          name == other.name &&
          bookType == other.bookType &&
          coupleId == other.coupleId &&
          memberCount == other.memberCount &&
          description == other.description &&
          startDate == other.startDate &&
          endDate == other.endDate &&
          isActive == other.isActive &&
          createdAt == other.createdAt &&
          listEquals(members, other.members);

  @override
  int get hashCode =>
      accountBookId.hashCode ^
      name.hashCode ^
      bookType.hashCode ^
      coupleId.hashCode ^
      memberCount.hashCode ^
      description.hashCode ^
      startDate.hashCode ^
      endDate.hashCode ^
      isActive.hashCode ^
      createdAt.hashCode ^
      Object.hashAll(members ?? []);
}
