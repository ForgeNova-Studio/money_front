import 'package:intl/intl.dart';

String formatMoneyCompact(num amount) {
  if (amount == 0) return '0';

  final absAmount = amount.abs();
  final formatter = NumberFormat('#.#');

  if (absAmount >= 10000000000000000) {
    double value = amount / 10000000000000000;
    return '${formatter.format(value)}경';
  }
  if (absAmount >= 1000000000000) {
    double value = amount / 1000000000000;
    return '${formatter.format(value)}조';
  }
  if (absAmount >= 100000000) {
    double value = amount / 100000000;
    return '${formatter.format(value)}억';
  }
  if (absAmount >= 10000) {
    double value = amount / 10000;
    return '${formatter.format(value)}만';
  }

  return NumberFormat('#,###').format(amount);
}
