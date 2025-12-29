// packages
import 'package:intl/intl.dart';

// entities
import 'package:moneyflow/features/home/domain/entities/daily_transaction_summary.dart';
import 'package:moneyflow/features/home/domain/entities/transaction_entity.dart';

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
    
    final responseModel = await _homeRemoteDataSource.getMonthlyData(yearMonth: yearMonthStr);

    final expensesList = responseModel.expenses
            .map((e) => e.toEntity())
            .toList();
    
    final incomesList = responseModel.incomes
            .map((e) => e.toEntity())
            .toList();

    final Map<String, DailyTransactionSummary> dailyMap = {};
    final dateFormat = DateFormat('yyyy-MM-dd');

    // 지출 데이터 가공
    for (var expense in expensesList) {
      final dateKey = dateFormat.format(expense.date);
      final transaction = TransactionEntity.fromExpense(expense);
      
      _updateDailyMap(dailyMap, dateKey, transaction, expense.date);
    }

    // 수입 데이터 가공
    for (var income in incomesList) {
      final dateKey = dateFormat.format(income.date);
      final transaction = TransactionEntity.fromIncome(income);
      
      _updateDailyMap(dailyMap, dateKey, transaction, income.date);
    }

    return dailyMap;
  }

  void _updateDailyMap(
    Map<String, DailyTransactionSummary> map,
    String key,
    TransactionEntity transaction,
    DateTime date,
  ) {
    if (!map.containsKey(key)) {
      map[key] = DailyTransactionSummary.empty(date);
    }

    final current = map[key]!;
    
    double newIncome = current.totalIncome;
    double newExpense = current.totalExpense;

    if (transaction.type == TransactionType.income) {
      newIncome += transaction.amount;
    } else {
      newExpense += transaction.amount;
    }

    // 리스트에 추가하고 시간순 정렬 (필요 시)
    final newTransactions = List<TransactionEntity>.from(current.transactions)..add(transaction);
    newTransactions.sort((a, b) => b.date.compareTo(a.date));

    map[key] = DailyTransactionSummary(
      date: current.date,
      totalIncome: newIncome,
      totalExpense: newExpense,
      transactions: newTransactions,
    );
  }
}

