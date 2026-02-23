import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/core/utils/toast_utils.dart';
import 'package:moamoa/features/budget/presentation/states/initial_balance_settings_state.dart';
import 'package:moamoa/features/budget/presentation/viewmodels/initial_balance_settings_view_model.dart';
import 'package:moamoa/features/budget/presentation/widgets/budget_form_widgets.dart';
import 'package:moamoa/features/budget/presentation/widgets/initial_balance_current_assets_card.dart';
import 'package:moamoa/features/budget/presentation/widgets/initial_balance_description_card.dart';
import 'package:moamoa/features/budget/presentation/widgets/initial_balance_sign_selector.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';

/// 초기 잔액(자산 시작값)을 조회/수정하는 설정 화면 위젯입니다.
///
/// Key Features:
/// - 초기 잔액 데이터 로드 상태에 따라 로딩/입력 UI를 전환합니다.
/// - 부호(플러스/마이너스) 선택, 금액 직접 입력, 빠른 금액 선택을 제공합니다.
/// - 저장 시 ViewModel 이벤트를 통해 토스트 표시 및 화면 복귀를 처리합니다.
///
/// Parameters:
/// - `key`: 위젯 식별과 트리 갱신 제어에 사용하는 선택 파라미터입니다.
///
/// Usage Example:
/// ```dart
/// InitialBalanceSettingsScreen(
///   key: const ValueKey('initial-balance-settings'),
/// )
/// ```
class InitialBalanceSettingsScreen extends ConsumerStatefulWidget {
  const InitialBalanceSettingsScreen({super.key});

  @override
  ConsumerState<InitialBalanceSettingsScreen> createState() =>
      _InitialBalanceSettingsScreenState();
}

/// [InitialBalanceSettingsScreen]의 내부 상태와 화면 상호작용을 관리하는 Private State 클래스입니다.
///
/// Key Features:
/// - 폼 검증, 금액 입력 컨트롤러, 포커스 노드 등 로컬 UI 상태를 관리합니다.
/// - `initialBalanceSettingsViewModelProvider` 상태 변화를 구독해 입력값/이벤트를 동기화합니다.
/// - 저장 버튼, 빠른 금액 입력, 이벤트 토스트/팝 동작을 화면 경계에서 처리합니다.
///
/// Parameters:
/// - `widget`: 연결된 부모 StatefulWidget 인스턴스로, 화면 구성 정보에 접근할 때 사용됩니다.
///
/// Usage Example:
/// ```dart
/// @override
/// ConsumerState<InitialBalanceSettingsScreen> createState() =>
///     _InitialBalanceSettingsScreenState();
/// ```
class _InitialBalanceSettingsScreenState
    extends ConsumerState<InitialBalanceSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _amountFocusNode = FocusNode();
  final _numberFormat = NumberFormat('#,###');

  bool _didInitialize = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _didInitialize) return;
      _didInitialize = true;
      ref.read(initialBalanceSettingsViewModelProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  /// 잔액 금액 동기화
  void _syncAmountFromState(int? amount) {
    if (amount == null) return;
    if (amount == 0) {
      _amountController.clear();
      return;
    }

    _amountController.text = _numberFormat.format(amount);
  }

  /// 이벤트 핸들러
  /// [InitialBalanceSettingsEvent]를 베이스로 하는 다양한 이벤트를 처리하여 UI를 업데이트합니다.
  void _handleEvent(InitialBalanceSettingsEvent event) {
    switch (event) {
      case InitialBalanceSettingsShowError(:final message):
        context.showErrorToast(
          message,
          duration: const Duration(seconds: 2),
        );
      case InitialBalanceSettingsPopWithToast(:final message):
        context.showToast(message);
        context.pop();
    }

    ref.read(initialBalanceSettingsViewModelProvider.notifier).clearEvent();
  }

  /// 선택된 금액을 입력 필드에 설정합니다.
  void _setSuggestedAmount(int amount) {
    if (amount == 0) {
      _amountController.clear();
    } else {
      _amountController.text = _numberFormat.format(amount);
    }
    setState(() {});
  }

  /// 저장 버튼 핸들러
  void _onSavePressed() {
    if (!_formKey.currentState!.validate()) return;

    ref
        .read(initialBalanceSettingsViewModelProvider.notifier)
        .saveInitialBalance(rawText: _amountController.text);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<InitialBalanceSettingsState>(
      initialBalanceSettingsViewModelProvider,
      (previous, next) {
        if (previous?.initialAmount != next.initialAmount) {
          _syncAmountFromState(next.initialAmount);
        }

        final event = next.event;
        if (event != null) {
          _handleEvent(event);
        }
      },
    );

    final state = ref.watch(initialBalanceSettingsViewModelProvider);

    return DefaultLayout(
      title: '초기 잔액 설정',
      titleSpacing: 0,
      backgroundColor: context.appColors.backgroundLight,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => context.pop(),
      ),
      child: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.currentTotalAssets != null)
                            InitialBalanceCurrentAssetsCard(
                              currentTotalAssets: state.currentTotalAssets!,
                            ),
                          const SizedBox(height: 24),
                          _buildAmountInput(state),
                          const SizedBox(height: 16),
                          const InitialBalanceDescriptionCard(),
                          const SizedBox(height: 32),
                          _buildSuggestedAmounts(),
                        ],
                      ),
                    ),
                  ),
                ),
                BudgetSaveButton(
                  isSaving: state.isSaving,
                  enabled: true,
                  onPressed: _onSavePressed,
                ),
              ],
            ),
    );
  }

  Widget _buildAmountInput(InitialBalanceSettingsState state) {
    final amountColor =
        state.isNegative ? context.appColors.error : context.appColors.primary;

    return BudgetAmountInputCard(
      header: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '초기 잔액',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: context.appColors.textSecondary,
            ),
          ),
          InitialBalanceSignSelector(
            isNegative: state.isNegative,
            onChanged: (value) {
              ref
                  .read(initialBalanceSettingsViewModelProvider.notifier)
                  .setNegative(value);
            },
          ),
        ],
      ),
      controller: _amountController,
      focusNode: _amountFocusNode,
      onChanged: () => setState(() {}),
      amountColor: amountColor,
      showNegativeSign: state.isNegative,
    );
  }

  Widget _buildSuggestedAmounts() {
    const suggestions = [
      BudgetAmountSuggestion(0, '0원'),
      BudgetAmountSuggestion(1000000, '100만'),
      BudgetAmountSuggestion(5000000, '500만'),
      BudgetAmountSuggestion(10000000, '1000만'),
      BudgetAmountSuggestion(50000000, '5000만'),
      BudgetAmountSuggestion(100000000, '1억'),
    ];

    return BudgetQuickAmountGrid(
      showClear: _amountController.text.isNotEmpty,
      onClear: () {
        _amountController.clear();
        setState(() {});
      },
      suggestions: suggestions,
      isSelected: (amount) =>
          (amount == 0 && _amountController.text.isEmpty) ||
          _amountController.text == _numberFormat.format(amount),
      onSelect: _setSuggestedAmount,
    );
  }
}
