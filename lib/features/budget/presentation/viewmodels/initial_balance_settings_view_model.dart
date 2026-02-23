import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/budget/domain/providers/budget_usecase_providers.dart';
import 'package:moamoa/features/budget/presentation/states/initial_balance_settings_state.dart';
import 'package:moamoa/features/budget/presentation/utils/budget_amount_utils.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'initial_balance_settings_view_model.g.dart';

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
      _showError('초기 잔액 정보를 불러오지 못했습니다. 다시 시도해주세요.');
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
      _showError('가계부를 선택해주세요.');
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
    } catch (e) {
      if (!ref.mounted) return;
      _showError('초기 잔액 저장에 실패했습니다: $e');
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
