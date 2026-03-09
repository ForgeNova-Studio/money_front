import 'package:flutter_test/flutter_test.dart';
import 'package:moamoa/features/budget/presentation/utils/budget_amount_utils.dart';

void main() {
  group('budget_amount_utils', () {
    test('parseFormattedAmount strips non-digit characters', () {
      expect(parseFormattedAmount('1,234,567원'), 1234567);
      expect(parseFormattedAmount(' 98 76 '), 9876);
      expect(parseFormattedAmount('abc'), 0);
      expect(parseFormattedAmount(''), 0);
    });

    test('parseSignedFormattedAmount applies sign flag', () {
      expect(
        parseSignedFormattedAmount(rawText: '2,000', isNegative: false),
        2000,
      );
      expect(
        parseSignedFormattedAmount(rawText: '2,000', isNegative: true),
        -2000,
      );
      expect(
        parseSignedFormattedAmount(rawText: '', isNegative: true),
        0,
      );
    });

    test('buildBudgetMonthKey zero-pads month', () {
      expect(buildBudgetMonthKey(DateTime(2026, 2, 1)), '2026-02');
      expect(buildBudgetMonthKey(DateTime(2026, 11, 1)), '2026-11');
    });
  });
}
