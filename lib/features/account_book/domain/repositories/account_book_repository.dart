import 'package:moamoa/features/account_book/domain/entities/account_book.dart';
import 'package:moamoa/features/account_book/domain/entities/member_info.dart';

abstract class AccountBookRepository {
  Future<List<AccountBook>> getAccountBooks();

  Future<AccountBook> getAccountBook({required String accountBookId});

  Future<AccountBook> createAccountBook({required AccountBook accountBook});

  Future<AccountBook> updateAccountBook({
    required String accountBookId,
    required AccountBook accountBook,
  });

  Future<List<MemberInfo>> getMembers({required String accountBookId});

  Future<void> addMember({
    required String accountBookId,
    required String newMemberId,
  });

  Future<void> deactivateAccountBook({required String accountBookId});
}
