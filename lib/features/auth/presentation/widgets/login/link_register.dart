import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

class LinkRegister extends StatelessWidget {
  final VoidCallback onTap;

  const LinkRegister({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '모아모아가 처음이신가요? ',
            style: TextStyle(
              fontSize: 15,
              color: context.appColors.textSecondary,
            ),
          ),
          TextButton(
            onPressed: onTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              '회원가입',
              style: TextStyle(
                fontSize: 15,
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
