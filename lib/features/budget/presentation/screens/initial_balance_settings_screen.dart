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

/// 초기 잔액 설정 화면
class InitialBalanceSettingsScreen extends ConsumerStatefulWidget {
  const InitialBalanceSettingsScreen({super.key});

  @override
  ConsumerState<InitialBalanceSettingsScreen> createState() =>
      _InitialBalanceSettingsScreenState();
}

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

  void _syncAmountFromState(int? amount) {
    if (amount == null) return;
    if (amount == 0) {
      _amountController.clear();
      return;
    }

    _amountController.text = _numberFormat.format(amount);
  }

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

  void _setSuggestedAmount(int amount) {
    if (amount == 0) {
      _amountController.clear();
    } else {
      _amountController.text = _numberFormat.format(amount);
    }
    setState(() {});
  }

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
