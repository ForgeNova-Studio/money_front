// packages
import 'package:freezed_annotation/freezed_annotation.dart';

// models
import 'package:moamoa/features/expense/data/models/expense_model.dart';

part 'expense_list_response_model.freezed.dart';
part 'expense_list_response_model.g.dart';

@freezed

/// 지출 목록 API 응답 모델
///
/// 서버로부터 수신한 지출 목록 데이터를 불변 객체로 정의합니다.
/// 목록 데이터 외에 총 금액, 전체 개수 등의 메타데이터를 포함할 수 있습니다.
///
/// **주요 속성:**
/// - [expenses]: 지출 목록 ([ExpenseModel])
/// - [totalAmount]: 목록의 총 합계 금액
/// - [count]: 목록의 아이템 개수
///
/// **사용 예시:**
/// ```dart
/// final response = ExpenseListResponseModel(
///   expenses: [...],
///   totalAmount: 50000,
///   count: 5,
/// );
/// ```
sealed class ExpenseListResponseModel with _$ExpenseListResponseModel {
  const factory ExpenseListResponseModel({
    required List<ExpenseModel> expenses,
    required int totalAmount,
    required int count,
  }) = _ExpenseListResponseModel;

  factory ExpenseListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExpenseListResponseModelFromJson(json);
}
