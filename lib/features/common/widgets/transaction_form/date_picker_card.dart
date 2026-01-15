import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:moneyflow/core/constants/app_constants.dart';
import 'package:moneyflow/features/common/widgets/transaction_form/transaction_form_card.dart';

class DatePickerCard extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback onTap;

  const DatePickerCard({
    super.key,
    required this.selectedDate,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: TransactionFormCard(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: context.appColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_today,
                color: context.appColors.primary,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                DateFormat('yyyy년 M월 d일 (E)', 'ko_KR').format(selectedDate),
                style: TextStyle(
                  fontSize: 16,
                  color: context.appColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: context.appColors.gray400,
            ),
          ],
        ),
      ),
    );
  }
}
