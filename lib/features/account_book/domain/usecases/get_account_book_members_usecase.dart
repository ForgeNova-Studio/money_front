import 'package:moamoa/features/account_book/domain/entities/member_info.dart';
import 'package:moamoa/features/account_book/domain/repositories/account_book_repository.dart';

class GetAccountBookMembersUseCase {
  final AccountBookRepository _repository;

  GetAccountBookMembersUseCase(this._repository);

  Future<List<MemberInfo>> call({required String accountBookId}) async {
    return await _repository.getMembers(accountBookId: accountBookId);
  }
}
