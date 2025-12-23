import 'package:moneyflow/features/income/data/models/income_model.dart';

/// Income Remote Data Source
///
/// Dio를 사용한 API 통신 구현
/// - 순수 Dart 인터페이스
/// - Data Model 반환
/// - 구현체에서 예외 처리
abstract class IncomeRemoteDataSource {
  /// 수입 목록 조회
  Future<List<IncomeModel>> getIncomeList({
    required DateTime startDate,
    required DateTime endDate,
    String? source,
  });

  /// 수입 생성
  Future<IncomeModel> createIncome({required IncomeModel income});

  /// 수입 상세 조회
  Future<IncomeModel> getIncomeDetail({required String incomeId});

  /// 수입 수정
  Future<IncomeModel> updateIncome({
    required String incomeId,
    required IncomeModel income,
  });

  /// 수입 삭제
  Future<void> deleteIncome({required String incomeId});
}
