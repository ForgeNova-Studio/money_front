import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:moamoa/features/home/presentation/widgets/animated_amount_text.dart';
import 'package:moamoa/router/route_names.dart';

/// 홈 화면의 예산 및 자산 정보를 표시하는 카드 위젯
///
/// [PageView]를 사용하여 예산 정보와 자산 정보를 스와이프로 전환하며 보여줍니다.
///
/// 주요 기능:
/// 1. 이번 달 예산 카드:
///    - 설정된 예산 대비 남은 금액 표시
///    - 지출 진행률 프로그레스 바 제공
///    - 예산 초과 시 붉은색 경고 표시
/// 2. 총 자산 카드:
///    - 현재 총 자산 금액 표시
///    - 이번 달 수입/지출 합계 요약 표시 (낙관적 업데이트 반영)
///
/// 사용 예시:
/// ```dart
/// const HomeBudgetInfoCard()
/// ```
class HomeBudgetInfoCard extends ConsumerStatefulWidget {
  const HomeBudgetInfoCard({super.key});

  @override
  ConsumerState<HomeBudgetInfoCard> createState() => _HomeBudgetInfoCardState();
}

class _HomeBudgetInfoCardState extends ConsumerState<HomeBudgetInfoCard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _openBudgetSettings(DateTime initialMonth) {
    context.push(RouteNames.budgetSettingsWithMonth(initialMonth)).then((_) {
      if (!mounted) return;
      final targetMonth = ref.read(homeViewModelProvider).focusedMonth;
      unawaited(
        ref.read(homeViewModelProvider.notifier).fetchMonthlyData(
              targetMonth,
              forceRefresh: true,
            ),
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);
    final budgetInfo = homeState.budgetInfo;
    final assetInfo = homeState.assetInfo;
    final currentMonth = homeState.focusedMonth.month;

    // 수입/지출 합계 계산 (monthlyData에서)
    final monthlyData = homeState.monthlyData.asData?.value ?? {};
    double periodIncome = 0;
    double periodExpense = 0;
    for (final summary in monthlyData.values) {
      periodIncome += summary.totalIncome;
      periodExpense += summary.totalExpense;
    }

    return SizedBox(
      height: 140,
      child: PageView(
        clipBehavior: Clip.none,
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          // 카드 1: 이번 달 예산
          _buildCard(
            context,
            child: _BudgetCardContent(
              budgetInfo: budgetInfo,
              currentMonth: currentMonth,
              pageIndicator: _buildPageIndicator(context),
            ),
            onTap: () => _openBudgetSettings(homeState.focusedMonth),
          ),
          // 카드 2: 총 자산
          _buildCard(
            context,
            child: _AssetCardContent(
              assetInfo: assetInfo,
              periodIncome: periodIncome,
              periodExpense: periodExpense,
              pageIndicator: _buildPageIndicator(context),
            ),
            onTap: () => context.push(RouteNames.initialBalanceSettings),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required Widget child,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: context.appColors.shadow.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  Widget _buildPageIndicator(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(2, (index) {
        final isActive = index == _currentPage;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 8 : 6,
          height: isActive ? 8 : 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? context.appColors.primary
                : context.appColors.gray300,
          ),
        );
      }),
    );
  }
}

/// 예산 카드 컨텐츠 위젯
class _BudgetCardContent extends StatelessWidget {
  final BudgetEntity? budgetInfo;
  final int currentMonth;
  final Widget pageIndicator;

  const _BudgetCardContent({
    required this.budgetInfo,
    required this.currentMonth,
    required this.pageIndicator,
  });

  @override
  Widget build(BuildContext context) {
    if (budgetInfo == null) {
      return _buildEmptyState(context);
    }

    final remainingAmount = budgetInfo!.remainingAmount;
    final progress = budgetInfo!.usagePercentage / 100;
    final isOverBudget = remainingAmount < 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            AnimatedAmountText(
              amount: remainingAmount.abs(),
              showSign: false,
              suffix: '',
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: isOverBudget
                        ? context.appColors.error
                        : context.appColors.textPrimary,
                  ),
            ),
            Text(
              isOverBudget ? '원 초과' : '원 남음',
              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                    color: isOverBudget
                        ? context.appColors.error
                        : context.appColors.textPrimary,
                  ),
            ),
          ],
        ),
        const Spacer(),
        _buildProgressBar(context, progress, isOverBudget),
        const SizedBox(height: 8),
        _buildFooter(context),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 8),
        Text(
          '예산 미설정',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: context.appColors.textTertiary,
          ),
        ),
        const Spacer(),
        Text(
          '탭하여 예산 설정하기',
          style: TextStyle(
            fontSize: 12,
            color: context.appColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$currentMonth월 예산',
          style: TextStyle(
            fontSize: 16,
            color: context.appColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        pageIndicator,
      ],
    );
  }

  Widget _buildProgressBar(
      BuildContext context, double progress, bool isOverBudget) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: progress.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, animatedProgress, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: animatedProgress,
            backgroundColor: context.appColors.gray100,
            valueColor: AlwaysStoppedAnimation<Color>(
              isOverBudget
                  ? context.appColors.error
                  : context.appColors.primary,
            ),
            minHeight: 8,
          ),
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '지출 ${NumberFormat('#,###').format(budgetInfo!.currentSpending.toInt())}원',
          style: TextStyle(fontSize: 12, color: context.appColors.textTertiary),
        ),
        Text(
          '예산 ${NumberFormat('#,###').format(budgetInfo!.targetAmount.toInt())}원',
          style: TextStyle(fontSize: 12, color: context.appColors.textTertiary),
        ),
      ],
    );
  }
}

/// 자산 카드 컨텐츠 위젯
class _AssetCardContent extends StatelessWidget {
  final AssetEntity? assetInfo;
  final double periodIncome;
  final double periodExpense;
  final Widget pageIndicator;

  const _AssetCardContent({
    required this.assetInfo,
    required this.periodIncome,
    required this.periodExpense,
    required this.pageIndicator,
  });

  @override
  Widget build(BuildContext context) {
    if (assetInfo == null) {
      return _buildEmptyState(context);
    }

    final totalAssets = assetInfo!.currentTotalAssets;
    final isNegative = totalAssets < 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            if (isNegative)
              Text(
                '-',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: context.appColors.error,
                ),
              ),
            AnimatedAmountText(
              amount: totalAssets.abs(),
              showSign: false,
              suffix: '',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isNegative
                    ? context.appColors.error
                    : context.appColors.textPrimary,
              ),
            ),
            Text(
              '원',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isNegative
                    ? context.appColors.error
                    : context.appColors.textPrimary,
              ),
            ),
          ],
        ),
        const Spacer(),
        _buildFooter(context),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 8),
        Text(
          '-',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: context.appColors.textTertiary,
          ),
        ),
        const Spacer(),
        Text(
          '탭하여 초기 잔액 설정하기',
          style: TextStyle(
            fontSize: 12,
            color: context.appColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '총 자산',
          style: TextStyle(
            fontSize: 16,
            color: context.appColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        pageIndicator,
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '수입 ${NumberFormat('#,###').format(periodIncome.toInt())}원',
          style: TextStyle(
            fontSize: 12,
            color: context.appColors.success,
          ),
        ),
        Text(
          '지출 ${NumberFormat('#,###').format(periodExpense.toInt())}원',
          style: TextStyle(
            fontSize: 12,
            color: context.appColors.error,
          ),
        ),
      ],
    );
  }
}
