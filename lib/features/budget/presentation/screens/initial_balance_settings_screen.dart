import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/budget/presentation/providers/budget_providers.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';

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
          _amountController.text =
              _numberFormat.format(assets.initialBalance.abs().toInt());
        });
      }
    } catch (e) {
      // Ignore
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _onAmountChanged(String value) {
    final numericValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (numericValue.isEmpty) {
      _amountController.text = '';
      return;
    }
    final number = int.tryParse(numericValue) ?? 0;
    final formatted = _numberFormat.format(number);
    if (formatted != value) {
      _amountController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
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

    final numericValue =
        _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    var amount = double.tryParse(numericValue) ?? 0;
    if (_isNegative) amount = -amount;

    setState(() => _isSaving = true);

    try {
      await ref.read(updateInitialBalanceUseCaseProvider)(
        accountBookId: accountBookId,
        initialBalance: amount,
      );

      await ref.read(homeViewModelProvider.notifier).refresh();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('초기 잔액이 저장되었습니다.')),
        );
        context.pop();
      }
    } catch (e) {
      _showError('초기 잔액 저장에 실패했습니다: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          '초기 잔액 설정',
          style: TextStyle(
            color: context.appColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: context.appColors.backgroundLight,
        foregroundColor: context.appColors.textPrimary,
        iconTheme: IconThemeData(color: context.appColors.textPrimary),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: (_isLoading || _isSaving) ? null : _saveInitialBalance,
            child: _isSaving
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: context.appColors.primary,
                    ),
                  )
                : Text(
                    '저장',
                    style: TextStyle(
                      color: _isLoading ? context.appColors.textTertiary : context.appColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_currentTotalAssets != null) _buildCurrentAssetInfo(),
                    const SizedBox(height: 24),
                    _buildAmountInput(),
                    const SizedBox(height: 16),
                    _buildDescription(),
                    const SizedBox(height: 24),
                    _buildSuggestedAmounts(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildCurrentAssetInfo() {
    final isNegative = _currentTotalAssets! < 0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNegative
            ? context.appColors.error.withAlpha(25)
            : context.appColors.success.withAlpha(25),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.account_balance_wallet,
              color: isNegative ? context.appColors.error : context.appColors.success),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('현재 총 자산', style: TextStyle(fontSize: 12, color: context.appColors.textSecondary)),
              Text(
                '${isNegative ? '-' : ''}${_numberFormat.format(_currentTotalAssets!.abs().toInt())}원',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isNegative ? context.appColors.error : context.appColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInput() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('초기 잔액', style: TextStyle(fontSize: 14, color: context.appColors.textSecondary)),
              Row(children: [_buildSignButton(false), const SizedBox(width: 8), _buildSignButton(true)]),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (_isNegative)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, right: 4),
                  child: Text('-', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: context.appColors.error)),
                ),
              Expanded(
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(15)],
                  onChanged: _onAmountChanged,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _isNegative ? context.appColors.error : context.appColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: context.appColors.gray300),
                    border: InputBorder.none,
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? '금액을 입력해주세요' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('원', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: context.appColors.textSecondary)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignButton(bool isNegative) {
    final isSelected = _isNegative == isNegative;
    return GestureDetector(
      onTap: () => setState(() => _isNegative = isNegative),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? (isNegative ? context.appColors.error : context.appColors.success) : context.appColors.gray100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          isNegative ? '-' : '+',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : context.appColors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: context.appColors.gray50, borderRadius: BorderRadius.circular(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 20, color: context.appColors.textTertiary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '초기 잔액은 가계부 시작 시점의 자산을 의미합니다.\n총 자산 = 초기 잔액 + 총 수입 - 총 지출',
              style: TextStyle(fontSize: 13, color: context.appColors.textSecondary, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedAmounts() {
    final suggestions = [0, 1000000, 5000000, 10000000, 50000000];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('추천 금액', style: TextStyle(fontSize: 14, color: context.appColors.textSecondary)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: suggestions.map((amount) {
            return ActionChip(
              label: Text(amount == 0 ? '0원' : '${_numberFormat.format(amount)}원'),
              onPressed: () => _amountController.text = amount == 0 ? '' : _numberFormat.format(amount),
              backgroundColor: context.appColors.gray100,
              labelStyle: TextStyle(color: context.appColors.textPrimary),
            );
          }).toList(),
        ),
      ],
    );
  }
}
