import 'package:moamoa/features/home/domain/entities/transaction_entity.dart';
import 'package:moamoa/features/search/data/datasources/remote/search_remote_datasource.dart';
import 'package:moamoa/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource _remoteDataSource;

  SearchRepositoryImpl(this._remoteDataSource);

  @override
  Future<({List<TransactionEntity> transactions, int totalCount, bool hasNext})>
      search({
    required String keyword,
    required String accountBookId,
    int page = 0,
    int size = 20,
  }) async {
    final response = await _remoteDataSource.search(
      keyword: keyword,
      accountBookId: accountBookId,
      page: page,
      size: size,
    );

    return (
      transactions:
          response.transactions.map((m) => m.toEntity()).toList(),
      totalCount: response.totalCount,
      hasNext: response.hasNext,
    );
  }
}
