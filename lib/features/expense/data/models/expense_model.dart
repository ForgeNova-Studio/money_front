// packages
import 'package:freezed_annotation/freezed_annotation.dart';

// entities
import 'package:moamoa/features/expense/domain/entities/expense.dart';

part 'expense_model.freezed.dart';
part 'expense_model.g.dart';

@freezed
sealed class ExpenseModel with _$ExpenseModel {
  const ExpenseModel._();

  const factory ExpenseModel({
    String? expenseId,
    String? userId,
    String? accountBookId,
    String? fundingSource,
    required double amount,
    required DateTime date,
    String? category,
    String? merchant,
    String? memo,
    String? paymentMethod,
    String? imageUrl,
    bool? isAutoCategorized,
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
      accountBookId: accountBookId,
      fundingSource: fundingSource,
      amount: amount,
      date: date,
      category: category,
      merchant: merchant,
      memo: memo,
      paymentMethod: paymentMethod,
      imageUrl: imageUrl,
      isAutoCategorized: isAutoCategorized,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Domain Entity로부터 생성
  factory ExpenseModel.fromEntity(Expense expense) {
    return ExpenseModel(
      expenseId: expense.expenseId,
      userId: expense.userId,
      accountBookId: expense.accountBookId,
      fundingSource: expense.fundingSource,
      amount: expense.amount,
      date: expense.date,
      category: expense.category,
      merchant: expense.merchant,
      memo: expense.memo,
      paymentMethod: expense.paymentMethod,
      imageUrl: expense.imageUrl,
      isAutoCategorized: expense.isAutoCategorized,
      createdAt: expense.createdAt,
      updatedAt: expense.updatedAt,
    );
  }
}
