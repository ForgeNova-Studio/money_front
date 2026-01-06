import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:moneyflow/core/constants/app_constants.dart';
import 'package:moneyflow/features/home/domain/entities/transaction_entity.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({
    super.key,
    required this.transaction,
    this.onTap,
    this.onDelete,
  });

  final TransactionEntity transaction;
  final VoidCallback? onTap;
  final Future<void> Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == TransactionType.expense;
    final color = isExpense ? AppColors.error : AppColors.success;
    final prefix = isExpense ? '-' : '+';
    final amountStr = NumberFormat('#,###').format(transaction.amount);
    final timeStr = DateFormat('HH:mm').format(transaction.date);

    return Slidable(
      key: ValueKey('${transaction.id}-${transaction.createdAt.toIso8601String()}'),
      endActionPane: onDelete == null
          ? null
          : ActionPane(
              motion: const DrawerMotion(),
              extentRatio: 0.24,
              children: [
                SlidableAction(
                  onPressed: (_) => onDelete?.call(),
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: '삭제',
                ),
              ],
            ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.gray50,
                child: Icon(
                  isExpense ? Icons.coffee : Icons.attach_money,
                  color:
                      isExpense ? AppColors.textSecondary : AppColors.success,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$timeStr · ${transaction.category}',
                      style: const TextStyle(
                          color: AppColors.textTertiary, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text(
                '$prefix$amountStr원',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
