import 'package:flutter/material.dart';
import 'package:moamoa/features/income/domain/entities/income.dart';

String resolveIncomeCategoryLabel(String source) {
  switch (source) {
    case IncomeSource.salary:
      return '급여';
    case IncomeSource.sideIncome:
      return '부수입';
    case IncomeSource.allowance:
      return '용돈';
    case IncomeSource.bonus:
      return '상여금';
    case IncomeSource.investment:
      return '투자수익';
    case IncomeSource.other:
      return '기타';
    default:
      return source;
  }
}

IconData resolveIncomeCategoryIcon(String source) {
  switch (source) {
    case IncomeSource.salary:
      return Icons.work;
    case IncomeSource.sideIncome:
      return Icons.attach_money;
    case IncomeSource.allowance:
      return Icons.account_balance_wallet;
    case IncomeSource.bonus:
      return Icons.card_giftcard;
    case IncomeSource.investment:
      return Icons.trending_up;
    case IncomeSource.other:
      return Icons.more_horiz;
    default:
      return Icons.attach_money;
  }
}
