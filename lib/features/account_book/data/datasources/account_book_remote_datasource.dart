import 'package:moamoa/features/account_book/data/models/account_book_member_info_model.dart';
import 'package:moamoa/features/account_book/data/models/account_book_model.dart';

abstract class AccountBookRemoteDataSource {
  Future<List<AccountBookModel>> getAccountBooks();

  Future<AccountBookModel> getAccountBook({required String accountBookId});

  Future<AccountBookModel> createAccountBook({
    required AccountBookModel accountBook,
  });

  Future<AccountBookModel> updateAccountBook({
    required String accountBookId,
    required AccountBookModel accountBook,
  });

  Future<List<AccountBookMemberInfoModel>> getMembers({
    required String accountBookId,
  });

  Future<void> addMember({
    required String accountBookId,
    required String newMemberId,
  });

  Future<void> deactivateAccountBook({required String accountBookId});
}
