import 'package:flutter_test/flutter_test.dart';
import 'package:moamoa/features/expense/domain/entities/expense.dart';

void main() {
  group('Expense.copyWith', () {
    test('allows explicitly clearing nullable fields with null', () {
      final original = Expense(
        expenseId: 'expense-1',
        amount: 8000,
        date: DateTime(2026, 2, 19),
        category: 'FOOD',
        merchant: 'Store',
        memo: 'memo',
        paymentMethod: 'CARD',
      );

      final updated = original.copyWith(
        merchant: null,
        memo: null,
        paymentMethod: null,
      );

      expect(updated.merchant, isNull);
      expect(updated.memo, isNull);
      expect(updated.paymentMethod, isNull);
      expect(updated.expenseId, original.expenseId);
      expect(updated.amount, original.amount);
    });
  });
}
