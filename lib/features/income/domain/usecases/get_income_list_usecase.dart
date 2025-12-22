import 'package:moneyflow/features/income/domain/entities/income.dart';
import 'package:moneyflow/features/income/domain/repositories/income_repository.dart';

class GetIncomeListUsecase {
  final IncomeRepository _repository;

  GetIncomeListUsecase(this._repository);

  /// 수입 목록 조회
  ///
  /// [startDate] 조회 시작일*
  /// [endDate] 조회 종료일*
  /// [source] 수입 출처
  ///
  /// Returns: [List<IncomeModel>] 수입 목록
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [UnauthorizedException] 인증 실패
  /// - [ServerException] 서버 오류

  Future<List<Income>> call({
    required DateTime startDate,
    required DateTime endDate,
    String? source,
  }) async {
    return await _repository.getIncomeList(
        startDate: startDate, endDate: endDate, source: source);
  }
}
