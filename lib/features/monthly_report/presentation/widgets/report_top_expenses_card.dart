import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/expense/presentation/utils/expense_category_utils.dart';
import 'package:moamoa/features/monthly_report/domain/entities/monthly_report_entity.dart';

/// TOP 3 지출 카드
class ReportTopExpensesCard extends StatelessWidget {
  final List<TopExpenseEntity> expenses;

  const ReportTopExpensesCard({super.key, required this.expenses});

  static const List<String> _medals = ['🥇', '🥈', '🥉'];

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,###');
    final dateFormatter = DateFormat('M월 d일');

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
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              '💸',
              style: TextStyle(fontSize: 40),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              '이번 달 BIG 지출',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // TOP 3 리스트
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                expenses.length.clamp(0, 3),
                (index) => TweenAnimationBuilder<Offset>(
                  tween: Tween(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ),
                  duration: Duration(milliseconds: 400 + (index * 200)),
                  curve: Curves.easeOutBack,
                  builder: (context, offset, child) {
                    return Transform.translate(
                      offset: Offset(offset.dx * 100, 0),
                      child: Opacity(
                        opacity: 1 - offset.dx.abs(),
                        child: child,
                      ),
                    );
                  },
                  child: _buildExpenseItem(
                    rank: index,
                    expense: expenses[index],
                    formatter: formatter,
                    dateFormatter: dateFormatter,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseItem({
    required int rank,
    required TopExpenseEntity expense,
    required NumberFormat formatter,
    required DateFormat dateFormatter,
  }) {
    final categoryName = resolveExpenseCategoryLabel(expense.category ?? 'UNCATEGORIZED');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundGray,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // 메달
          Text(
            _medals[rank],
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(width: 12),

          // 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.merchant ?? '미지정',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      dateFormatter.format(expense.date),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        categoryName,
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 금액
          Text(
            '₩${formatter.format(expense.amount)}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}
