import 'package:flutter/material.dart';

import 'package:moamoa/core/constants/app_constants.dart';

class TransactionTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool multiline;
  final int? minLines;
  final EdgeInsetsGeometry? contentPadding;

  const TransactionTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.multiline = false,
    this.minLines,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedMinLines = multiline ? (minLines ?? 1) : 1;
    return Row(
      children: [
        Icon(icon, color: context.appColors.textSecondary, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: context.appColors.gray400),
              border: InputBorder.none,
              contentPadding: contentPadding ??
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
            ),
            style:
                TextStyle(color: context.appColors.textPrimary, fontSize: 16),
            keyboardType:
                multiline ? TextInputType.multiline : TextInputType.text,
            textInputAction:
                multiline ? TextInputAction.newline : TextInputAction.done,
            minLines: resolvedMinLines,
            maxLines: multiline ? null : 1,
          ),
        ),
      ],
    );
  }
}
