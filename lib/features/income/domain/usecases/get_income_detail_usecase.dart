import 'package:moamoa/features/income/domain/entities/income.dart';
import 'package:moamoa/features/income/domain/repositories/income_repository.dart';

class GetIncomeDetailUsecase {
  final IncomeRepository _repository;

  GetIncomeDetailUsecase(this._repository);

  /// 수입 상세 조회
  ///
  /// [incomeId] 수입 ID*
  ///
  /// Returns: [Income]
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [TokenExpiredException] 토큰 만료
  /// - [ServerException] 서버 오류
  Future<Income> call({
    required String incomeId,
  }) async {
    return await _repository.getIncomeDetail(incomeId: incomeId);
  }
}
