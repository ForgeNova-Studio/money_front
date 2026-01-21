import 'package:moamoa/features/income/domain/entities/income.dart';
import 'package:moamoa/features/income/domain/repositories/income_repository.dart';

class CreateIncomeUsecase {
  final IncomeRepository _repository;

  CreateIncomeUsecase(this._repository);

  /// 수입 생성
  ///
  /// [income] 수입 정보
  ///
  /// Returns: [Income] 생성된 수입
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [TokenExpiredException] 토큰 만료
  /// - [ServerException] 서버 오류
  Future<Income> call({
    required Income income,
  }) async {
    return await _repository.createIncome(income: income);
  }
}
