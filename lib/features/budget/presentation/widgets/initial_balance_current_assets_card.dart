import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moamoa/core/constants/app_constants.dart';

class InitialBalanceCurrentAssetsCard extends StatelessWidget {
  const InitialBalanceCurrentAssetsCard({
    super.key,
    required this.currentTotalAssets,
  });

  final double currentTotalAssets;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    final isNegative = currentTotalAssets < 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNegative
            ? context.appColors.error.withValues(alpha: 0.1)
            : context.appColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isNegative
              ? context.appColors.error.withValues(alpha: 0.3)
              : context.appColors.success.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isNegative
                  ? context.appColors.error.withValues(alpha: 0.15)
                  : context.appColors.success.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: isNegative
                  ? context.appColors.error
                  : context.appColors.success,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '현재 총 자산',
                style: TextStyle(
                  fontSize: 13,
                  color: context.appColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${isNegative ? '-' : ''}${formatter.format(currentTotalAssets.abs().toInt())}원',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isNegative
                      ? context.appColors.error
                      : context.appColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
