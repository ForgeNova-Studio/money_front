import 'package:dio/dio.dart';
import 'package:moamoa/features/monthly_report/domain/entities/monthly_report_entity.dart';

/// 월간 리포트 Remote DataSource
abstract class MonthlyReportRemoteDataSource {
  Future<MonthlyReportEntity> getMonthlyReport({
    required String accountBookId,
    required int year,
    required int month,
  });
}

class MonthlyReportRemoteDataSourceImpl implements MonthlyReportRemoteDataSource {
  final Dio _dio;

  MonthlyReportRemoteDataSourceImpl(this._dio);

  @override
  Future<MonthlyReportEntity> getMonthlyReport({
    required String accountBookId,
    required int year,
    required int month,
  }) async {
    final response = await _dio.get(
      '/api/reports/monthly',
      queryParameters: {
        'accountBookId': accountBookId,
        'year': year,
        'month': month,
      },
    );

    return MonthlyReportEntity.fromJson(response.data);
  }
}
