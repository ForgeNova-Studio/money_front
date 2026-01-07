import 'package:flutter/material.dart';
import 'package:moneyflow/core/constants/app_constants.dart';

class TransactionEmptyState extends StatelessWidget {
  const TransactionEmptyState({super.key, required this.selectedDate});

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 48, color: context.appColors.gray300),
          SizedBox(height: 16),
          Text(
            '${selectedDate.month}월 ${selectedDate.day}일 내역이 없습니다.',
            style: TextStyle(color: context.appColors.textTertiary),
          ),
        ],
      ),
    );
  }
}
