import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/monthly_report/domain/entities/monthly_report_entity.dart';

/// 예산 달성률 카드
class ReportBudgetCard extends StatelessWidget {
  final BudgetSummaryEntity budget;

  const ReportBudgetCard({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    final remaining = budget.targetAmount - budget.currentSpending;
    final isOverBudget = remaining < 0;
    final percentage = budget.usagePercentage.clamp(0, 150);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primaryLight, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowAccent,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isOverBudget ? '⚠️' : '🎯',
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 16),

          Text(
            isOverBudget ? '예산 초과!' : '예산 달성 현황',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isOverBudget ? AppColors.error : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 32),

          // 목표/지출/남은 금액
          _buildAmountRow(
              '목표', budget.targetAmount, AppColors.textSecondary, formatter),
          const SizedBox(height: 12),
          _buildAmountRow(
              '지출', budget.currentSpending, AppColors.error, formatter),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: AppColors.divider),
          ),

          _buildAmountRow(
            isOverBudget ? '초과' : '남은 금액',
            remaining.abs(),
            isOverBudget ? AppColors.error : AppColors.success,
            formatter,
          ),

          const SizedBox(height: 32),

          // 프로그레스 바
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: (percentage / 100).clamp(0.0, 1.0)),
            duration: const Duration(milliseconds: 1200),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: value,
                      minHeight: 16,
                      backgroundColor: AppColors.gray100,
                      valueColor: AlwaysStoppedAnimation(
                        _getProgressColor(percentage),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${budget.usagePercentage}%',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _getProgressColor(percentage),
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          // 멘트
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: _getProgressColor(percentage).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _getMessage(percentage),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _getProgressColor(percentage),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(
      String label, int amount, Color color, NumberFormat formatter) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          '₩${formatter.format(amount)}',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Color _getProgressColor(int percentage) {
    if (percentage <= 70) return AppColors.success;
    if (percentage <= 100) return AppColors.warning;
    return AppColors.error;
  }

  String _getMessage(int percentage) {
    if (percentage <= 70) return '여유 있어요! 🌟';
    if (percentage <= 100) return '잘 하고 있어요! 👏';
    return '조금 초과했어요 😅';
  }
}
