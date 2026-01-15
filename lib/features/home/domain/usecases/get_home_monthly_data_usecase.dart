import 'package:moneyflow/features/home/domain/entities/daily_transaction_summary.dart';
import 'package:moneyflow/features/home/domain/repositories/home_repository.dart';

class GetHomeMonthlyDataUseCase {
  final HomeRepository _repository;

  GetHomeMonthlyDataUseCase(this._repository);

  Future<Map<String, DailyTransactionSummary>> call({
    required DateTime yearMonth,
    required String userId,
    required String accountBookId,
  }) async {
    return await _repository.getMonthlyHomeData(
      yearMonth: yearMonth,
      userId: userId,
      accountBookId: accountBookId,
    );
  }
}
