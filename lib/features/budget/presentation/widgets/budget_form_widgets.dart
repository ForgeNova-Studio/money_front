import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/common/widgets/transaction_form/thousands_separator_input_formatter.dart';

class BudgetAmountSuggestion {
  final int amount;
  final String label;

  const BudgetAmountSuggestion(this.amount, this.label);
}

class BudgetAmountInputCard extends StatelessWidget {
  final Widget header;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onChanged;
  final Color amountColor;
  final bool showNegativeSign;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry padding;
  final double headerBottomSpacing;

  const BudgetAmountInputCard({
    super.key,
    required this.header,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.amountColor,
    this.showNegativeSign = false,
    this.validator,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
    this.headerBottomSpacing = 20,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => focusNode.requestFocus(),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            header,
            SizedBox(height: headerBottomSpacing),
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    if (showNegativeSign)
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Text(
                          '-',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: amountColor,
                          ),
                        ),
                      ),
                    IntrinsicWidth(
                      child: TextFormField(
                        controller: controller,
                        focusNode: focusNode,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        onChanged: (_) => onChanged(),
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: amountColor,
                        ),
                        decoration: InputDecoration(
                          filled: false,
                          hintText: '0',
                          hintStyle: TextStyle(
                            color: context.appColors.gray300,
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                          ),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorStyle: const TextStyle(
                            height: 0,
                            color: Colors.transparent,
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          ThousandsSeparatorInputFormatter(maxDigits: 12),
                        ],
                        autofocus: false,
                        showCursor: false,
                        cursorColor: Colors.transparent,
                        validator: validator,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '원',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w600,
                        color: context.appColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BudgetQuickAmountGrid extends StatelessWidget {
  final bool showClear;
  final VoidCallback onClear;
  final List<BudgetAmountSuggestion> suggestions;
  final bool Function(int amount) isSelected;
  final void Function(int amount) onSelect;

  const BudgetQuickAmountGrid({
    super.key,
    required this.showClear,
    required this.onClear,
    required this.suggestions,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '빠른 입력',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: context.appColors.textSecondary,
              ),
            ),
            if (showClear) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onClear,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.appColors.gray100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '초기화',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: context.appColors.textTertiary,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.2,
          children: suggestions.map((item) {
            final selected = isSelected(item.amount);
            return GestureDetector(
              onTap: () => onSelect(item.amount),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? context.appColors.primary.withValues(alpha: 0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected
                        ? context.appColors.primary
                        : context.appColors.gray200,
                    width: selected ? 1.5 : 1,
                  ),
                  boxShadow: selected
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                ),
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected
                        ? context.appColors.primary
                        : context.appColors.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class BudgetSaveButton extends StatelessWidget {
  final bool isSaving;
  final bool enabled;
  final VoidCallback onPressed;

  const BudgetSaveButton({
    super.key,
    required this.isSaving,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: (!enabled || isSaving) ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.appColors.primary,
            disabledBackgroundColor: context.appColors.gray200,
            foregroundColor: Colors.white,
            disabledForegroundColor: context.appColors.gray400,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: isSaving
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  '저장하기',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ),
    );
  }
}
