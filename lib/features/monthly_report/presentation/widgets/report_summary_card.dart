import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/monthly_report/domain/entities/monthly_report_entity.dart';
import 'package:moamoa/features/monthly_report/presentation/widgets/animated_number.dart';

/// 총 지출/수입 요약 카드
class ReportSummaryCard extends StatelessWidget {
  final MonthlyReportEntity report;

  const ReportSummaryCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    final isPositiveChange = (report.changePercent ?? 0) < 0; // 음수면 절약

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
          const Text(
            '💰',
            style: TextStyle(fontSize: 48),
          ),
          const SizedBox(height: 16),

          const Text(
            '이번 달 총 정리',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),

          // 지출
          _buildAmountRow(
              '지출', report.totalExpense, AppColors.error, formatter),
          const SizedBox(height: 16),

          // 수입
          _buildAmountRow(
              '수입', report.totalIncome, AppColors.success, formatter),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: AppColors.divider),
          ),

          // 순수익
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '순수익',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              AnimatedNumber(
                value: report.netIncome,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: report.netIncome >= 0
                      ? AppColors.success
                      : AppColors.error,
                ),
                prefix: report.netIncome >= 0 ? '+₩' : '₩',
              ),
            ],
          ),

          const SizedBox(height: 32),

          // 전월 대비
          if (report.changePercent != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isPositiveChange
                    ? AppColors.success.withValues(alpha: 0.1)
                    : AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isPositiveChange
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    size: 16,
                    color:
                        isPositiveChange ? AppColors.success : AppColors.error,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isPositiveChange
                        ? '지난 달보다 ${report.changePercent!.abs().toStringAsFixed(0)}% 절약! 🎊'
                        : '지난 달보다 ${report.changePercent!.abs().toStringAsFixed(0)}% 증가',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isPositiveChange
                          ? AppColors.success
                          : AppColors.error,
                    ),
                  ),
                ],
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
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
        AnimatedNumber(
          value: amount,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: color,
          ),
          prefix: '₩',
        ),
      ],
    );
  }
}
