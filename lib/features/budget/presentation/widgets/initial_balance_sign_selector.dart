import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

class InitialBalanceSignSelector extends StatelessWidget {
  const InitialBalanceSignSelector({
    super.key,
    required this.isNegative,
    required this.onChanged,
  });

  final bool isNegative;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SignChip(
          selected: !isNegative,
          label: '플러스',
          color: context.appColors.success,
          onTap: () => onChanged(false),
        ),
        const SizedBox(width: 8),
        _SignChip(
          selected: isNegative,
          label: '마이너스',
          color: context.appColors.error,
          onTap: () => onChanged(true),
        ),
      ],
    );
  }
}

class _SignChip extends StatelessWidget {
  const _SignChip({
    required this.selected,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final bool selected;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color : context.appColors.gray100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? color : context.appColors.gray200,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : context.appColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
