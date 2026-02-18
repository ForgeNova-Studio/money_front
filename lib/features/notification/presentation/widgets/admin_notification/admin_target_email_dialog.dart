import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

Future<String?> showAdminTargetEmailDialog({
  required BuildContext context,
  required AppThemeColors appColors,
  required TextEditingController emailController,
}) {
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('특정 사용자에게 전송'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '전송할 사용자의 이메일을 입력하세요',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'example@email.com',
              filled: true,
              fillColor: appColors.backgroundGray,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(dialogContext, emailController.text.trim());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: appColors.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('전송'),
        ),
      ],
    ),
  );
}
