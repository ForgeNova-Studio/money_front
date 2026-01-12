// packages
import 'package:freezed_annotation/freezed_annotation.dart';

// entities
import 'package:moneyflow/features/expense/domain/entities/expense.dart';

part 'expense_model.freezed.dart';
part 'expense_model.g.dart';

@freezed
sealed class ExpenseModel with _$ExpenseModel {
  const ExpenseModel._();

  const factory ExpenseModel({
    String? expenseId,
    String? userId,
    String? coupleId,
    required double amount,
    required DateTime date,
    required String category,
    String? merchant,
    String? memo,
    required String paymentMethod,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ExpenseModel;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseModelFromJson(json);

  /// Domain Entity로 변환
  Expense toEntity() {
    return Expense(
      expenseId: expenseId,
      userId: userId,
      coupleId: coupleId,
      amount: amount,
      date: date,
      category: category,
      merchant: merchant,
      memo: memo,
      paymentMethod: paymentMethod,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Domain Entity로부터 생성
  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      expenseId: expense.expenseId,
      userId: expense.userId,
      coupleId: expense.coupleId,
      amount: expense.amount,
      date: expense.date,
      category: expense.category,
      merchant: expense.merchant,
      memo: expense.memo,
      paymentMethod: expense.paymentMethod,
      createdAt: expense.createdAt,
      updatedAt: expense.updatedAt,
    );
  }
}
