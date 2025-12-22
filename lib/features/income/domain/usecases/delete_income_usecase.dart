import 'package:moneyflow/features/income/domain/repositories/income_repository.dart';

class DeleteIncomeUsecase {
  final IncomeRepository _repository;

  DeleteIncomeUsecase(this._repository);

  /// 수입 삭제
  ///
  /// [incomeId] 수입 ID*
  ///
  /// Returns: void
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [TokenExpiredException] 토큰 만료
  /// - [ServerException] 서버 오류
  Future<void> call({
    required String incomeId,
  }) async {
    return await _repository.deleteIncome(incomeId: incomeId);
  }
}
