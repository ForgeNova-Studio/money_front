import 'package:flutter/material.dart';

import 'package:moneyflow/features/auth/presentation/widgets/custom_text_field.dart';

class EmailVerificationRow extends StatelessWidget {
  final TextEditingController controller;
  final bool isEmailVerified;
  final VoidCallback onRequest;

  const EmailVerificationRow({
    super.key,
    required this.controller,
    required this.isEmailVerified,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CustomTextField(
            controller: controller,
            hintText: '이메일',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            enabled: !isEmailVerified,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: isEmailVerified ? null : onRequest,
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              disabledBackgroundColor: colorScheme.surfaceVariant,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: Text(
              isEmailVerified ? '인증완료' : '인증요청',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
