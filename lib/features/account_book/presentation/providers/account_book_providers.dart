// datasources
import 'package:moamoa/features/account_book/data/datasources/account_book_remote_datasource.dart';
import 'package:moamoa/features/account_book/data/datasources/account_book_remote_datasource_impl.dart';

// repositories
import 'package:moamoa/features/account_book/data/repositories/account_book_repository_impl.dart';
import 'package:moamoa/features/account_book/domain/repositories/account_book_repository.dart';

// entities
import 'package:moamoa/features/account_book/domain/entities/account_book.dart';

// usecases
import 'package:moamoa/features/account_book/domain/usecases/add_account_book_member_usecase.dart';
import 'package:moamoa/features/account_book/domain/usecases/create_account_book_usecase.dart';
import 'package:moamoa/features/account_book/domain/usecases/deactivate_account_book_usecase.dart';
import 'package:moamoa/features/account_book/domain/usecases/get_account_book_detail_usecase.dart';
import 'package:moamoa/features/account_book/domain/usecases/get_account_book_members_usecase.dart';
import 'package:moamoa/features/account_book/domain/usecases/get_account_books_usecase.dart';

// packages
import 'package:riverpod_annotation/riverpod_annotation.dart';

// providers
import 'package:moamoa/features/common/providers/core_providers.dart';
import 'package:moamoa/features/auth/presentation/viewmodels/auth_view_model.dart';

part 'account_book_providers.g.dart';

// ============================================================================
// DataSource Providers
// ============================================================================
@riverpod
AccountBookRemoteDataSource accountBookRemoteDataSource(Ref ref) {
  return AccountBookRemoteDataSourceImpl(dio: ref.read(dioProvider));
}

// ============================================================================
// Repository Provider
// ============================================================================
@riverpod
AccountBookRepository accountBookRepository(Ref ref) {
  return AccountBookRepositoryImpl(
      ref.read(accountBookRemoteDataSourceProvider));
}

// ============================================================================
// UseCase Providers
// ============================================================================
@riverpod
GetAccountBooksUseCase getAccountBooksUseCase(Ref ref) {
  return GetAccountBooksUseCase(ref.read(accountBookRepositoryProvider));
}

@riverpod
GetAccountBookDetailUseCase getAccountBookDetailUseCase(Ref ref) {
  return GetAccountBookDetailUseCase(ref.read(accountBookRepositoryProvider));
}

@riverpod
CreateAccountBookUseCase createAccountBookUseCase(Ref ref) {
  return CreateAccountBookUseCase(ref.read(accountBookRepositoryProvider));
}

@riverpod
GetAccountBookMembersUseCase getAccountBookMembersUseCase(Ref ref) {
  return GetAccountBookMembersUseCase(ref.read(accountBookRepositoryProvider));
}

@riverpod
AddAccountBookMemberUseCase addAccountBookMemberUseCase(Ref ref) {
  return AddAccountBookMemberUseCase(ref.read(accountBookRepositoryProvider));
}

@riverpod
DeactivateAccountBookUseCase deactivateAccountBookUseCase(Ref ref) {
  return DeactivateAccountBookUseCase(ref.read(accountBookRepositoryProvider));
}

@riverpod
Future<List<AccountBook>> accountBooks(Ref ref) async {
  return ref.read(getAccountBooksUseCaseProvider).call();
}

@riverpod
Future<AccountBook> accountBookDetail(Ref ref, String accountBookId) async {
  final userId = ref.read(authViewModelProvider).user?.userId;
  if (userId == null) throw Exception('User not logged in');

  return ref.read(getAccountBookDetailUseCaseProvider).call(
        accountBookId: accountBookId,
      );
}
