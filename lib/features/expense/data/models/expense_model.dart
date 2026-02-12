// packages
import 'package:freezed_annotation/freezed_annotation.dart';

// entities
import 'package:moamoa/features/expense/domain/entities/expense.dart';

part 'expense_model.freezed.dart';
part 'expense_model.g.dart';

@freezed

/// 지출 데이터 모델 (DTO)
///
/// API 통신 시 사용되는 데이터 전송 객체입니다.
/// JSON 직렬화/역직렬화를 지원하며, Domain Entity와의 변환 메서드를 제공합니다.
///
/// **주요 기능:**
/// - JSON <-> Model 변환
/// - Model <-> Entity 변환 ([toEntity], [fromEntity])
///
/// **주요 속성:**
/// - [expenseId], [amount], [date] 등 지출 데이터 필드
///
/// **사용 예시:**
/// ```dart
/// final model = ExpenseModel.fromJson(json);
/// final entity = model.toEntity();
/// ```
sealed class ExpenseModel with _$ExpenseModel {
  const ExpenseModel._();

  const factory ExpenseModel({
    String? expenseId,
    String? userId,
    String? accountBookId,
    String? fundingSource,
    required int amount,
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
