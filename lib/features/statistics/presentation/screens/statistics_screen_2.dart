import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:moamoa/core/constants/expense_categories.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';

/// 카테고리별 지출 데이터 모델
class CategoryExpense {
  final String id;
  final String category;
  final int amount;
  final Color color;
  final IconData icon;

  const CategoryExpense({
    required this.id,
    required this.category,
    required this.amount,
    required this.color,
    required this.icon,
  });

  double getPercentage(int total) => total > 0 ? (amount / total) * 100 : 0;
}

/// 더미 데이터 생성
List<CategoryExpense> _generateDummyData() {
  final dummyAmounts = {
    'FOOD': 450000,
    'CAFE_SNACK': 125000,
    'TRANSPORT': 180000,
    'HOUSING': 850000,
    'COMMUNICATION': 75000,
    'SHOPPING': 320000,
    'HEALTH': 120000,
    'CULTURE': 95000,
  };

  return DefaultExpenseCategories.all
      .where((cat) => dummyAmounts.containsKey(cat.id))
      .map((cat) => CategoryExpense(
            id: cat.id,
            category: cat.name,
            amount: dummyAmounts[cat.id]!,
            color: _hexToColor(cat.color),
            icon: _getIcon(cat.icon),
          ))
      .toList()
    ..sort((a, b) => b.amount.compareTo(a.amount));
}

Color _hexToColor(String hex) {
  return Color(int.parse('FF$hex', radix: 16));
}

IconData _getIcon(String iconName) {
  switch (iconName) {
    case 'restaurant':
      return Icons.restaurant;
    case 'local_cafe':
      return Icons.local_cafe;
    case 'directions_bus':
      return Icons.directions_bus;
    case 'home':
      return Icons.home;
    case 'wifi':
      return Icons.wifi;
    case 'shopping_bag':
      return Icons.shopping_bag;
    case 'medical_services':
      return Icons.medical_services;
    case 'movie':
      return Icons.movie;
    default:
      return Icons.category;
  }
}

class StatisticsScreen2 extends ConsumerStatefulWidget {
  const StatisticsScreen2({super.key});

  @override
  ConsumerState<StatisticsScreen2> createState() => _StatisticsScreen2State();
}

class _StatisticsScreen2State extends ConsumerState<StatisticsScreen2> {
  late DateTime _selectedMonth;
  late List<CategoryExpense> _expenses;

  // 더미 데이터
  final int _fixedExpense = 1064981;
  final int _income = 390700;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
    _expenses = _generateDummyData();
  }

  int get _totalExpense => _expenses.fold(0, (sum, e) => sum + e.amount);

  void _changeMonth(int delta) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + delta,
      );
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
              onPrevious: () => _changeMonth(-1),
              onNext: () => _changeMonth(1),
            ),
            const SizedBox(height: 20),

            // 1. X월 소비 카드
            _ExpenseCard(
              month: _selectedMonth.month,
              totalExpense: _totalExpense,
              expenses: _expenses,
            ),
            const SizedBox(height: 16),

            // 2. X월 고정 지출 카드
            _FixedExpenseCard(
              month: _selectedMonth.month,
              fixedExpense: _fixedExpense,
            ),
            const SizedBox(height: 16),

            // 3. X월 수입 카드
            _IncomeCard(
              month: _selectedMonth.month,
              income: _income,
            ),
            const SizedBox(height: 24),

            // 소비 분석 리포트
            _AnalysisReportSection(),
          ],
        ),
      ),
    );
  }
}

/// 월 선택기 위젯
class _MonthSelector extends StatelessWidget {
  final DateTime selectedMonth;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _MonthSelector({
    required this.selectedMonth,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final year = selectedMonth.year;
    final month = selectedMonth.month;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left, size: 28),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 4),
        Text(
          '$year년 $month월',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right, size: 28),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }
}

/// 소비 카드 (카테고리 리스트 포함)
class _ExpenseCard extends StatelessWidget {
  final int month;
  final int totalExpense;
  final List<CategoryExpense> expenses;

  const _ExpenseCard({
    required this.month,
    required this.totalExpense,
    required this.expenses,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'ko_KR');
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
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
          // 헤더: X월 소비 + 총 금액
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$month월 소비',
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    '${formatter.format(totalExpense)}원',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // 카테고리 리스트
          ...expenses.take(5).map((expense) {
            final percentage = expense.getPercentage(totalExpense);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: expense.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      expense.icon,
                      color: expense.color,
                      size: 18,
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
                    width: 42,
                    child: Text(
                      '${percentage.toStringAsFixed(0)}%',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
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

/// 고정 지출 카드
class _FixedExpenseCard extends StatelessWidget {
  final int month;
  final int fixedExpense;

  const _FixedExpenseCard({
    required this.month,
    required this.fixedExpense,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'ko_KR');
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.autorenew,
              color: Colors.green.shade600,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$month월 고정 지출',
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '${formatter.format(fixedExpense)}원 예상',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

/// 수입 카드
class _IncomeCard extends StatelessWidget {
  final int month;
  final int income;

  const _IncomeCard({
    required this.month,
    required this.income,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###', 'ko_KR');
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.savings,
              color: Colors.amber.shade700,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$month월 수입',
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  '${formatter.format(income)}원',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

/// 소비 분석 리포트 섹션
class _AnalysisReportSection extends StatelessWidget {
  const _AnalysisReportSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '소비 분석 리포트',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ReportCard(
                title: '변동비/고정비\n분석',
                icon: Icons.donut_large,
                iconColor: Colors.teal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ReportCard(
                title: '카테고리\n분석',
                icon: Icons.format_list_bulleted,
                iconColor: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ReportCard(
                title: '소비\n리포트',
                icon: Icons.bar_chart,
                iconColor: Colors.indigo,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 리포트 카드
class _ReportCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;

  const _ReportCard({
    required this.title,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
