import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/budget/presentation/providers/budget_providers.dart';
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

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    await _loadCurrentAssets();
  }

  void clearEvent() {
    if (state.event == null) return;
    state = state.copyWith(event: null);
  }

  void setNegative(bool isNegative) {
    if (state.isNegative == isNegative) return;
    state = state.copyWith(isNegative: isNegative);
  }

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

  Future<void> _loadCurrentAssets() async {
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
      // 로드 실패는 초기 화면 상태 유지
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isLoading: false);
      }
    }
  }

  String? _resolveAccountBookId() {
    final accountBookState = ref.read(selectedAccountBookViewModelProvider);
    return accountBookState.asData?.value;
  }

  void _showError(String message) {
    state = state.copyWith(event: InitialBalanceSettingsShowError(message));
  }
}
