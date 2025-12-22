import 'package:moneyflow/features/income/domain/entities/income.dart';
import 'package:moneyflow/features/income/domain/repositories/income_repository.dart';

class GetRecentIncomeListUsecase {
  final IncomeRepository _repository;

  GetRecentIncomeListUsecase(this._repository);

  /// 최근 수입 내역 조회 (최근 수입 5개 조회 - 홈 화면 전용)
  ///
  /// Returns: [List<IncomeModel>] 최근 수입 목록
  ///
  /// Throws:
  /// - [NetworkException] 네트워크 오류
  /// - [TokenExpiredException] 토큰 만료
  /// - [ServerException] 서버 오류
  Future<List<Income>> call() async {
    return await _repository.getRecentIncomeList();
  }
}
