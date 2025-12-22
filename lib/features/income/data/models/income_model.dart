// packages
import 'package:freezed_annotation/freezed_annotation.dart';

// entities
import 'package:moneyflow/features/income/domain/entities/income.dart';

part 'income_model.freezed.dart';
part 'income_model.g.dart';

@freezed
sealed class IncomeModel with _$IncomeModel {
  const IncomeModel._();

  const factory IncomeModel({
    String? incomeId,
    String? userId,
    String? coupleId,
    required double amount,
    required DateTime date,
    required String source,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _IncomeModel;

  factory IncomeModel.fromJson(Map<String, dynamic> json) =>
      _$IncomeModelFromJson(json);

  // toJson은 자동 생성

  // ✅ 커스텀 메서드들은 그대로 유지
  /// Domain Entity로 변환
  Income toEntity() {
    return Income(
      incomeId: incomeId,
      userId: userId,
      coupleId: coupleId,
      amount: amount,
      date: date,
      source: source,
      description: description,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Domain Entity로부터 생성
  factory IncomeModel.fromEntity(Income income) {
    return IncomeModel(
      incomeId: income.incomeId,
      userId: income.userId,
      coupleId: income.coupleId,
      amount: income.amount,
      date: income.date,
      source: income.source,
      description: income.description,
      createdAt: income.createdAt,
      updatedAt: income.updatedAt,
    );
  }
}
