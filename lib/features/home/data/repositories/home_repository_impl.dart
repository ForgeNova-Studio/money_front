import 'package:intl/intl.dart';
import 'package:moneyflow/features/expense/domain/repositories/expense_repository.dart';
import 'package:moneyflow/features/income/domain/repositories/income_repository.dart';
import 'package:moneyflow/features/home/domain/entities/daily_transaction_summary.dart';
import 'package:moneyflow/features/home/domain/entities/transaction_entity.dart';
import 'package:moneyflow/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final ExpenseRepository _expenseRepository;
  final IncomeRepository _incomeRepository;

  HomeRepositoryImpl({
    required ExpenseRepository expenseRepository,
    required IncomeRepository incomeRepository,
  })  : _expenseRepository = expenseRepository,
        _incomeRepository = incomeRepository;

  @override
  Future<Map<String, DailyTransactionSummary>> getMonthlyHomeData({
    required DateTime yearMonth,
  }) async {
    final startDate = DateTime(yearMonth.year, yearMonth.month, 1);
    final endDate = DateTime(yearMonth.year, yearMonth.month + 1, 0);

    // 지출과 수입 데이터를 병렬로 가져옴
    final results = await Future.wait([
      _expenseRepository.getExpenseList(startDate: startDate, endDate: endDate),
      _incomeRepository.getIncomeList(startDate: startDate, endDate: endDate),
    ]);

    final expenses = results[0] as List;
    final incomes = results[1] as List;

    final Map<String, DailyTransactionSummary> dailyMap = {};
    final dateFormat = DateFormat('yyyy-MM-dd');

    // 지출 데이터 가공
    for (var expense in expenses) {
      final dateKey = dateFormat.format(expense.date);
      final transaction = TransactionEntity.fromExpense(expense);
      
      _updateDailyMap(dailyMap, dateKey, transaction, expense.date);
    }

    // 수입 데이터 가공
    for (var income in incomes) {
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
