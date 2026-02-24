import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/core/constants/expense_categories.dart';
import 'package:moamoa/features/common/widgets/custom_pull_to_refresh.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';
import 'package:moamoa/features/common/widgets/error_state_widget.dart';
import 'package:moamoa/features/statistics/domain/entities/category_breakdown.dart';
import 'package:moamoa/features/statistics/domain/entities/monthly_statistics.dart';
import 'package:moamoa/features/statistics/presentation/states/statistics_state.dart';
import 'package:moamoa/features/statistics/presentation/viewmodels/statistics_view_model.dart';
import 'package:moamoa/features/expense/presentation/utils/expense_category_utils.dart';

/// 카테고리별 지출 데이터 (UI용)
class CategoryExpenseUI {
  final String id;
  final String category;
  final int amount;
  final Color color;
  final double percentage; // double로 변경

  // 전월 대비 데이터
  final int? previousAmount;
  final int? diff;
  final double? diffPercentage;

  const CategoryExpenseUI({
    required this.id,
    required this.category,
    required this.amount,
    required this.color,
    required this.percentage,
    this.previousAmount,
    this.diff,
    this.diffPercentage,
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
  final value = int.parse(hex, radix: 16);
  return Color(0xFF000000 | value);
}

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statisticsState = ref.watch(statisticsViewModelProvider);
    final viewModel = ref.read(statisticsViewModelProvider.notifier);

    // 뒤로가기 버튼이 있는지 확인 (더 보기 -> 통계로 접근했는지)
    final canPop = ModalRoute.of(context)?.canPop ?? false;

    return DefaultLayout(
      title: '분석',
      titleSpacing: canPop ? 0 : null,
      leading: canPop
          ? Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
                onPressed: () => context.pop(),
              ),
            )
          : null,
      child: statisticsState.statistics.when(
        data: (statistics) => _buildContent(
          context,
          viewModel,
          statisticsState,
          statistics,
        ),
        loading: () {
          // 이미 데이터가 있으면 로딩 인디케이터 표시 안 함 (Pull-to-Refresh 사용)
          if (statisticsState.statistics.value != null) {
            return _buildContent(
              context,
              viewModel,
              statisticsState,
              statisticsState.statistics.value,
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
        error: (error, stackTrace) => ErrorStateWidget(
          error: error,
          onRetry: viewModel.refresh,
        ),
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
    final categoryComparison = state.categoryComparison.asData?.value;

    // 카테고리 비교 데이터를 Map으로 변환 (O(1) lookup)
    final comparisonMap = categoryComparison?.categories
            .fold<Map<String, dynamic>>({}, (map, comparison) {
          map[comparison.category] = {
            'previousAmount': comparison.previousAmount,
            'diff': comparison.diff,
            'diffPercentage': comparison.diffPercentage,
          };
          return map;
        }) ??
        {};

    final expenses = statistics?.categoryBreakdown.map((e) {
          final categoryId = e.category;
          final categoryInfo = DefaultExpenseCategories.all
              .where((c) => c.id == categoryId)
              .firstOrNull;

          // 전월 대비 데이터 병합
          final comparisonData = comparisonMap[categoryId];

          return CategoryExpenseUI(
            id: categoryId,
            category: categoryInfo?.name ?? categoryId,
            amount: e.amount,
            color: categoryInfo != null
                ? _hexToColor(categoryInfo.color)
                : Colors.grey,
            percentage: e.percentage,
            previousAmount: comparisonData?['previousAmount'],
            diff: comparisonData?['diff'],
            diffPercentage: comparisonData?['diffPercentage'],
          );
        }).toList() ??
        [];
    final totalExpense = statistics?.totalAmount ?? 0;

    if (expenses.isEmpty) {
      return CustomPullToRefresh(
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

    return CustomPullToRefresh(
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

            // 도넛 차트
            _ExpensePieChart(
              expenses: expenses,
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

/// 도넛 차트 (모던 리디자인)
/// - 상위 5개 카테고리 + "기타" 그룹핑
/// - 우측 범례 + "기타" 서브 팔레트
class _ExpensePieChart extends StatefulWidget {
  final List<CategoryExpenseUI> expenses;

  const _ExpensePieChart({
    required this.expenses,
  });

  @override
  State<_ExpensePieChart> createState() => _ExpensePieChartState();
}

class _ExpensePieChartState extends State<_ExpensePieChart> {
  /// 라벨을 표시할 최소 비율 (%)
  static const int _minLabelPercentage = 5;

  /// 기타 카테고리 확장 여부
  bool _isExpanded = false;

  /// 5% 미만인 항목들을 "기타" 그룹핑
  List<_ChartSlice> _buildSlices() {
    final sorted = List<CategoryExpenseUI>.from(widget.expenses)
      ..sort((a, b) => b.amount.compareTo(a.amount));

    // 전체 합계 계산 (비율 재계산을 위해)
    final total = widget.expenses.fold<int>(0, (sum, e) => sum + e.amount);
    if (total == 0) return [];

    // 5% 기준 분리
    final mainSlices = <CategoryExpenseUI>[];
    final otherSlices = <CategoryExpenseUI>[];

    for (var expense in sorted) {
      if (expense.percentage >= 5.0) {
        mainSlices.add(expense);
      } else {
        otherSlices.add(expense);
      }
    }

    // 기타 항목이 없으면 그대로 반환
    if (otherSlices.isEmpty) {
      return mainSlices.map((e) {
        return _ChartSlice(
          category: e.category,
          percentage: e.percentage,
          color: e.color,
          amount: e.amount,
        );
      }).toList();
    }

    // 기타 항목 합계
    final otherAmount = otherSlices.fold<int>(0, (sum, e) => sum + e.amount);
    final otherPercent = (otherAmount / total * 100);

    return [
      ...mainSlices.map((e) {
        return _ChartSlice(
          category: e.category,
          percentage: e.percentage,
          color: e.color,
          amount: e.amount,
        );
      }),
      _ChartSlice(
        category: '기타',
        percentage: otherPercent,
        color: const Color(0xFFBDBDBD),
        amount: otherAmount,
        subCategories: otherSlices.map((e) {
          return _SubCategory(
            name: e.category,
            color: e.color,
            percentage: e.percentage,
          );
        }).toList(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final slices = _buildSlices();

    return Column(
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
        Container(
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 도넛 차트
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      startDegreeOffset: 270,
                      sectionsSpace: 2,
                      centerSpaceRadius: 45,
                      sections: slices.map((slice) {
                        final showLabel =
                            slice.percentage >= _minLabelPercentage;

                        return PieChartSectionData(
                          color: slice.color,
                          value: slice.amount.toDouble(),
                          title: showLabel
                              ? (slice.percentage % 1 == 0
                                  ? '${slice.percentage.toInt()}%'
                                  : '${slice.percentage.toStringAsFixed(1)}%')
                              : '',
                          radius: 55,
                          titleStyle: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                color: Colors.black26,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          titlePositionPercentageOffset: 0.55,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // 우측 범례 + 기타 서브 팔레트
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: slices.map((slice) {
                    final isOther = slice.subCategories != null;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 메인 범례 항목
                        InkWell(
                          onTap: isOther
                              ? () {
                                  setState(() {
                                    _isExpanded = !_isExpanded;
                                  });
                                }
                              : null,
                          borderRadius: BorderRadius.circular(4),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: _LegendItem(
                              color: slice.color,
                              label: slice.category,
                              percentage: slice.percentage,
                              appColors: appColors,
                              isExpandable: isOther,
                              isExpanded: isOther ? _isExpanded : false,
                            ),
                          ),
                        ),
                        // "기타" 서브 팔레트 (애니메이션 적용)
                        if (isOther)
                          AnimatedSize(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            alignment: Alignment.topCenter,
                            child: _isExpanded
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: slice.subCategories!
                                        .map((sub) => Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 1),
                                              child: _LegendItem(
                                                color: sub.color,
                                                label: sub.name,
                                                percentage: sub.percentage,
                                                appColors: appColors,
                                                isSubItem: true,
                                              ),
                                            ))
                                        .toList(),
                                  )
                                : const SizedBox(width: double.infinity),
                          ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 범례 항목
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final double percentage;
  final AppThemeColors appColors;
  final bool isSubItem;
  final bool isExpandable;
  final bool isExpanded;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.percentage,
    required this.appColors,
    this.isSubItem = false,
    this.isExpandable = false,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    // 1% 미만이지만 0보다 큰 경우 '< 1%' 표시
    String percentText;
    if (percentage > 0 && percentage < 1) {
      percentText = '< 1%';
    } else {
      if (percentage % 1 == 0) {
        percentText = '${percentage.toInt()}%';
      } else {
        percentText = '${percentage.toStringAsFixed(1)}%';
      }
    }

    return Padding(
      padding: EdgeInsets.only(
        left: isSubItem ? 16 : 0,
        bottom: 4,
        top: isSubItem ? 0 : 2,
      ),
      child: Row(
        children: [
          // 색상 팔레트 (항상 표시)
          Container(
            width: isSubItem ? 6 : 10,
            height: isSubItem ? 6 : 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),

          // 라벨 및 확장 아이콘
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: isSubItem ? 10 : 12,
                      fontWeight: isSubItem ? FontWeight.w400 : FontWeight.w500,
                      color: isSubItem ? appColors.gray400 : appColors.gray600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // 확장 가능 아이콘 (라벨 우측)
                if (isExpandable)
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: AnimatedRotation(
                      turns: isExpanded ? 0.25 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 18, // 아이콘 크기 증가
                        color: appColors.gray500,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // 퍼센트
          Text(
            percentText,
            style: TextStyle(
              fontSize: isSubItem ? 10 : 11,
              fontWeight: FontWeight.w500,
              color: isSubItem ? appColors.gray400 : appColors.gray500,
            ),
          ),
        ],
      ),
    );
  }
}

/// 도넛 차트 슬라이스 데이터
class _ChartSlice {
  final String category;
  final double percentage; // double로 변경
  final Color color;
  final int amount;
  final List<_SubCategory>? subCategories;

  const _ChartSlice({
    required this.category,
    required this.percentage,
    required this.color,
    required this.amount,
    this.subCategories,
  });
}

/// 기타 내 서브 카테고리
class _SubCategory {
  final String name;
  final Color color;
  final double percentage; // double로 변경

  const _SubCategory({
    required this.name,
    required this.color,
    required this.percentage,
  });
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

  IconData _getCategoryIcon(String categoryId) {
    return resolveExpenseCategoryIcon(categoryId);
  }

  Widget _buildDiffText(
      BuildContext context, int? diff, double? diffPercentage) {
    if (diff == null) return const SizedBox.shrink();

    final appColors = context.appColors;
    final formatter = NumberFormat('#,###');
    final isIncrease = diff > 0;
    final isDecrease = diff < 0;
    final color = isIncrease
        ? Colors.red
        : isDecrease
            ? Colors.green
            : appColors.gray500;
    final icon = isIncrease
        ? Icons.arrow_drop_up_rounded
        : isDecrease
            ? Icons.arrow_drop_down_rounded
            : Icons.remove;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        Text(
          '${formatter.format(diff.abs())}원',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          diffPercentage != null
              ? '(${diffPercentage.abs() >= 100 ? diffPercentage.toStringAsFixed(0) : diffPercentage.toStringAsFixed(1)}%)'
              : '(-)',
          style: TextStyle(
            fontSize: 12,
            color: color,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;
    final formatter = NumberFormat('#,###');

    // 1. 퍼센트 계산 (0.0 ~ 100.0)
    final double percent = expense.percentage;

    // 2. 텍스트 포맷팅 (소수점 1자리)
    // 예: 12.5%, 12.0% -> 12%
    String percentText;
    if (percent > 0 && percent < 1) {
      percentText = '< 1%';
    } else {
      // 소수점 1자리까지 표시하되, .0인 경우 정수만 표시
      if (percent % 1 == 0) {
        percentText = '${percent.toInt()}%';
      } else {
        percentText = '${percent.toStringAsFixed(1)}%';
      }
    }

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
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: expense.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getCategoryIcon(expense.id),
              color: expense.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // 카테고리 정보 & 진행률
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      expense.category,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: appColors.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          percentText,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: appColors.gray600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 1,
                          height: 12,
                          color: appColors.gray300,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${formatter.format(expense.amount)}원',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // 진행 바
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percent / 100,
                    backgroundColor: appColors.gray100,
                    valueColor: AlwaysStoppedAnimation<Color>(expense.color),
                    minHeight: 6,
                  ),
                ),
                // 전월 대비 표시
                if (expense.diff != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '전월 대비 ',
                        style: TextStyle(
                          fontSize: 12,
                          color: appColors.gray500,
                        ),
                      ),
                      _buildDiffText(
                          context, expense.diff, expense.diffPercentage),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
