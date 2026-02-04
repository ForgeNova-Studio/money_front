import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/core/constants/expense_categories.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';
import 'package:moamoa/features/statistics/domain/entities/category_breakdown.dart';
import 'package:moamoa/features/statistics/domain/entities/monthly_statistics.dart';
import 'package:moamoa/features/statistics/presentation/viewmodels/statistics_view_model.dart';

/// 카테고리별 지출 데이터 (UI용)
class CategoryExpenseUI {
  final String id;
  final String category;
  final int amount;
  final Color color;
  final int percentage;

  const CategoryExpenseUI({
    required this.id,
    required this.category,
    required this.amount,
    required this.color,
    required this.percentage,
  });

  /// Domain Entity에서 변환
  factory CategoryExpenseUI.fromEntity(CategoryBreakdown entity) {
    // 카테고리 ID로 카테고리 정보 찾기
    final categoryInfo = DefaultExpenseCategories.all
        .where((c) => c.id == entity.category)
        .firstOrNull;
    return CategoryExpenseUI(
      id: entity.category,
      category: categoryInfo?.name ?? entity.category,
      amount: entity.amount,
      color:
          categoryInfo != null ? _hexToColor(categoryInfo.color) : Colors.grey,
      percentage: entity.percentage,
    );
  }
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
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final statisticsState = ref.watch(statisticsViewModelProvider);
    final viewModel = ref.read(statisticsViewModelProvider.notifier);

