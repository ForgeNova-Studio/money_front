import 'package:moamoa/features/budget/data/models/budget_models.dart';

/// Budget Remote Data Source 인터페이스
///
/// 애플리케이션의 예산 및 자산 관련 데이터 통신을 위한 원격 데이터 소스 인터페이스입니다.
/// 백엔드 API와의 통신 규격을 정의하며, 구현체에서 실제 HTTP 통신 로직을 처리합니다.
///
/// **Key Features:**
/// *   새로운 예산 생성 및 기존 예산 수정 (`createOrUpdateBudget`)
/// *   특정 월의 예산 정보 조회 (`getMonthlyBudget`)
/// *   예산 삭제 처리 (`deleteBudget`)
/// *   가계부의 총 자산 및 초기 잔액 정보 등의 통계 조회 (`getTotalAssets`)
/// *   가계부의 초기 잔액(자산 시작값) 변경 (`updateInitialBalance`)
///
/// **Usage Example:**
/// ```dart
/// // Riverpod Provider를 통한 주입 및 사용 예시
/// final remoteDataSource = ref.read(budgetRemoteDataSourceProvider);
///
/// final monthlyBudget = await remoteDataSource.getMonthlyBudget(
///   year: 2026,
///   month: 2,
///   accountBookId: 'account-123',
/// );
/// ```
abstract class BudgetRemoteDataSource {
  /// 예산 생성 또는 수정 API 호출
  Future<BudgetResponseModel> createOrUpdateBudget({
    required String accountBookId,
    required int year,
    required int month,
    required double targetAmount,
  });

  /// 월간 예산 조회 API 호출
  Future<BudgetResponseModel?> getMonthlyBudget({
    required int year,
    required int month,
    String? accountBookId,
  });

  /// 예산 삭제 API 호출
  Future<void> deleteBudget({
    required String budgetId,
  });

  /// 총 자산 조회 API 호출
  Future<AssetResponseModel> getTotalAssets({
    String? accountBookId,
  });

  /// 초기 잔액 수정 API 호출
  Future<void> updateInitialBalance({
    required String accountBookId,
    required double initialBalance,
  });
}
