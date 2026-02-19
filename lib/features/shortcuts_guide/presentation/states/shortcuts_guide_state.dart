import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:moamoa/core/models/card_company.dart';

// CardCompany 모델 re-export
export 'package:moamoa/core/models/card_company.dart';

part 'shortcuts_guide_state.freezed.dart';

/// 단축어 가이드 화면 상태
@freezed
sealed class ShortcutsGuideState with _$ShortcutsGuideState {
  const ShortcutsGuideState._();

  const factory ShortcutsGuideState({
    /// 현재 단계 (0-indexed)
    @Default(0) int currentStep,

    /// 총 단계 수
    @Default(4) int totalSteps,

    /// 선택된 카드사 ID (단일 선택)
    String? selectedCardCompanyId,

    /// 설정 완료 여부
    @Default(false) bool isSetupComplete,

    /// 로딩 상태
    @Default(false) bool isLoading,

    /// 에러 메시지
    String? errorMessage,
  }) = _ShortcutsGuideState;

  /// 선택된 카드사 정보
  CardCompany? get selectedCardCompany {
    if (selectedCardCompanyId == null) return null;
    return supportedCardCompanies.cast<CardCompany?>().firstWhere(
          (c) => c?.id == selectedCardCompanyId,
          orElse: () => null,
        );
  }

  /// 다음 단계로 이동 가능 여부
  bool get canProceedToNext {
    switch (currentStep) {
      case 0:
        // Step 1: 소개, 항상 진행 가능
        return true;
      case 1:
        // Step 2: 카드사 선택, 1개 선택해야 함
        return selectedCardCompanyId != null;
      case 2:
        // Step 3: 단축어 설치, 항상 진행 가능
        return true;
      case 3:
        // Step 4: 자동화 설정, 항상 진행 가능
        return true;
      default:
        return false;
    }
  }

  /// 마지막 단계인지 여부
  bool get isLastStep => currentStep >= totalSteps - 1;

  /// 첫 단계인지 여부
  bool get isFirstStep => currentStep == 0;

  /// 진행률 (0.0 ~ 1.0)
  double get progress => (currentStep + 1) / totalSteps;
}
