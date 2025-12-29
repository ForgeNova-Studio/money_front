// packages
import 'package:intl/intl.dart';

// entities
import 'package:moneyflow/features/home/domain/entities/daily_transaction_summary.dart';

// repository
import 'package:moneyflow/features/home/domain/repositories/home_repository.dart';

// dataSource
import 'package:moneyflow/features/home/data/datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _homeRemoteDataSource;

  HomeRepositoryImpl({
    required HomeRemoteDataSource homeRemoteDataSource,
  }) : _homeRemoteDataSource = homeRemoteDataSource;

  @override
  Future<Map<String, DailyTransactionSummary>> getMonthlyHomeData({
    required DateTime yearMonth,
  }) async {
    final yearMonthStr = DateFormat('yyyy-MM').format(yearMonth);
    
    // API 호출 (이미 날짜별로 정리된 데이터를 받아옴)
    final responseMap = await _homeRemoteDataSource.getMonthlyData(yearMonth: yearMonthStr);

    // Model -> Entity 변환
    return responseMap.map((key, model) => MapEntry(key, model.toEntity()));
  }
}