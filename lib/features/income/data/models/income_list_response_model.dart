// packages
import 'package:freezed_annotation/freezed_annotation.dart';

// models
import 'package:moamoa/features/income/data/models/income_model.dart';

part 'income_list_response_model.freezed.dart';
part 'income_list_response_model.g.dart';

/// 수입 목록 조회 API 응답 모델
///
/// 서버로부터 수신한 수입 목록 데이터를 캡슐화합니다.
///
/// **주요 속성:**
/// - [incomes]: 수입 내역 리스트 ([IncomeModel])
/// - [totalAmount]: 총 수입 금액
/// - [count]: 조회된 수입 건수
@freezed
sealed class IncomeListResponseModel with _$IncomeListResponseModel {
  const factory IncomeListResponseModel({
    required List<IncomeModel> incomes,
    required int totalAmount,
    required int count,
  }) = _IncomeListResponseModel;

  factory IncomeListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$IncomeListResponseModelFromJson(json);
}
