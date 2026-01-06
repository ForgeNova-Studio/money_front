import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:moneyflow/core/constants/app_constants.dart';
import 'package:moneyflow/features/home/domain/entities/daily_transaction_summary.dart';
import 'package:moneyflow/features/home/domain/entities/transaction_entity.dart';
import 'package:moneyflow/features/home/presentation/widgets/transaction_empty_state.dart';
import 'package:moneyflow/features/home/presentation/widgets/transaction_list_item.dart';
import 'package:moneyflow/features/home/presentation/widgets/transaction_modal_header.dart';

class TransactionListSection extends StatelessWidget {
  const TransactionListSection({
    super.key,
    required this.monthlyData,
    required this.selectedDate,
    this.isModal = false,
    this.onCameraTap,
  });

  final AsyncValue<Map<String, DailyTransactionSummary>> monthlyData;
  final DateTime selectedDate;
  final bool isModal;
  final VoidCallback? onCameraTap;

  @override
  Widget build(BuildContext context) {
    return monthlyData.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: Text('데이터를 불러오는데 실패했습니다.')),
      ),
      data: (data) {
        final dateKey = DateFormat('yyyy-MM-dd').format(selectedDate);
        final summary = data[dateKey];
        final transactions = summary?.transactions ?? [];
        final totalAmount =
            (summary?.totalIncome ?? 0) - (summary?.totalExpense ?? 0);
        final hasData = transactions.isNotEmpty;

        return Column(
          children: [
            if (isModal)
              TransactionModalHeader(
                selectedDate: selectedDate,
                totalAmount: totalAmount,
                onCameraTap: onCameraTap,
              )
            else
              _buildHeader(selectedDate, totalAmount),
            if (!hasData)
              TransactionEmptyState(selectedDate: selectedDate)
            else
              _buildListView(transactions),
          ],
        );
      },
    );
  }

  Widget _buildHeader(DateTime date, double totalAmount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${date.month}월 ${date.day}일',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.gray100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '전체 ${NumberFormat('#,###').format(totalAmount)}원',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView(List<TransactionEntity> transactions) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final tx = transactions[index];
        return TransactionListItem(
          transaction: tx,
          onTap: () {
            // TODO: Show transaction details modal
          },
        );
      },
    );
  }
}
