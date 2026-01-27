import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/budget/presentation/providers/budget_providers.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';
import 'package:moamoa/features/common/widgets/transaction_form/thousands_separator_input_formatter.dart';

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
          SnackBar(
            content: const Text('초기 잔액이 저장되었습니다.'),
            backgroundColor: context.appColors.success,
          ),
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
      SnackBar(
        content: Text(message),
        backgroundColor: context.appColors.error,
      ),
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

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _amountFocusNode.requestFocus(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // 헤더: 초기 잔액 + 부호 토글
            Row(
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
            const SizedBox(height: 20),
            // 금액 입력
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    // 마이너스 부호
                    if (_isNegative)
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Text(
                          '-',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            color: amountColor,
                          ),
                        ),
                      ),
                    IntrinsicWidth(
                      child: TextFormField(
                        controller: _amountController,
                        focusNode: _amountFocusNode,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        onChanged: (_) => setState(() {}),
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: amountColor,
                        ),
                        decoration: InputDecoration(
                          filled: false,
                          hintText: '0',
                          hintStyle: TextStyle(
                            color: context.appColors.gray300,
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                          ),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorStyle: const TextStyle(
                            height: 0,
                            color: Colors.transparent,
                          ),
                          contentPadding: EdgeInsets.zero,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          ThousandsSeparatorInputFormatter(maxDigits: 12),
                        ],
                        autofocus: false,
                        showCursor: false,
                        cursorColor: Colors.transparent,
                        validator: null,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '원',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.w600,
                        color: context.appColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
    final suggestions = [
      (0, '0원'),
      (1000000, '100만'),
      (5000000, '500만'),
      (10000000, '1000만'),
      (50000000, '5000만'),
      (100000000, '1억'),
    ];

    return Column(
      children: [
        // 헤더: 빠른 입력 + 초기화 버튼
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '빠른 입력',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: context.appColors.textSecondary,
              ),
            ),
            if (_amountController.text.isNotEmpty) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  _amountController.clear();
                  setState(() {});
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.appColors.gray100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '초기화',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: context.appColors.textTertiary,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        // 2x3 그리드
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 2.2,
          children: suggestions.map((item) {
            final isSelected =
                (item.$1 == 0 && _amountController.text.isEmpty) ||
                    _amountController.text == _numberFormat.format(item.$1);
            return GestureDetector(
              onTap: () => _setSuggestedAmount(item.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.appColors.primary.withValues(alpha: 0.1)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? context.appColors.primary
                        : context.appColors.gray200,
                    width: isSelected ? 1.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                ),
                child: Text(
                  item.$2,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? context.appColors.primary
                        : context.appColors.textPrimary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: _isSaving ? null : _saveInitialBalance,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.appColors.primary,
            disabledBackgroundColor: context.appColors.gray200,
            foregroundColor: Colors.white,
            disabledForegroundColor: context.appColors.gray400,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: _isSaving
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  '저장하기',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
        ),
      ),
    );
  }
}
