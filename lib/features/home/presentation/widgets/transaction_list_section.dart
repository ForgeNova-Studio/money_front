import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/home/domain/entities/daily_transaction_summary.dart';
import 'package:moamoa/features/home/domain/entities/transaction_entity.dart';
import 'package:moamoa/features/home/presentation/widgets/animated_amount_text.dart';
import 'package:moamoa/features/home/presentation/widgets/transaction_empty_state.dart';
import 'package:moamoa/features/home/presentation/widgets/transaction_list_item.dart';
import 'package:moamoa/features/home/presentation/widgets/transaction_modal_header.dart';
import 'package:moamoa/router/route_names.dart';

class TransactionListSection extends StatelessWidget {
  const TransactionListSection({
    super.key,
    required this.monthlyData,
    required this.selectedDate,
    this.isModal = false,
    this.onCameraTap,
    this.onDelete,
  });

  final AsyncValue<Map<String, DailyTransactionSummary>> monthlyData;
  final DateTime selectedDate;
  final bool isModal;
  final VoidCallback? onCameraTap;
  final Future<void> Function(TransactionEntity transaction)? onDelete;

  @override
  Widget build(BuildContext context) {
    return monthlyData.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(32.0),
        child: _CenteredLoadingIndicator(),
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
              _buildHeader(context, selectedDate, totalAmount),
            if (!hasData)
              TransactionEmptyState(selectedDate: selectedDate)
            else
              _buildListView(transactions),
          ],
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    DateTime date,
    double totalAmount,
  ) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${date.month}월 ${date.day}일',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: context.appColors.textPrimary,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: context.appColors.gray100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '전체 ',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.appColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AnimatedAmountText(
                  amount: totalAmount,
                  style: TextStyle(
                    fontSize: 12,
                    color: context.appColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
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
          onTap: tx.id.isEmpty
              ? null
              : () {
                  if (tx.type == TransactionType.expense) {
                    context.push(RouteNames.editExpense(tx.id));
                  } else {
                    context.push(RouteNames.editIncome(tx.id));
                  }
                },
          onDelete:
              tx.id.isEmpty || onDelete == null ? null : () => onDelete!(tx),
        );
      },
    );
  }
}

class _CenteredLoadingIndicator extends StatelessWidget {
  const _CenteredLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.3;
    return SizedBox(
      height: height,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
