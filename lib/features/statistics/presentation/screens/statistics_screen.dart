import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/core/constants/expense_categories.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';

/// 카테고리별 지출 데이터 모델
class CategoryExpense {
  final String id;
  final String category;
  final int amount;
  final Color color;

  const CategoryExpense({
    required this.id,
    required this.category,
    required this.amount,
    required this.color,
  });

  double getPercentage(int total) => total > 0 ? (amount / total) * 100 : 0;
}

/// 더미 데이터 생성 (실제 카테고리 사용)
List<CategoryExpense> _generateDummyData() {
  // 실제 카테고리를 사용한 더미 데이터
  final dummyAmounts = {
    'FOOD': 450000,
    'CAFE_SNACK': 125000,
    'TRANSPORT': 180000,
    'HOUSING': 850000,
    'COMMUNICATION': 75000,
    'SHOPPING': 320000,
    'HEALTH': 120000,
    'CULTURE': 95000,
    'LIVING': 85000,
  };

  return DefaultExpenseCategories.all
      .where((cat) => dummyAmounts.containsKey(cat.id))
      .map((cat) => CategoryExpense(
            id: cat.id,
            category: cat.name,
            amount: dummyAmounts[cat.id]!,
            color: _hexToColor(cat.color),
          ))
      .toList();
}

Color _hexToColor(String hex) {
  return Color(int.parse('FF$hex', radix: 16));
}

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  late DateTime _selectedMonth;
  late DateTime _currentMonth;
  late List<CategoryExpense> _expenses;
  int _touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
    _selectedMonth = _currentMonth;
    _expenses = _generateDummyData();
  }

  bool get _isCurrentMonth =>
      _selectedMonth.year == _currentMonth.year &&
      _selectedMonth.month == _currentMonth.month;

  int get _totalExpense => _expenses.fold(0, (sum, e) => sum + e.amount);

  void _changeMonth(int delta) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + delta,
      );
      // 실제 API 연동 시 여기서 데이터 새로고침
      _expenses = _generateDummyData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '분석',
      automaticallyImplyLeading: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 월 선택기
            _MonthSelector(
              selectedMonth: _selectedMonth,
              isCurrentMonth: _isCurrentMonth,
              onPrevious: () => _changeMonth(-1),
              onNext: () => _changeMonth(1),
              onGoToCurrentMonth: () {
                if (!_isCurrentMonth) {
                  setState(() => _selectedMonth = _currentMonth);
                  _expenses = _generateDummyData();
                }
              },
            ),
            const SizedBox(height: 24),

            // 지출 내역 타이틀
            _ExpenseHeader(
              selectedMonth: _selectedMonth,
              totalExpense: _totalExpense,
            ),
            const SizedBox(height: 24),

            // 파이 차트
            _ExpensePieChart(
              expenses: _expenses,
              totalExpense: _totalExpense,
              touchedIndex: _touchedIndex,
              onTouched: (index) => setState(() => _touchedIndex = index),
            ),
            const SizedBox(height: 24),

            // 카테고리별 리스트
            _CategoryList(
              expenses: _expenses,
              totalExpense: _totalExpense,
            ),
          ],
        ),
      ),
    );
  }
}

/// 월 선택기 위젯 (예산 설정 스타일)
class _MonthSelector extends StatelessWidget {
  final DateTime selectedMonth;
  final bool isCurrentMonth;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onGoToCurrentMonth;

  const _MonthSelector({
    required this.selectedMonth,
    required this.isCurrentMonth,
    required this.onPrevious,
    required this.onNext,
    required this.onGoToCurrentMonth,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final monthText = DateFormat('yyyy년 M월').format(selectedMonth);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.chevron_left_rounded,
              color: appColors.gray600,
              size: 28,
            ),
            onPressed: onPrevious,
          ),
          Expanded(
            child: Center(
              child: Text(
                monthText,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: appColors.textPrimary,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.chevron_right_rounded,
              color: isCurrentMonth ? appColors.gray300 : appColors.gray600,
              size: 28,
            ),
            onPressed: isCurrentMonth ? null : onNext,
          ),
          // 이번달 버튼
          if (!isCurrentMonth) ...[
            Container(
              height: 24,
              width: 1,
              color: appColors.gray200,
              margin: const EdgeInsets.symmetric(horizontal: 4),
            ),
            TextButton(
              onPressed: onGoToCurrentMonth,
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                '이번달',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: appColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 지출 내역 헤더
class _ExpenseHeader extends StatelessWidget {
  final DateTime selectedMonth;
  final int totalExpense;

  const _ExpenseHeader({
    required this.selectedMonth,
    required this.totalExpense,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'ko_KR');
    final month = selectedMonth.month;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$month월 지출 내역',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '총 ${formatter.format(totalExpense)}원',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

/// 파이 차트 위젯 (fl_chart Sample 2 스타일)
class _ExpensePieChart extends StatelessWidget {
  final List<CategoryExpense> expenses;
  final int totalExpense;
  final int touchedIndex;
  final ValueChanged<int> onTouched;

  const _ExpensePieChart({
    required this.expenses,
    required this.totalExpense,
    required this.touchedIndex,
    required this.onTouched,
  });

  @override
  Widget build(BuildContext context) {
    // 금액순 정렬
    final sortedExpenses = List<CategoryExpense>.from(expenses)
      ..sort((a, b) => b.amount.compareTo(a.amount));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '카테고리별 지출',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          AspectRatio(
            aspectRatio: 1.5,
            child: Row(
              children: [
                // 파이차트
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              onTouched(-1);
                              return;
                            }
                            onTouched(pieTouchResponse
                                .touchedSection!.touchedSectionIndex);
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: _showingSections(sortedExpenses),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // 범례 (Indicators)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: sortedExpenses.take(6).map((expense) {
                    return _Indicator(
                      color: expense.color,
                      text: expense.category,
                      isSquare: true,
                    );
                  }).toList(),
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _showingSections(
      List<CategoryExpense> sortedExpenses) {
    return sortedExpenses.asMap().entries.map((entry) {
      final index = entry.key;
      final expense = entry.value;
      final isTouched = index == touchedIndex;
      final percentage = expense.getPercentage(totalExpense);

      final fontSize = isTouched ? 20.0 : 14.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: expense.color,
        value: expense.amount.toDouble(),
        title: '${percentage.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    }).toList();
  }
}

/// 범례 인디케이터 위젯
class _Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;

  static const double _size = 12;

  const _Indicator({
    required this.color,
    required this.text,
    required this.isSquare,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: _size,
            height: _size,
            decoration: BoxDecoration(
              shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
              borderRadius: isSquare ? BorderRadius.circular(2) : null,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// 카테고리 리스트 위젯
class _CategoryList extends StatelessWidget {
  final List<CategoryExpense> expenses;
  final int totalExpense;

  const _CategoryList({
    required this.expenses,
    required this.totalExpense,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'ko_KR');
    // 금액 순 정렬
    final sortedExpenses = List<CategoryExpense>.from(expenses)
      ..sort((a, b) => b.amount.compareTo(a.amount));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '상세 내역',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...sortedExpenses.map((expense) {
            final percentage = expense.getPercentage(totalExpense);
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: expense.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          expense.category,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '${formatter.format(expense.amount)}원',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 45,
                        child: Text(
                          '${percentage.toStringAsFixed(1)}%',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 12,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 진행률 바
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage / 100,
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(expense.color),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
