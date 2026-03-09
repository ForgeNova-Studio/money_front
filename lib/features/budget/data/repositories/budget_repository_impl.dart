import 'package:moamoa/features/budget/data/datasources/remote/budget_remote_datasource.dart';
import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/budget/domain/entities/asset_entity.dart';
import 'package:moamoa/features/budget/domain/repositories/budget_repository.dart';

/// Budget Repository 구현체
///
/// 데이터 계층(Data Layer)과 도메인 계층(Domain Layer) 사이의 중재자 역할을 하는 레포지토리 클래스입니다.
/// 원격 데이터 소스([BudgetRemoteDataSource])로부터 응답받은 DTO 객체(Model)를
/// 애플리케이션의 핵심 비즈니스 로직에서 사용하는 [BudgetEntity], [AssetEntity] 등의 도메인 객체로 변환하여 반환하게 됩니다.
///
/// **Key Features:**
/// *   새로운 예산 생성 및 기존 예산 수정, 도메인 객체(Entity)로 매핑 (`createOrUpdateBudget`)
/// *   특정 월의 예산 정보 조회 및 도메인 객체(Entity)로 매핑 (`getMonthlyBudget`)
/// *   예산 삭제 처리 위임 (`deleteBudget`)
/// *   가계부의 통계(총 자산 등) 조회 및 도메인 객체(Entity)로 매핑 (`getTotalAssets`)
/// *   가계부의 초기 잔액(자산 시작값) 변경 처리 위임 (`updateInitialBalance`)
///
/// **Parameters:**
/// *   [remoteDataSource] - 실제 백엔드 API와의 HTTP 통신을 수행하는 데이터 소스 객체입니다.
///
/// **Usage Example:**
/// ```dart
/// // Riverpod Provider를 통한 주입 및 사용 예시
/// final remoteDataSource = ref.read(budgetRemoteDataSourceProvider);
/// final repository = BudgetRepositoryImpl(remoteDataSource: remoteDataSource);
///
/// // 도메인 영역(Entity)으로 바로 반환됨
/// final BudgetEntity? monthlyBudget = await repository.getMonthlyBudget(
///   year: 2026,
///   month: 2,
///   accountBookId: 'account-123',
/// );
/// ```
class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetRemoteDataSource remoteDataSource;

  BudgetRepositoryImpl({required this.remoteDataSource});

  @override
  Future<BudgetEntity> createOrUpdateBudget({
    required String accountBookId,
    required int year,
    required int month,
    required double targetAmount,
  }) async {
    final model = await remoteDataSource.createOrUpdateBudget(
      accountBookId: accountBookId,
      year: year,
      month: month,
      targetAmount: targetAmount,
    );
    return model.toEntity();
  }

  @override
  Future<BudgetEntity?> getMonthlyBudget({
    required int year,
    required int month,
    String? accountBookId,
  }) async {
    final model = await remoteDataSource.getMonthlyBudget(
      year: year,
      month: month,
      accountBookId: accountBookId,
    );
    return model?.toEntity();
  }

  @override
  Future<void> deleteBudget({
    required String budgetId,
  }) async {
    await remoteDataSource.deleteBudget(
      budgetId: budgetId,
    );
  }

  @override
  Future<AssetEntity> getTotalAssets({
    String? accountBookId,
  }) async {
    final model = await remoteDataSource.getTotalAssets(
      accountBookId: accountBookId,
    );
    return model.toEntity();
  }

  @override
  Future<void> updateInitialBalance({
    required String accountBookId,
    required double initialBalance,
  }) async {
    await remoteDataSource.updateInitialBalance(
      accountBookId: accountBookId,
      initialBalance: initialBalance,
    );
  }
}
