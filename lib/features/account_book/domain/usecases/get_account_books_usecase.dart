import 'package:moamoa/features/account_book/domain/entities/account_book.dart';
import 'package:moamoa/features/account_book/domain/repositories/account_book_repository.dart';

class GetAccountBooksUseCase {
  final AccountBookRepository _repository;

  GetAccountBooksUseCase(this._repository);

  Future<List<AccountBook>> call() async {
    return await _repository.getAccountBooks();
  }
}
