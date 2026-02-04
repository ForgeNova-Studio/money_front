import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:moamoa/features/shortcuts_guide/presentation/states/shortcuts_guide_state.dart';

// State re-export for convenience
export 'package:moamoa/features/shortcuts_guide/presentation/states/shortcuts_guide_state.dart';

part 'shortcuts_guide_view_model.g.dart';

/// 지원하는 카드사 목록
const List<CardCompany> supportedCardCompanies = [
  CardCompany(
    id: 'shinhan',
    name: '신한카드',
    iconPath: 'assets/icons/cards/shinhan.png',
    shortcutUrl: 'https://www.icloud.com/shortcuts/ce73c347719b47b585a731effbf24b99',
  ),
  CardCompany(
    id: 'samsung',
    name: '삼성카드',
    iconPath: 'assets/icons/cards/samsung.png',
    shortcutUrl: 'https://www.icloud.com/shortcuts/f48c5b14bf9c4cb5bc950bb0b370b3df',
  ),
  CardCompany(
    id: 'kb',
    name: 'KB국민카드',
    iconPath: 'assets/icons/cards/kb.png',
    shortcutUrl: 'https://www.icloud.com/shortcuts/kb_example',
  ),
  CardCompany(
    id: 'hyundai',
    name: '현대카드',
    iconPath: 'assets/icons/cards/hyundai.png',
    shortcutUrl: 'https://www.icloud.com/shortcuts/hyundai_example',
  ),
  CardCompany(
    id: 'lotte',
    name: '롯데카드',
    iconPath: 'assets/icons/cards/lotte.png',
    shortcutUrl: 'https://www.icloud.com/shortcuts/lotte_example',
  ),
  CardCompany(
    id: 'woori',
    name: '우리카드',
    iconPath: 'assets/icons/cards/woori.png',
    shortcutUrl: 'https://www.icloud.com/shortcuts/woori_example',
  ),
  CardCompany(
    id: 'hana',
    name: '하나카드',
    iconPath: 'assets/icons/cards/hana.png',
    shortcutUrl: 'https://www.icloud.com/shortcuts/hana_example',
  ),
  CardCompany(
    id: 'nh',
    name: 'NH농협카드',
    iconPath: 'assets/icons/cards/nh.png',
    shortcutUrl: 'https://www.icloud.com/shortcuts/nh_example',
  ),
  CardCompany(
    id: 'bc',
    name: 'BC카드',
    iconPath: 'assets/icons/cards/bc.png',
    shortcutUrl: 'https://www.icloud.com/shortcuts/bc_example',
  ),
];

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
