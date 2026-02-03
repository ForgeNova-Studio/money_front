import 'package:freezed_annotation/freezed_annotation.dart';

part 'shortcuts_guide_state.freezed.dart';

/// 카드사 정보
class CardCompany {
  final String id;
  final String name;
  final String iconPath;
  final String shortcutUrl; // iCloud 단축어 템플릿 URL

  const CardCompany({
    required this.id,
    required this.name,
    required this.iconPath,
    required this.shortcutUrl,
  });
}

/// 단축어 가이드 화면 상태
@freezed
sealed class ShortcutsGuideState with _$ShortcutsGuideState {
  const ShortcutsGuideState._();

  const factory ShortcutsGuideState({
    /// 현재 단계 (0-indexed)
    @Default(0) int currentStep,

    /// 총 단계 수
    @Default(4) int totalSteps,

    /// 선택된 카드사 목록
    @Default([]) List<String> selectedCardCompanyIds,

    /// 설정 완료 여부
    @Default(false) bool isSetupComplete,

    /// 로딩 상태
    @Default(false) bool isLoading,

    /// 에러 메시지
    String? errorMessage,
  }) = _ShortcutsGuideState;

  /// 다음 단계로 이동 가능 여부
  bool get canProceedToNext {
    switch (currentStep) {
      case 0:
        // Step 1: 소개, 항상 진행 가능
        return true;
      case 1:
        // Step 2: 카드사 선택, 1개 이상 선택해야 함
        return selectedCardCompanyIds.isNotEmpty;
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
