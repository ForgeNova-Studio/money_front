import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/expense/presentation/utils/expense_category_utils.dart';
import 'package:moamoa/features/home/domain/entities/transaction_entity.dart';
import 'package:moamoa/features/home/presentation/widgets/swipe_to_reveal.dart';
import 'package:moamoa/features/income/presentation/utils/income_category_utils.dart';

class TransactionListItem extends StatelessWidget {
  const TransactionListItem({
    super.key,
    required this.transaction,
    this.onTap,
    this.onDelete,
    this.onRevealActiveChanged,
  });

  final TransactionEntity transaction;
  final VoidCallback? onTap;
  final Future<void> Function()? onDelete;
  final ValueChanged<bool>? onRevealActiveChanged;

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == TransactionType.expense;
    final color =
        isExpense ? context.appColors.error : context.appColors.success;
    final prefix = isExpense ? '-' : '+';
    final amountStr = NumberFormat('#,###').format(transaction.amount);
    final categoryLabel = _resolveCategoryLabel(isExpense);
    final categoryIcon = _resolveCategoryIcon(isExpense);
    final memo = transaction.memo;

    // title: 설명이 있으면 사용자 입력, 없으면 카테고리 한글 라벨
    final displayTitle =
        transaction.hasDescription ? transaction.title : categoryLabel;

    // subtitle: 카테고리 + memo 조합 (시간 제거, 중복 방지)
    String? subtitle;
    if (transaction.hasDescription && memo != null && memo.isNotEmpty) {
      subtitle = '$categoryLabel · $memo';
    } else if (transaction.hasDescription) {
      subtitle = categoryLabel;
    } else if (memo != null && memo.isNotEmpty) {
      subtitle = memo;
    }

    return SwipeToReveal(
      enabled: onDelete != null,
      onRevealActiveChanged: onRevealActiveChanged,
      actionButton: _DeleteButton(
        onTap: () => onDelete?.call(),
      ),
      child: _TransactionCard(
        onTap: onTap,
        categoryIcon: categoryIcon,
        isExpense: isExpense,
        title: displayTitle,
        subtitle: subtitle,
        amount: '$prefix$amountStr원',
        amountColor: color,
      ),
    );
  }

  String _resolveCategoryLabel(bool isExpense) {
    if (isExpense) {
      return resolveExpenseCategoryLabel(transaction.category);
    }
    return resolveIncomeCategoryLabel(transaction.category);
  }

  IconData _resolveCategoryIcon(bool isExpense) {
    if (isExpense) {
      return resolveExpenseCategoryIcon(transaction.category);
    }
    return resolveIncomeCategoryIcon(transaction.category);
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: context.appColors.error,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: context.appColors.error.withValues(alpha: 0.3),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({
    required this.onTap,
    required this.categoryIcon,
    required this.isExpense,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.amountColor,
  });

  final VoidCallback? onTap;
  final IconData categoryIcon;
  final bool isExpense;
  final String title;
  final String? subtitle;
  final String amount;
  final Color amountColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: context.appColors.gray50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  categoryIcon,
                  color: isExpense
                      ? context.appColors.textSecondary
                      : context.appColors.success,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          color: context.appColors.textTertiary,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                amount,
                style: TextStyle(
                  color: amountColor,
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
