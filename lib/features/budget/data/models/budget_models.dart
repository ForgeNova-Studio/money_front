import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/budget/domain/entities/asset_entity.dart';

part 'budget_models.freezed.dart';
part 'budget_models.g.dart';

/// 예산 응답 모델 (API -> Domain)
///
/// 서버(API)에서 전달받은 예산 관련 데이터를 매핑하는 DTO(Data Transfer Object)입니다.
/// Freezed 패키지를 사용하여 불변 객체로 생성되며, `BudgetEntity`로 변환할 수 있는 기능(`toEntity`)을 제공합니다.
///
/// **Key Features:**
/// *   JSON 데이터를 Dart 객체로 직렬화/역직렬화 (`fromJson`)
/// *   도메인 레이어에서 사용할 수 있는 `BudgetEntity`로 변환 (`toEntity`)
///
/// **Parameters:**
/// *   [budgetId] - 예산의 고유 식별자
/// *   [userId] - 예산을 소유한 사용자의 식별자
/// *   [year] - 예산이 설정된 연도
/// *   [month] - 예산이 설정된 월
/// *   [targetAmount] - 설정된 목표 예산 금액
/// *   [currentSpending] - 현재까지 지출된 금액
/// *   [remainingAmount] - 남은 예산 금액 (목표 예산 - 지출 금액)
/// *   [usagePercentage] - 예산 사용량 백분율
///
/// **Usage Example:**
/// ```dart
/// // JSON 응답을 모델로 변환
/// final responseModel = BudgetResponseModel.fromJson(jsonData);
///
/// // 도메인 모델로 변환하여 Repository 등에서 사용
/// final budgetEntity = responseModel.toEntity();
/// ```
@freezed
sealed class BudgetResponseModel with _$BudgetResponseModel {
  const BudgetResponseModel._();

  const factory BudgetResponseModel({
    required String budgetId,
    required String userId,
    required int year,
    required int month,
    required double targetAmount,
    required double currentSpending,
    required double remainingAmount,
    required double usagePercentage,
  }) = _BudgetResponseModel;

  factory BudgetResponseModel.fromJson(Map<String, dynamic> json) =>
      _$BudgetResponseModelFromJson(json);

  BudgetEntity toEntity() {
    return BudgetEntity(
      budgetId: budgetId,
      year: year,
      month: month,
      targetAmount: targetAmount,
      currentSpending: currentSpending,
      remainingAmount: remainingAmount,
      usagePercentage: usagePercentage,
    );
  }
}

/// 자산 응답 모델 (API -> Domain)
///
/// 서버(API)에서 전달받은 자산(통계) 관련 데이터를 매핑하는 DTO(Data Transfer Object)입니다.
/// Freezed 패키지를 사용하여 불변 객체로 생성되며, `AssetEntity`로 변환할 수 있는 기능(`toEntity`)을 제공합니다.
///
/// **Key Features:**
/// *   JSON 데이터를 Dart 객체로 직렬화/역직렬화 (`fromJson`)
/// *   도메인 레이어에서 사용할 수 있는 `AssetEntity`로 변환 (`toEntity`)
///
/// **Parameters:**
/// *   [accountBookId] - 조회된 가계부의 고유 식별자
/// *   [accountBookName] - 조회된 가계부의 이름
/// *   [currentTotalAssets] - 현재 보유 중인 총 자산 (초기 잔액 + 총 수입 - 총 지출)
/// *   [initialBalance] - 가계부 생성 시 설정한 초기 잔액 (지갑 및 통장 잔고의 합 등)
/// *   [totalIncome] - 생성 후 부터 누적된 전체 수입
/// *   [totalExpense] - 생성 후 부터 누적된 전체 지출
/// *   [periodIncome] - 이번 달(또는 지정된 기간) 수입
/// *   [periodExpense] - 이번 달(또는 지정된 기간) 지출
/// *   [periodNetIncome] - 이번 달(또는 지정된 기간) 순수익
///
/// **Usage Example:**
/// ```dart
/// // JSON 응답을 모델로 변환
/// final responseModel = AssetResponseModel.fromJson(jsonData);
///
/// // 도메인 모델로 변환하여 Repository 등에서 사용
/// final assetEntity = responseModel.toEntity();
/// ```
@freezed
sealed class AssetResponseModel with _$AssetResponseModel {
  const AssetResponseModel._();

  const factory AssetResponseModel({
    required String accountBookId,
    required String accountBookName,
    required double currentTotalAssets,
    required double initialBalance,
    required double totalIncome,
    required double totalExpense,
    required double periodIncome,
    required double periodExpense,
    required double periodNetIncome,
  }) = _AssetResponseModel;

  factory AssetResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AssetResponseModelFromJson(json);

  AssetEntity toEntity() {
    return AssetEntity(
      accountBookId: accountBookId,
      accountBookName: accountBookName,
      currentTotalAssets: currentTotalAssets,
      initialBalance: initialBalance,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      periodIncome: periodIncome,
      periodExpense: periodExpense,
      periodNetIncome: periodNetIncome,
    );
  }
}
