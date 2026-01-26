import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/home/presentation/widgets/animated_amount_text.dart';

class TransactionModalHeader extends StatelessWidget {
  const TransactionModalHeader({
    super.key,
    required this.selectedDate,
    required this.totalAmount,
    required this.totalIncome,
    required this.totalExpense,
    this.onCameraTap,
  });

  final DateTime selectedDate;
  final int totalAmount;
  final int totalIncome;
  final int totalExpense;
  final VoidCallback? onCameraTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // 왼쪽: 날짜와 전체 합계 (Max 50%)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${selectedDate.month}월 ${selectedDate.day}일 ${_weekdayLabel(selectedDate.weekday)}요일',
                      style: TextStyle(
                        fontSize: 15,
                        color: context.appColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: AnimatedAmountText(
                        amount: totalAmount,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: context.appColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // 오른쪽: 수입/지출 상세 (Max 50%)
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // 수입
                        if (totalIncome > 0)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: context.appColors.success
                                        .withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.arrow_downward_rounded,
                                    size: 12,
                                    color: context.appColors.success,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '수입',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: context.appColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                AnimatedAmountText(
                                  amount: totalIncome,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: context.appColors.success,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        // 지출
                        if (totalExpense > 0)
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color:
                                      context.appColors.error.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.arrow_upward_rounded,
                                  size: 12,
                                  color: context.appColors.error,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '지출',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: context.appColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              AnimatedAmountText(
                                amount: totalExpense,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: context.appColors.error,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _weekdayLabel(int weekday) {
    const labels = ['월', '화', '수', '목', '금', '토', '일'];
    return labels[weekday - 1];
  }
}
