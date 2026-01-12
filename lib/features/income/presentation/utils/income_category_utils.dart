import 'package:flutter/material.dart';
import 'package:moneyflow/features/income/domain/entities/income.dart';

String resolveIncomeCategoryLabel(String source) {
  switch (source) {
    case IncomeSource.salary:
    case 'SALARY':
      return '급여';
    case IncomeSource.sideIncome:
    case 'SIDE_INCOME':
      return '부수입';
    case IncomeSource.allowance:
    case 'ALLOWANCE':
      return '용돈';
    case IncomeSource.bonus:
    case 'BONUS':
      return '상여금';
    case IncomeSource.investment:
    case 'INVESTMENT':
      return '투자수익';
    case IncomeSource.other:
    case 'OTHER':
      return '기타';
    default:
      return source;
  }
}

IconData resolveIncomeCategoryIcon(String source) {
  switch (source) {
    case IncomeSource.salary:
    case 'SALARY':
      return Icons.work;
    case IncomeSource.sideIncome:
    case 'SIDE_INCOME':
      return Icons.attach_money;
    case IncomeSource.allowance:
    case 'ALLOWANCE':
      return Icons.account_balance_wallet;
    case IncomeSource.bonus:
    case 'BONUS':
      return Icons.card_giftcard;
    case IncomeSource.investment:
    case 'INVESTMENT':
      return Icons.trending_up;
    case IncomeSource.other:
    case 'OTHER':
      return Icons.more_horiz;
    default:
      return Icons.attach_money;
  }
}