    return DefaultLayout(
      title: '분석',
      automaticallyImplyLeading: false,
      child: statisticsState.statistics.when(
        data: (statistics) => _buildContent(
          context,
          viewModel,
          statisticsState,
          statistics,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => _buildError(context, viewModel, error),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    StatisticsViewModel viewModel,
    StatisticsState state,
    MonthlyStatistics? statistics,
  ) {
    // 데이터 변환
    final expenses = statistics?.categoryBreakdown
            .map((e) => CategoryExpenseUI.fromEntity(e))
            .toList() ??
        [];
    final totalExpense = statistics?.totalAmount ?? 0;

    if (expenses.isEmpty) {
      return RefreshIndicator(
        onRefresh: viewModel.refresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MonthSelector(
                      selectedMonth: state.selectedMonth,
                      isCurrentMonth: state.isCurrentMonth,
                      onPrevious: () => viewModel.changeMonth(-1),
                      onNext: () => viewModel.changeMonth(1),
                      onGoToCurrentMonth: viewModel.goToCurrentMonth,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: _buildEmptyState(context, state.selectedMonth),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: viewModel.refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 월 선택기
            _MonthSelector(
              selectedMonth: state.selectedMonth,
              isCurrentMonth: state.isCurrentMonth,
              onPrevious: () => viewModel.changeMonth(-1),
              onNext: () => viewModel.changeMonth(1),
              onGoToCurrentMonth: viewModel.goToCurrentMonth,
            ),
            const SizedBox(height: 24),

            // 지출 내역 타이틀
            _ExpenseHeader(
              selectedMonth: state.selectedMonth,
              totalExpense: totalExpense,
              comparison: statistics?.comparisonWithLastMonth,
            ),
            const SizedBox(height: 24),

            // 파이 차트
            _ExpensePieChart(
              expenses: expenses,
              totalExpense: totalExpense,
              touchedIndex: _touchedIndex,
              onTouched: (index) => setState(() => _touchedIndex = index),
            ),
            const SizedBox(height: 24),

            // 카테고리별 리스트
            _CategoryList(
              expenses: expenses,
              totalExpense: totalExpense,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, DateTime month) {
    final appColors = context.appColors;
    final monthText = DateFormat('M월').format(month);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.pie_chart_outline,
          size: 64,
          color: appColors.gray300,
        ),
        const SizedBox(height: 16),
        Text(
          '$monthText 지출 내역이 없습니다',
          style: TextStyle(
            fontSize: 16,
            color: appColors.gray500,
          ),
        ),
      ],
    );
  }

  Widget _buildError(
    BuildContext context,
    StatisticsViewModel viewModel,
    Object error,
  ) {
    final appColors = context.appColors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: appColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              '데이터를 불러올 수 없습니다',
              style: TextStyle(
                fontSize: 16,
                color: appColors.gray700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: TextStyle(
                fontSize: 12,
                color: appColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: viewModel.refresh,
              icon: const Icon(Icons.refresh),
              label: const Text('다시 시도'),
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
  final ComparisonData? comparison;

  const _ExpenseHeader({
    required this.selectedMonth,
    required this.totalExpense,
    this.comparison,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final monthName = DateFormat('M월').format(selectedMonth);
    final formatter = NumberFormat('#,###');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$monthName 지출',
          style: TextStyle(
            fontSize: 14,
            color: appColors.gray500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${formatter.format(totalExpense)}원',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        // 전월 대비 표시
        if (comparison != null) ...[
          const SizedBox(height: 8),
          _buildComparisonText(appColors, comparison!),
        ],
      ],
    );
  }

  Widget _buildComparisonText(dynamic appColors, ComparisonData data) {
    final formatter = NumberFormat('#,###');
    final isIncrease = data.diff > 0;
    final color = isIncrease ? Colors.red : Colors.green;
    final arrow = isIncrease ? '↑' : '↓';
    final diffText = formatter.format(data.diff.abs());
    final percentText = data.diffPercentage.abs().toStringAsFixed(1);

    return Row(
      children: [
        Text(
          '전월 대비 ',
          style: TextStyle(
            fontSize: 13,
            color: appColors.gray500,
          ),
        ),
        Text(
          '$arrow $diffText원 ($percentText%)',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// 파이 차트
class _ExpensePieChart extends StatelessWidget {
  final List<CategoryExpenseUI> expenses;
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
    final sortedExpenses = List<CategoryExpenseUI>.from(expenses)
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
                  flex: 3,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (event, response) {
                          if (!event.isInterestedForInteractions ||
                              response == null ||
                              response.touchedSection == null) {
                            onTouched(-1);
                            return;
                          }
                          onTouched(
                              response.touchedSection!.touchedSectionIndex);
                        },
                      ),
                      startDegreeOffset: 270,
                      sectionsSpace: 2,
                      centerSpaceRadius: 0,
                      sections: sortedExpenses.asMap().entries.map((entry) {
                        final index = entry.key;
                        final expense = entry.value;
                        final isTouched = index == touchedIndex;
                        final radius = isTouched ? 95.0 : 80.0;

                        return PieChartSectionData(
                          color: expense.color,
                          value: expense.amount.toDouble(),
                          title: '${expense.percentage}%',
                          radius: radius,
                          titleStyle: TextStyle(
                            fontSize: isTouched ? 16 : 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: const [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          titlePositionPercentageOffset: 0.6,
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // 범례
                Expanded(
                  flex: 2,
                  child: Column(
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 범례 인디케이터
class _Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;

  static const double _size = 14;

  const _Indicator({
    required this.color,
    required this.text,
    this.isSquare = false,
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

/// 카테고리별 리스트
class _CategoryList extends StatelessWidget {
  final List<CategoryExpenseUI> expenses;
  final int totalExpense;

  const _CategoryList({
    required this.expenses,
    required this.totalExpense,
  });

  @override
  Widget build(BuildContext context) {
    // 금액순 정렬
    final sortedExpenses = List<CategoryExpenseUI>.from(expenses)
      ..sort((a, b) => b.amount.compareTo(a.amount));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '상세 내역',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...sortedExpenses.map((expense) => _CategoryListItem(
              expense: expense,
              totalExpense: totalExpense,
            )),
      ],
    );
  }
}

/// 카테고리 리스트 아이템
class _CategoryListItem extends StatelessWidget {
  final CategoryExpenseUI expense;
  final int totalExpense;

  const _CategoryListItem({
    required this.expense,
    required this.totalExpense,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final formatter = NumberFormat('#,###');
    final percentage = expense.percentage;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: appColors.gray100),
      ),
      child: Row(
        children: [
          // 카테고리 아이콘
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: expense.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getCategoryIcon(expense.id),
              color: expense.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // 카테고리 이름
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.category,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                // 진행 바
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: appColors.gray100,
                    valueColor: AlwaysStoppedAnimation<Color>(expense.color),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // 금액 & 비율
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${formatter.format(expense.amount)}원',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 12,
                  color: appColors.gray500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String categoryId) {
    // 카테고리 ID로 카테고리 정보 찾기
    final category = DefaultExpenseCategories.all
        .where((c) => c.id == categoryId)
        .firstOrNull;
    if (category == null) return Icons.category;

    // 카테고리 아이콘 매핑
    switch (categoryId) {
      case 'FOOD':
        return Icons.restaurant;
      case 'CAFE_SNACK':
        return Icons.local_cafe;
      case 'TRANSPORT':
        return Icons.directions_car;
      case 'HOUSING':
        return Icons.home;
      case 'COMMUNICATION':
        return Icons.phone;
      case 'SHOPPING':
        return Icons.shopping_bag;
      case 'HEALTH':
        return Icons.favorite;
      case 'CULTURE':
        return Icons.movie;
      case 'LIVING':
        return Icons.weekend;
      case 'EDUCATION':
        return Icons.school;
      case 'ALCOHOL':
        return Icons.sports_bar;
      case 'TRAVEL':
        return Icons.flight;
      case 'OTHER':
        return Icons.more_horiz;
      default:
        return Icons.category;
    }
  }
}
