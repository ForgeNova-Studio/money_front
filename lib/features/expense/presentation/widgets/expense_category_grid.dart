import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/core/constants/expense_categories.dart';
import 'package:moamoa/features/expense/presentation/widgets/expense_category_entry.dart';

class ExpenseCategoryGrid extends StatelessWidget {
  final String selectedCategoryId;
  final ValueChanged<String> onCategorySelected;

  const ExpenseCategoryGrid({
    super.key,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  Color _categoryColor(String hexColor) {
    final value = int.parse(hexColor, radix: 16);
    return Color(0xFF000000 | value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '카테고리',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: context.appColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final itemWidth = (constraints.maxWidth - 24) / 3;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: DefaultExpenseCategories.all.map((category) {
                final color = _categoryColor(category.color);
                return SizedBox(
                  width: itemWidth,
                  child: ExpenseCategoryEntry(
                    category: category,
                    color: color,
                    isSelected: selectedCategoryId == category.id,
                    onTap: () => onCategorySelected(category.id),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
