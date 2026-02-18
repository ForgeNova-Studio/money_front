import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/notification/presentation/models/admin_notification_type.dart';

class AdminNotificationTypeSelector extends StatelessWidget {
  final AppThemeColors appColors;
  final AdminNotificationType selectedType;
  final ValueChanged<AdminNotificationType> onChanged;

  const AdminNotificationTypeSelector({
    super.key,
    required this.appColors,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '알림 유형',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: appColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AdminNotificationType.values.map((type) {
            final isSelected = selectedType == type;
            final color = type.color;
            return GestureDetector(
              onTap: () => onChanged(type),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? color.withValues(alpha: 0.15)
                      : appColors.backgroundGray,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? color : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      type.icon,
                      size: 18,
                      color: isSelected ? color : appColors.textTertiary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      type.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? color : appColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
