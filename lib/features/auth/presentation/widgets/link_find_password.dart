import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

class LinkFindPassword extends StatelessWidget {
  final VoidCallback onTap;

  const LinkFindPassword({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: context.appColors.textSecondary,
                width: 1.0,
              ),
            ),
          ),
          child: Text(
            '비밀번호를 잊으셨나요?',
            style: TextStyle(
              fontSize: 15,
              color: context.appColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
