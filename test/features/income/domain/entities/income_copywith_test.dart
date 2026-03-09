import 'package:flutter_test/flutter_test.dart';
import 'package:moamoa/core/constants/income_categories.dart';
import 'package:moamoa/features/income/domain/entities/income.dart';

void main() {
  group('Income.copyWith', () {
    test('allows explicitly clearing description with null', () {
      final original = Income(
        incomeId: 'income-1',
        amount: 10000,
        date: DateTime(2026, 2, 19),
        source: IncomeCategoryCode.salary,
        description: 'salary',
      );

      final updated = original.copyWith(description: null);

      expect(updated.description, isNull);
      expect(updated.incomeId, original.incomeId);
      expect(updated.amount, original.amount);
    });
  });
}
