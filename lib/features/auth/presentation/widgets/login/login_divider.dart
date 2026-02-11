import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

// 가로 구분선 위젯
class LoginDivider extends StatelessWidget {
  const LoginDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: colorScheme.outlineVariant,
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: TextStyle(
              fontSize: 14,
              color: context.appColors.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: colorScheme.outlineVariant,
            thickness: 1,
          ),
        ),
      ],
    );
  }
}
