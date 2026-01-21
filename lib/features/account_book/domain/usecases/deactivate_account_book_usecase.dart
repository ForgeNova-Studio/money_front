import 'package:moamoa/features/account_book/domain/repositories/account_book_repository.dart';

class DeactivateAccountBookUseCase {
  final AccountBookRepository _repository;

  DeactivateAccountBookUseCase(this._repository);

  Future<void> call({required String accountBookId}) async {
    await _repository.deactivateAccountBook(accountBookId: accountBookId);
  }
}
