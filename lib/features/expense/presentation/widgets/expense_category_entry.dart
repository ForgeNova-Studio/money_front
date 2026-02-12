import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/core/constants/expense_categories.dart';
import 'package:moamoa/features/common/widgets/transaction_form/transaction_form_styles.dart';
import 'package:moamoa/features/expense/presentation/utils/expense_category_utils.dart';

class ExpenseCategoryEntry extends StatelessWidget {
  final ExpenseCategory category;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const ExpenseCategoryEntry({
    super.key,
    required this.category,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: transactionFormCardDecoration(
            context,
            backgroundColor:
                isSelected ? color.withValues(alpha: 0.12) : Colors.white,
          ),
          child: Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isSelected ? color : color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  expenseIconFromName(category.icon),
                  color: isSelected ? Colors.white : color,
                  size: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                category.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? color : context.appColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
