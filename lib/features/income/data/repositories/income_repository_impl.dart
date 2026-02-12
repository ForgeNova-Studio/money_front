// dataSources
import 'package:moamoa/features/income/data/datasources/income_remote_datasource.dart';

// models
import 'package:moamoa/features/income/data/models/income_model.dart';

// entities
import 'package:moamoa/features/income/domain/entities/income.dart';

// repositories
import 'package:moamoa/features/income/domain/repositories/income_repository.dart';

/// 수입 리포지토리 구현체
///
/// [IncomeRepository] 인터페이스를 구현하며, 데이터 소스와 도메인 계층 간의 중개 역할을 합니다.
/// Data Layer의 모델([IncomeModel])과 Domain Layer의 엔티티([Income]) 간의 변환을 담당합니다.
///
/// **주요 기능:**
/// - 수입 목록 조회 및 엔티티 변환 ([getIncomeList])
/// - 수입 등록/수정/삭제 및 엔티티 변환
class IncomeRepositoryImpl implements IncomeRepository {
  final IncomeRemoteDataSource remoteDataSource;

  IncomeRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<Income>> getIncomeList({
    required DateTime startDate,
    required DateTime endDate,
    String? source,
  }) async {
    // 1. Remote API 호출
    final response = await remoteDataSource.getIncomeList(
      startDate: startDate,
      endDate: endDate,
      source: source,
    );

    // 2. Entity 변환 및 반환
    return response.incomes.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Income> createIncome({
    required Income income,
  }) async {
    // 1. Entity를 Model로 변환
    final incomeModel = IncomeModel.fromEntity(income);

    // 2. Remote API 호출
    final createdModel = await remoteDataSource.createIncome(
      income: incomeModel,
    );

    // 3. Entity 변환 및 반환
    return createdModel.toEntity();
  }

  @override
  Future<Income> getIncomeDetail({
    required String incomeId,
  }) async {
    // 1. Remote API 호출
    final incomeModel = await remoteDataSource.getIncomeDetail(
      incomeId: incomeId,
    );

    // 2. Entity 변환 및 반환
    return incomeModel.toEntity();
  }

  @override
  Future<Income> updateIncome({
    required String incomeId,
    required Income income,
  }) async {
    // 1. Entity를 Model로 변환
    final incomeModel = IncomeModel.fromEntity(income);

    // 2. Remote API 호출
    final updatedModel = await remoteDataSource.updateIncome(
      incomeId: incomeId,
      income: incomeModel,
    );

    // 3. Entity 변환 및 반환
    return updatedModel.toEntity();
  }

  @override
  Future<void> deleteIncome({
    required String incomeId,
  }) async {
    // Remote API 호출
    await remoteDataSource.deleteIncome(incomeId: incomeId);
  }
}
