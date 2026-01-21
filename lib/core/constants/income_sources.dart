import 'package:flutter/material.dart';

import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/income/domain/entities/income.dart';

class IncomeSourceItem {
  final String code;
  final String name;
  final IconData icon;
  final Color color;

  const IncomeSourceItem({
    required this.code,
    required this.name,
    required this.icon,
    required this.color,
  });
}

List<IncomeSourceItem> buildIncomeSources(BuildContext context) {
  return [
    IncomeSourceItem(
      code: IncomeSource.salary,
      name: '급여',
      icon: Icons.work,
      color: context.appColors.income,
    ),
    IncomeSourceItem(
      code: IncomeSource.sideIncome,
      name: '부수입',
      icon: Icons.attach_money,
      color: const Color(0xFF2E7D32),
    ),
    IncomeSourceItem(
      code: IncomeSource.bonus,
      name: '상여금',
      icon: Icons.card_giftcard,
      color: const Color(0xFFF57C00),
    ),
    IncomeSourceItem(
      code: IncomeSource.investment,
      name: '투자수익',
      icon: Icons.trending_up,
      color: const Color(0xFF1565C0),
    ),
    IncomeSourceItem(
      code: IncomeSource.other,
      name: '기타',
      icon: Icons.more_horiz,
      color: const Color(0xFF6D4C41),
    ),
  ];
}
