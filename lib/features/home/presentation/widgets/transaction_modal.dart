import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moamoa/router/route_names.dart';
import 'package:moamoa/core/constants/app_constants.dart';

class TransactionModal extends StatelessWidget {
  const TransactionModal({super.key, required this.selectedDate});

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '내역 추가',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: context.appColors.textPrimary,
            ),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    context.push(RouteNames.addIncome, extra: selectedDate);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: context.appColors.backgroundLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.arrow_downward,
                            color: context.appColors.success, size: 32),
                        SizedBox(height: 8),
                        Text(
                          '입금',
                          style: TextStyle(
                            color: context.appColors.success,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    context.push(RouteNames.addExpense, extra: selectedDate);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: context.appColors.backgroundLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.arrow_upward,
                            color: context.appColors.error, size: 32),
                        SizedBox(height: 8),
                        Text(
                          '지출',
                          style: TextStyle(
                            color: context.appColors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
