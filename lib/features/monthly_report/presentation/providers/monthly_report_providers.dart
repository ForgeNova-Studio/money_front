import 'package:moamoa/features/common/providers/dio_provider.dart';
import 'package:moamoa/features/monthly_report/data/datasources/monthly_report_remote_datasource.dart';
import 'package:moamoa/features/monthly_report/data/repositories/monthly_report_repository_impl.dart';
import 'package:moamoa/features/monthly_report/domain/entities/monthly_report_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'monthly_report_providers.g.dart';

/// Remote DataSource Provider
@riverpod
MonthlyReportRemoteDataSource monthlyReportRemoteDataSource(Ref ref) {
  final dio = ref.watch(dioProvider);
  return MonthlyReportRemoteDataSourceImpl(dio);
}

/// Repository Provider
@riverpod
MonthlyReportRepository monthlyReportRepository(Ref ref) {
  final dataSource = ref.watch(monthlyReportRemoteDataSourceProvider);
  return MonthlyReportRepositoryImpl(dataSource);
}

/// 월간 리포트 조회 Provider
@riverpod
Future<MonthlyReportEntity> monthlyReport(
  Ref ref, {
  required String accountBookId,
  required int year,
  required int month,
}) async {
  final repository = ref.watch(monthlyReportRepositoryProvider);
  return await repository.getMonthlyReport(
    accountBookId: accountBookId,
    year: year,
    month: month,
  );
}
