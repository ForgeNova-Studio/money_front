import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/core/constants/income_sources.dart';
import 'package:moamoa/features/common/widgets/transaction_form/transaction_form_styles.dart';

class IncomeSourceEntry extends StatelessWidget {
  final IncomeSourceItem source;
  final bool isSelected;
  final VoidCallback onTap;

  const IncomeSourceEntry({
    super.key,
    required this.source,
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
            backgroundColor: isSelected
                ? source.color.withValues(alpha: 0.12)
                : Colors.white,
          ),
          child: Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isSelected
                      ? source.color
                      : source.color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    source.imagePath,
                    width: 20,
                    height: 20,
                    fit: BoxFit.contain,
                    color: isSelected ? Colors.white : source.color,
                    gaplessPlayback: true,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                source.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected
                      ? source.color
                      : context.appColors.textSecondary,
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
