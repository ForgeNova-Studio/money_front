import 'package:moamoa/features/account_book/domain/entities/account_book.dart';
import 'package:moamoa/features/account_book/domain/repositories/account_book_repository.dart';

class UpdateAccountBookUseCase {
  final AccountBookRepository _repository;

  UpdateAccountBookUseCase(this._repository);

  Future<AccountBook> call({
    required String accountBookId,
    required AccountBook accountBook,
  }) async {
    return _repository.updateAccountBook(
      accountBookId: accountBookId,
      accountBook: accountBook,
    );
  }
}
