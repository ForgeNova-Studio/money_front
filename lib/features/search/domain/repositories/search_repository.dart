import 'package:moamoa/features/home/domain/entities/transaction_entity.dart';

/// 거래 내역 검색 Repository 인터페이스
abstract class SearchRepository {
  Future<({List<TransactionEntity> transactions, int totalCount, bool hasNext})>
      search({
    required String keyword,
    required String accountBookId,
    int page = 0,
    int size = 20,
  });
}
