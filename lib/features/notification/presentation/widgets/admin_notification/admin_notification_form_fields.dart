import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

class AdminNotificationFormFields extends StatelessWidget {
  final AppThemeColors appColors;
  final TextEditingController titleController;
  final TextEditingController messageController;
  final String? Function(String?) titleValidator;
  final String? Function(String?) messageValidator;
  final int titleMaxLength;
  final int messageMaxLength;

  const AdminNotificationFormFields({
    super.key,
    required this.appColors,
    required this.titleController,
    required this.messageController,
    required this.titleValidator,
    required this.messageValidator,
    required this.titleMaxLength,
    required this.messageMaxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '제목',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: appColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: titleController,
          maxLength: titleMaxLength,
          decoration: _buildInputDecoration(
            hintText: '알림 제목을 입력하세요',
          ),
          validator: titleValidator,
        ),
        const SizedBox(height: 20),
        Text(
          '내용',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: appColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: messageController,
          maxLines: 6,
          maxLength: messageMaxLength,
          decoration: _buildInputDecoration(
            hintText: '알림 내용을 입력하세요',
            contentPadding: const EdgeInsets.all(16),
          ),
          validator: messageValidator,
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    EdgeInsetsGeometry contentPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 14,
    ),
  }) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: appColors.backgroundGray,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: contentPadding,
    );
  }
}
