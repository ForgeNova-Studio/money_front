import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/budget/domain/providers/budget_usecase_providers.dart';
import 'package:moamoa/features/budget/presentation/constants/budget_error_messages.dart';
import 'package:moamoa/features/budget/presentation/states/initial_balance_settings_state.dart';
import 'package:moamoa/features/budget/presentation/utils/budget_amount_utils.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'initial_balance_settings_view_model.g.dart';

/// 초기 잔액 설정 화면 뷰모델
///
/// 사용자의 가계부 초기 잔액(자산의 시작 금액)을 설정하고 관리하기 위한 상태와 비즈니스 로직을 제공하는 Riverpod Notifier 기반의 뷰모델입니다.
/// 화면의 상태를 [InitialBalanceSettingsState]로 관리하며, 초기 잔액의 조회, 부호 변경, 저장 등의 작업을 수행합니다.
///
/// **Key Features:**
/// *   현재 가계부의 총 자산 및 설정된 초기 잔액 정보 로드
/// *   사용자 입력에 따른 초기 잔액 부호(양수/음수) 상태 관리
/// *   입력된 금액 파싱 및 가계부 초기 잔액 업데이트 처리
/// *   UI 피드백을 위한 토스트 메시지 및 에러 이벤트([InitialBalanceSettingsEvent]) 발행
///
/// **Usage Example:**
/// ```dart
/// // UI 레이어에서 ViewModel의 상태를 구독하고 액션을 호출
/// final state = ref.watch(initialBalanceSettingsViewModelProvider);
/// final viewModel = ref.read(initialBalanceSettingsViewModelProvider.notifier);
///
/// // 금액 부호 변경
/// viewModel.setNegative(true);
///
/// // 초기 잔액 저장 액션 호출
/// await viewModel.saveInitialBalance(rawText: '1,500,000');
/// ```
@riverpod
class InitialBalanceSettingsViewModel
    extends _$InitialBalanceSettingsViewModel {
  bool _initialized = false;

  @override
  InitialBalanceSettingsState build() {
    return InitialBalanceSettingsState.initial();
  }

  /// 초기 잔액 설정 초기화 담당
  /// - 현재 설정된 잔액을 가져온다
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    await _loadCurrentAssets();
  }

  /// 현재 설정된 잔액을 가져온다
  /// - 잔액은 가계부에 귀속된 잔액으로 가계부당 하나의 데이터만 존재한다.
  Future<void> _loadCurrentAssets() async {
    // 가계부 ID 가져온다
    final accountBookId = _resolveAccountBookId();
    if (accountBookId == null) return;

    state = state.copyWith(isLoading: true);

    try {
      final assets = await ref.read(getTotalAssetsUseCaseProvider)(
        accountBookId: accountBookId,
      );

      if (!ref.mounted) return;

      final absValue = assets.initialBalance.abs().toInt();

      state = state.copyWith(
        currentTotalAssets: assets.currentTotalAssets,
        isNegative: assets.initialBalance < 0,
        initialAmount: absValue,
      );
    } catch (_) {
      if (!ref.mounted) return;
      _showError(BudgetErrorMessages.initialBalanceLoadFailed);
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  /// 이벤트가 종료되면 이벤트를 비운다
  void clearEvent() {
    if (state.event == null) return;
    state = state.copyWith(event: null);
  }

  /// 초기 잔액의 부호를 음으로 변경
  void setNegative(bool isNegative) {
    if (state.isNegative == isNegative) return;
    state = state.copyWith(isNegative: isNegative);
  }

  /// 잔액을 저장한다.
  Future<void> saveInitialBalance({required String rawText}) async {
    if (state.isSaving) return;

    final accountBookId = _resolveAccountBookId();
    if (accountBookId == null) {
      _showError(BudgetErrorMessages.accountBookNotSelected);
      return;
    }

    final amount = parseSignedFormattedAmount(
      rawText: rawText,
      isNegative: state.isNegative,
    );

    state = state.copyWith(isSaving: true);

    try {
      await ref.read(updateInitialBalanceUseCaseProvider)(
        accountBookId: accountBookId,
        initialBalance: amount,
      );

      await ref.read(homeViewModelProvider.notifier).refresh();

      if (!ref.mounted) return;
      state = state.copyWith(
        event: const InitialBalanceSettingsPopWithToast('초기 잔액이 저장되었습니다.'),
      );
    } catch (_) {
      if (!ref.mounted) return;
      _showError(BudgetErrorMessages.initialBalanceSaveFailed);
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isSaving: false);
      }
    }
  }

  /// 선택된 가계부의 ID를 반환한다.
  String? _resolveAccountBookId() {
    final accountBookState = ref.read(selectedAccountBookViewModelProvider);
    return accountBookState.asData?.value;
  }

  /// 에러 이벤트를 추가한다.
  /// [message]를 포함한 [InitialBalanceSettingsShowError] 이벤트를 추가한다.
  void _showError(String message) {
    state = state.copyWith(event: InitialBalanceSettingsShowError(message));
  }
}
