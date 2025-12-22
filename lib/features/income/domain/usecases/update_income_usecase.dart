import 'package:moneyflow/features/income/domain/entities/income.dart';
import 'package:moneyflow/features/income/domain/repositories/income_repository.dart';

class UpdateIncomeUsecase {
  final IncomeRepository _repository;

  UpdateIncomeUsecase(this._repository);

  /// 수입 수정
  ///
  /// [incomeId] 수입 ID*
  /// [income] 수입 정보*
  ///
  /// Returns: [Income] 수정된 수입
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [TokenExpiredException] 토큰 만료
  /// - [ServerException] 서버 오류
  Future<Income> call({
    required String incomeId,
    required Income income,
  }) async {
    return await _repository.updateIncome(incomeId: incomeId, income: income);
  }
}