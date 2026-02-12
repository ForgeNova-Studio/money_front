import 'package:moamoa/features/income/data/models/income_list_response_model.dart';
import 'package:moamoa/features/income/data/models/income_model.dart';

/// 수입 원격 데이터 소스 인터페이스
///
/// Dio를 사용한 API 통신을 정의합니다.
/// Data Layer에서만 사용되는 [IncomeModel]과 [IncomeListResponseModel]을 반환합니다.
///
/// **주요 기능:**
/// - 수입 목록 조회 ([getIncomeList])
/// - 수입 등록/수정/삭제/상세조회
abstract class IncomeRemoteDataSource {
  /// 수입 목록 조회
  Future<IncomeListResponseModel> getIncomeList({
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
