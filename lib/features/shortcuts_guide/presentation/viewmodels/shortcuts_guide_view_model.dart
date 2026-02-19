import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:moamoa/features/shortcuts_guide/presentation/states/shortcuts_guide_state.dart';

// State re-export for convenience
export 'package:moamoa/features/shortcuts_guide/presentation/states/shortcuts_guide_state.dart';

part 'shortcuts_guide_view_model.g.dart';

@riverpod
class ShortcutsGuideViewModel extends _$ShortcutsGuideViewModel {
  @override
  ShortcutsGuideState build() {
    return const ShortcutsGuideState();
  }

  /// 다음 단계로 이동
  void nextStep() {
    if (!state.isLastStep) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  /// 이전 단계로 이동
  void previousStep() {
    if (!state.isFirstStep) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  /// 특정 단계로 이동
  void goToStep(int step) {
    if (step >= 0 && step < state.totalSteps) {
      state = state.copyWith(currentStep: step);
    }
  }

  /// 카드사 선택/해제 토글
  void toggleCardCompany(String cardCompanyId) {
    final currentSelection = List<String>.from(state.selectedCardCompanyIds);
    if (currentSelection.contains(cardCompanyId)) {
      currentSelection.remove(cardCompanyId);
    } else {
      currentSelection.add(cardCompanyId);
    }
    state = state.copyWith(selectedCardCompanyIds: currentSelection);
  }

  /// 카드사 전체 선택
  void selectAllCardCompanies() {
    final allIds = supportedCardCompanies.map((c) => c.id).toList();
    state = state.copyWith(selectedCardCompanyIds: allIds);
  }

  /// 카드사 전체 해제
  void deselectAllCardCompanies() {
    state = state.copyWith(selectedCardCompanyIds: []);
  }

  /// 선택된 카드사 목록 반환
  List<CardCompany> get selectedCardCompanies {
    return supportedCardCompanies
        .where((c) => state.selectedCardCompanyIds.contains(c.id))
        .toList();
  }

  /// 설정 완료 처리
  void completeSetup() {
    state = state.copyWith(isSetupComplete: true);
  }

  /// 에러 초기화
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  /// 상태 리셋
  void reset() {
    state = const ShortcutsGuideState();
  }
}
