import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/budget/presentation/widgets/budget_form_widgets.dart';

class BudgetSettingsActions extends StatelessWidget {
  const BudgetSettingsActions({
    super.key,
    required this.hasBudget,
    required this.hasValue,
    required this.isSaving,
    required this.isDeleting,
    required this.onSave,
    required this.onDelete,
  });

  final bool hasBudget;
  final bool hasValue;
  final bool isSaving;
  final bool isDeleting;
  final VoidCallback onSave;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isBusy = isSaving || isDeleting;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasBudget)
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: isBusy ? null : onDelete,
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: context.appColors.error,
                      size: 18,
                    ),
                    label: Text(
                      '이 달 예산 삭제',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: context.appColors.error,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: context.appColors.error.withValues(alpha: 0.3),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '삭제해도 지출/수입 내역은 유지됩니다.',
                  style: TextStyle(
                    fontSize: 12,
                    color: context.appColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        BudgetSaveButton(
          isSaving: isSaving,
          enabled: hasValue && !isDeleting,
          onPressed: onSave,
        ),
      ],
    );
  }
}
