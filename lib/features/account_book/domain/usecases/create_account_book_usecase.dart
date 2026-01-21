import 'package:moamoa/features/account_book/domain/entities/account_book.dart';
import 'package:moamoa/features/account_book/domain/repositories/account_book_repository.dart';

class CreateAccountBookUseCase {
  final AccountBookRepository _repository;

  CreateAccountBookUseCase(this._repository);

  Future<AccountBook> call({required AccountBook accountBook}) async {
    return await _repository.createAccountBook(accountBook: accountBook);
  }
}
