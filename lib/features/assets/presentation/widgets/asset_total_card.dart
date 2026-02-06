import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/assets/domain/entities/asset_summary.dart';

/// 총 자산 표시 카드
class AssetTotalCard extends StatelessWidget {
  final AssetSummary summary;

  const AssetTotalCard({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
    final isPositive = summary.isPositive;
    final changePercent = summary.changePercent.abs().toStringAsFixed(1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: context.appColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: context.appColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 라벨
          Row(
            children: [
              Icon(
                Icons.account_balance_wallet,
                color: context.appColors.textPrimary.withValues(alpha: 0.7),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                '총 자산',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.appColors.textPrimary.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 총 금액
          Text(
            '₩ ${numberFormat.format(summary.totalAmount)}',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: context.appColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),

          // 전월 대비 변화
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 14,
                  color: isPositive
                      ? context.appColors.success
                      : context.appColors.error,
                ),
                const SizedBox(width: 4),
                Text(
                  '${isPositive ? '+' : '-'}₩${numberFormat.format(summary.previousMonthDiff.abs())}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isPositive
                        ? context.appColors.success
                        : context.appColors.error,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '(${isPositive ? '+' : '-'}$changePercent%)',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.appColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '지난달 대비',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.appColors.textSecondary,
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
