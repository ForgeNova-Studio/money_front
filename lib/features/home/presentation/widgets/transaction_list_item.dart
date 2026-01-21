import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/expense/presentation/utils/expense_category_utils.dart';
import 'package:moamoa/features/home/domain/entities/transaction_entity.dart';
import 'package:moamoa/features/income/presentation/utils/income_category_utils.dart';

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
    final color =
        isExpense ? context.appColors.error : context.appColors.success;
    final prefix = isExpense ? '-' : '+';
    final amountStr = NumberFormat('#,###').format(transaction.amount);
    final timeStr = DateFormat('HH:mm').format(transaction.date);
    final categoryLabel = _resolveCategoryLabel(transaction, isExpense);
    final categoryIcon = _resolveCategoryIcon(transaction, isExpense);

    return Slidable(
      key: ValueKey(
          '${transaction.id}-${transaction.createdAt.toIso8601String()}'),
      endActionPane: onDelete == null
          ? null
          : ActionPane(
              motion: DrawerMotion(),
              extentRatio: 0.24,
              children: [
                SlidableAction(
                  onPressed: (_) => onDelete?.call(),
                  backgroundColor: context.appColors.error,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: '삭제',
                ),
              ],
            ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: context.appColors.gray50,
                child: Icon(
                  categoryIcon,
                  color: isExpense
                      ? context.appColors.textSecondary
                      : context.appColors.success,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '$timeStr · $categoryLabel',
                      style: TextStyle(
                          color: context.appColors.textTertiary, fontSize: 12),
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

  String _resolveCategoryLabel(TransactionEntity transaction, bool isExpense) {
    if (isExpense) {
      return resolveExpenseCategoryLabel(transaction.category);
    }

    return resolveIncomeCategoryLabel(transaction.category);
  }

  IconData _resolveCategoryIcon(TransactionEntity transaction, bool isExpense) {
    if (isExpense) {
      return resolveExpenseCategoryIcon(transaction.category);
    }

    return resolveIncomeCategoryIcon(transaction.category);
  }
}
