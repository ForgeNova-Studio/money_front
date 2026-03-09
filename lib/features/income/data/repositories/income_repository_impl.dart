// dataSources
import 'package:moamoa/features/income/data/datasources/income_remote_datasource.dart';
import 'package:moamoa/features/common/utils/transaction_repository_utils.dart';

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
  final IncomeRemoteDataSource _remoteDataSource;

  IncomeRepositoryImpl({
    required IncomeRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<List<Income>> getIncomeList({
    required DateTime startDate,
    required DateTime endDate,
    String? source,
  }) async {
    final response = await _remoteDataSource.getIncomeList(
      startDate: startDate,
      endDate: endDate,
      source: source,
    );

    return mapModelsToEntities(response.incomes, (model) => model.toEntity());
  }

  @override
  Future<Income> createIncome({
    required Income income,
  }) async {
    return mapEntityRoundTrip(
      entity: income,
      toModel: IncomeModel.fromEntity,
      request: (model) => _remoteDataSource.createIncome(income: model),
      toEntity: (model) => model.toEntity(),
    );
  }

  @override
  Future<Income> getIncomeDetail({
    required String incomeId,
  }) async {
    return mapModelToEntity(
      request: _remoteDataSource.getIncomeDetail(incomeId: incomeId),
      toEntity: (model) => model.toEntity(),
    );
  }

  @override
  Future<Income> updateIncome({
    required String incomeId,
    required Income income,
  }) async {
    return mapEntityRoundTrip(
      entity: income,
      toModel: IncomeModel.fromEntity,
      request: (model) => _remoteDataSource.updateIncome(
        incomeId: incomeId,
        income: model,
      ),
      toEntity: (model) => model.toEntity(),
    );
  }

  @override
  Future<void> deleteIncome({
    required String incomeId,
  }) async {
    await _remoteDataSource.deleteIncome(incomeId: incomeId);
  }
}
