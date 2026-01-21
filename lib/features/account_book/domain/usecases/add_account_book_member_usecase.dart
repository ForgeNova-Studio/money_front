import 'package:moamoa/features/account_book/domain/repositories/account_book_repository.dart';

class AddAccountBookMemberUseCase {
  final AccountBookRepository _repository;

  AddAccountBookMemberUseCase(this._repository);

  Future<void> call({
    required String accountBookId,
    required String newMemberId,
  }) async {
    await _repository.addMember(
      accountBookId: accountBookId,
      newMemberId: newMemberId,
    );
  }
}
