import 'package:moamoa/features/account_book/domain/entities/account_book.dart';
import 'package:moamoa/features/account_book/domain/repositories/account_book_repository.dart';

class GetAccountBookDetailUseCase {
  final AccountBookRepository _repository;

  GetAccountBookDetailUseCase(this._repository);

  Future<AccountBook> call({required String accountBookId}) async {
    return await _repository.getAccountBook(accountBookId: accountBookId);
  }
}
