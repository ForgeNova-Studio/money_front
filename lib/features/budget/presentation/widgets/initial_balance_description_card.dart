import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

class InitialBalanceDescriptionCard extends StatelessWidget {
  const InitialBalanceDescriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.gray50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: context.appColors.textTertiary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '초기 잔액은 가계부 시작 시점의 자산을 의미합니다.\n총 자산 = 초기 잔액 + 총 수입 - 총 지출',
              style: TextStyle(
                fontSize: 13,
                color: context.appColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
