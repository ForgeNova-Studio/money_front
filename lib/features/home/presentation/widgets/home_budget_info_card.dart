import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:moamoa/router/route_names.dart';

class HomeBudgetInfoCard extends ConsumerStatefulWidget {
  const HomeBudgetInfoCard({super.key});

  @override
  ConsumerState<HomeBudgetInfoCard> createState() => _HomeBudgetInfoCardState();
}

class _HomeBudgetInfoCardState extends ConsumerState<HomeBudgetInfoCard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

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
            child: _buildBudgetContent(context, budgetInfo, currentMonth),
            onTap: () => context.push(RouteNames.budgetSettings),
          ),
          // 카드 2: 총 자산
          _buildCard(
            context,
            child: _buildAssetContent(context, assetInfo),
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: context.appColors.shadow.withOpacity(0.05),
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

  Widget _buildBudgetContent(
    BuildContext context,
    BudgetEntity? budgetInfo,
    int currentMonth,
  ) {
    if (budgetInfo == null) {
      // 예산 미설정 상태
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              _buildPageIndicator(context),
            ],
          ),
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

    final remainingAmount = budgetInfo.remainingAmount;
    final progress = budgetInfo.usagePercentage / 100;
    final isOverBudget = remainingAmount < 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            _buildPageIndicator(context),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          isOverBudget
              ? '${NumberFormat('#,###').format(remainingAmount.abs().toInt())}원 초과'
              : '${NumberFormat('#,###').format(remainingAmount.toInt())}원 남음',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isOverBudget
                ? context.appColors.error
                : context.appColors.textPrimary,
          ),
        ),
        const Spacer(),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: context.appColors.gray100,
            valueColor: AlwaysStoppedAnimation<Color>(
              isOverBudget
                  ? context.appColors.error
                  : context.appColors.primary,
            ),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '지출 ${NumberFormat('#,###').format(budgetInfo.currentSpending.toInt())}원',
              style: TextStyle(
                  fontSize: 12, color: context.appColors.textTertiary),
            ),
            Text(
              '예산 ${NumberFormat('#,###').format(budgetInfo.targetAmount.toInt())}원',
              style: TextStyle(
                  fontSize: 12, color: context.appColors.textTertiary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAssetContent(BuildContext context, AssetEntity? assetInfo) {
    if (assetInfo == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
              _buildPageIndicator(context),
            ],
          ),
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

    final totalAssets = assetInfo.currentTotalAssets;
    final isNegative = totalAssets < 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            _buildPageIndicator(context),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${isNegative ? '-' : ''}${NumberFormat('#,###').format(totalAssets.abs().toInt())}원',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isNegative
                ? context.appColors.error
                : context.appColors.textPrimary,
          ),
        ),
        const Spacer(),
        // 수입/지출 요약
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '수입 ${NumberFormat('#,###').format(assetInfo.periodIncome.toInt())}원',
              style: TextStyle(
                fontSize: 12,
                color: context.appColors.success,
              ),
            ),
            Text(
              '지출 ${NumberFormat('#,###').format(assetInfo.periodExpense.toInt())}원',
              style: TextStyle(
                fontSize: 12,
                color: context.appColors.error,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
