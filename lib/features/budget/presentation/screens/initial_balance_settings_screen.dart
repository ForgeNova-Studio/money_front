import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/budget/presentation/providers/budget_providers.dart';
import 'package:moamoa/features/budget/presentation/utils/budget_amount_utils.dart';
import 'package:moamoa/features/budget/presentation/widgets/budget_form_widgets.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';
import 'package:moamoa/core/utils/toast_utils.dart';

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

  bool _isLoading = false;
  bool _isSaving = false;
  bool _isNegative = false;
  double? _currentTotalAssets;

  @override
  void initState() {
    super.initState();
    _loadCurrentAssets();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentAssets() async {
    final accountBookId =
        ref.read(selectedAccountBookViewModelProvider).asData?.value;
    if (accountBookId == null) return;

    setState(() => _isLoading = true);

    try {
      final assets = await ref.read(getTotalAssetsUseCaseProvider)(
        accountBookId: accountBookId,
      );

      if (mounted) {
        setState(() {
          _currentTotalAssets = assets.currentTotalAssets;
          _isNegative = assets.initialBalance < 0;
          final absValue = assets.initialBalance.abs().toInt();
          _amountController.text =
              absValue == 0 ? '' : _numberFormat.format(absValue);
        });
      }
    } catch (e) {
      // Ignore
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveInitialBalance() async {
    if (!_formKey.currentState!.validate()) return;

    final accountBookId =
        ref.read(selectedAccountBookViewModelProvider).asData?.value;
    if (accountBookId == null) {
      _showError('가계부를 선택해주세요.');
      return;
    }

    final amount = parseSignedFormattedAmount(
      rawText: _amountController.text,
      isNegative: _isNegative,
    );

    setState(() => _isSaving = true);

    try {
      await ref.read(updateInitialBalanceUseCaseProvider)(
        accountBookId: accountBookId,
        initialBalance: amount,
      );

      await ref.read(homeViewModelProvider.notifier).refresh();

      if (mounted) {
        context.showToast('초기 잔액이 저장되었습니다.');
        context.pop();
      }
    } catch (e) {
      _showError('초기 잔액 저장에 실패했습니다: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showError(String message) {
    context.showErrorToast(
      message,
      duration: const Duration(seconds: 2),
    );
  }

  void _setSuggestedAmount(int amount) {
    if (amount == 0) {
      _amountController.clear();
    } else {
      _amountController.text = _numberFormat.format(amount);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '초기 잔액 설정',
      titleSpacing: 0,
      backgroundColor: context.appColors.backgroundLight,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => context.pop(),
      ),
      child: _isLoading
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
                          if (_currentTotalAssets != null)
                            _buildCurrentAssetInfo(),
                          const SizedBox(height: 24),
                          _buildAmountInput(),
                          const SizedBox(height: 16),
                          _buildDescription(),
                          const SizedBox(height: 32),
                          _buildSuggestedAmounts(),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildSaveButton(),
              ],
            ),
    );
  }

  Widget _buildCurrentAssetInfo() {
    final isNegative = _currentTotalAssets! < 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNegative
            ? context.appColors.error.withValues(alpha: 0.1)
            : context.appColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isNegative
              ? context.appColors.error.withValues(alpha: 0.3)
              : context.appColors.success.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isNegative
                  ? context.appColors.error.withValues(alpha: 0.15)
                  : context.appColors.success.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: isNegative
                  ? context.appColors.error
                  : context.appColors.success,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '현재 총 자산',
                style: TextStyle(
                  fontSize: 13,
                  color: context.appColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${isNegative ? '-' : ''}${_numberFormat.format(_currentTotalAssets!.abs().toInt())}원',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isNegative
                      ? context.appColors.error
                      : context.appColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInput() {
    final amountColor =
        _isNegative ? context.appColors.error : context.appColors.primary;

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
          Row(
            children: [
              _buildSignButton(false),
              const SizedBox(width: 8),
              _buildSignButton(true),
            ],
          ),
        ],
      ),
      controller: _amountController,
      focusNode: _amountFocusNode,
      onChanged: () => setState(() {}),
      amountColor: amountColor,
      showNegativeSign: _isNegative,
    );
  }

  Widget _buildSignButton(bool isNegative) {
    final isSelected = _isNegative == isNegative;
    final color =
        isNegative ? context.appColors.error : context.appColors.success;

    return GestureDetector(
      onTap: () => setState(() => _isNegative = isNegative),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : context.appColors.gray100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : context.appColors.gray200,
          ),
        ),
        child: Text(
          isNegative ? '마이너스' : '플러스',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : context.appColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.gray50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: context.appColors.textTertiary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '초기 잔액은 가계부 시작 시점의 자산을 의미합니다.\n총 자산 = 초기 잔액 + 총 수입 - 총 지출',
              style: TextStyle(
                fontSize: 13,
                color: context.appColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
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

  Widget _buildSaveButton() {
    return BudgetSaveButton(
      isSaving: _isSaving,
      enabled: true,
      onPressed: _saveInitialBalance,
    );
  }
}
