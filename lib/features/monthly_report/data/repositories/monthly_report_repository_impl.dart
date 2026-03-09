import 'package:moamoa/features/monthly_report/data/datasources/monthly_report_remote_datasource.dart';
import 'package:moamoa/features/monthly_report/domain/entities/monthly_report_entity.dart';

/// 월간 리포트 Repository
abstract class MonthlyReportRepository {
  Future<MonthlyReportEntity> getMonthlyReport({
    required String accountBookId,
    required int year,
    required int month,
  });
}

class MonthlyReportRepositoryImpl implements MonthlyReportRepository {
  final MonthlyReportRemoteDataSource _remoteDataSource;

  MonthlyReportRepositoryImpl(this._remoteDataSource);

  @override
  Future<MonthlyReportEntity> getMonthlyReport({
    required String accountBookId,
    required int year,
    required int month,
  }) async {
    return await _remoteDataSource.getMonthlyReport(
      accountBookId: accountBookId,
      year: year,
      month: month,
    );
  }
}
