import 'package:flutter/material.dart';

import 'package:moamoa/core/constants/app_constants.dart';

class TermsAgreementRow extends StatelessWidget {
  final bool isTermsAgreed;
  final VoidCallback onToggle;
  final VoidCallback onTermsTap;
  final VoidCallback onPrivacyTap;

  const TermsAgreementRow({
    super.key,
    required this.isTermsAgreed,
    required this.onToggle,
    required this.onTermsTap,
    required this.onPrivacyTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: isTermsAgreed,
            onChanged: (_) => onToggle(),
            activeColor: colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            side: BorderSide(
              color: colorScheme.outline,
              width: 1.5,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: context.appColors.textSecondary,
                      width: 1.0,
                    ),
                  ),
                ),
                child: GestureDetector(
                  onTap: onTermsTap,
                  child: Text(
                    '이용약관',
                    style: TextStyle(
                      fontSize: 14,
                      color: context.appColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Text(
                ' 및 ',
                style: TextStyle(
                  fontSize: 14,
                  color: context.appColors.textSecondary,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: context.appColors.textSecondary,
                      width: 1.0,
                    ),
                  ),
                ),
                child: GestureDetector(
                  onTap: onPrivacyTap,
                  child: Text(
                    '개인정보 이용동의',
                    style: TextStyle(
                      fontSize: 14,
                      color: context.appColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Text(
                '에 확인하고 동의합니다.',
                style: TextStyle(
                  fontSize: 14,
                  color: context.appColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
