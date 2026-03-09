import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moamoa/core/constants/app_constants.dart';

class BudgetMonthSelector extends StatelessWidget {
  const BudgetMonthSelector({
    super.key,
    required this.selectedMonth,
    required this.isCurrentMonth,
    required this.onPrevious,
    required this.onNext,
    required this.onGoToCurrentMonth,
  });

  final DateTime selectedMonth;
  final bool isCurrentMonth;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onGoToCurrentMonth;

  @override
  Widget build(BuildContext context) {
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
              color: context.appColors.gray600,
              size: 28,
            ),
            onPressed: onPrevious,
          ),
          Expanded(
            child: Center(
              child: Text(
                DateFormat('yyyy년 M월').format(selectedMonth),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: context.appColors.textPrimary,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.chevron_right_rounded,
              color: context.appColors.gray600,
              size: 28,
            ),
            onPressed: onNext,
          ),
          if (!isCurrentMonth) ...[
            Container(
              height: 24,
              width: 1,
              color: context.appColors.gray200,
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
                  color: context.appColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
