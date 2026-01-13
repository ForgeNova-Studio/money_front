import 'package:moneyflow/features/account_book/data/datasources/account_book_remote_datasource.dart';
import 'package:moneyflow/features/account_book/data/models/account_book_model.dart';
import 'package:moneyflow/features/account_book/domain/entities/account_book.dart';
import 'package:moneyflow/features/account_book/domain/entities/member_info.dart';
import 'package:moneyflow/features/account_book/domain/repositories/account_book_repository.dart';

class AccountBookRepositoryImpl implements AccountBookRepository {
  final AccountBookRemoteDataSource _remoteDataSource;

  AccountBookRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<AccountBook>> getAccountBooks() async {
    final response = await _remoteDataSource.getAccountBooks();
    return response.map((model) => model.toEntity()).toList();
  }

  @override
  Future<AccountBook> getAccountBook({required String accountBookId}) async {
    final model =
        await _remoteDataSource.getAccountBook(accountBookId: accountBookId);
    return model.toEntity();
  }

  @override
  Future<AccountBook> createAccountBook({
    required AccountBook accountBook,
  }) async {
    final model = AccountBookModel.fromEntity(accountBook);
    final response =
        await _remoteDataSource.createAccountBook(accountBook: model);
    return response.toEntity();
  }

  @override
  Future<List<MemberInfo>> getMembers({required String accountBookId}) async {
    final response =
        await _remoteDataSource.getMembers(accountBookId: accountBookId);
    return response.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addMember({
    required String accountBookId,
    required String newMemberId,
  }) async {
    await _remoteDataSource.addMember(
      accountBookId: accountBookId,
      newMemberId: newMemberId,
    );
  }

  @override
  Future<void> deactivateAccountBook({required String accountBookId}) async {
    await _remoteDataSource.deactivateAccountBook(
      accountBookId: accountBookId,
    );
  }
}
