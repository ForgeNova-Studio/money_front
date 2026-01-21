import 'package:flutter/material.dart';

import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/auth/domain/entities/gender.dart';

class GenderSelectorRow extends StatelessWidget {
  final Gender? selectedGender;
  final ValueChanged<Gender> onSelected;

  const GenderSelectorRow({
    super.key,
    required this.selectedGender,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onSelected(Gender.male),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: selectedGender == Gender.male
                    ? context.appColors.primary.withValues(alpha: 0.1)
                    : context.appColors.gray100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selectedGender == Gender.male
                      ? context.appColors.primary
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '남성',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: selectedGender == Gender.male
                      ? context.appColors.primary
                      : context.appColors.textTertiary,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => onSelected(Gender.female),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: selectedGender == Gender.female
                    ? context.appColors.primary.withValues(alpha: 0.1)
                    : context.appColors.gray100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selectedGender == Gender.female
                      ? context.appColors.primary
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '여성',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: selectedGender == Gender.female
                      ? context.appColors.primary
                      : context.appColors.textTertiary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
