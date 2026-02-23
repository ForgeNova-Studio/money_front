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

  /// 카드사 선택 (단일 선택)
  void selectCardCompany(String cardCompanyId) {
    state = state.copyWith(selectedCardCompanyId: cardCompanyId);
  }

  /// 카드사 선택 해제
  void clearCardCompany() {
    state = state.copyWith(selectedCardCompanyId: null);
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
