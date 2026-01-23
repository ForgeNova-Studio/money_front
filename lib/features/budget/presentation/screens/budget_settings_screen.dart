import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/budget/presentation/providers/budget_providers.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';

/// 예산 설정 화면
class BudgetSettingsScreen extends ConsumerStatefulWidget {
  const BudgetSettingsScreen({super.key});

  @override
  ConsumerState<BudgetSettingsScreen> createState() =>
      _BudgetSettingsScreenState();
}

class _BudgetSettingsScreenState extends ConsumerState<BudgetSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _numberFormat = NumberFormat('#,###');

  bool _isLoading = false;
  bool _isSaving = false;
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
    _loadCurrentBudget();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentBudget() async {
    final accountBookId =
        ref.read(selectedAccountBookViewModelProvider).asData?.value;
    if (accountBookId == null) return;

    setState(() => _isLoading = true);

    try {
      final budget = await ref.read(getMonthlyBudgetUseCaseProvider)(
        year: _selectedMonth.year,
        month: _selectedMonth.month,
        accountBookId: accountBookId,
      );

      if (budget != null && mounted) {
        _amountController.text =
            _numberFormat.format(budget.targetAmount.toInt());
      } else if (mounted) {
        _amountController.clear();
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

  Future<void> _saveBudget() async {
    if (!_formKey.currentState!.validate()) return;

    final accountBookId =
        ref.read(selectedAccountBookViewModelProvider).asData?.value;
    if (accountBookId == null) {
      _showError('가계부를 선택해주세요.');
      return;
    }

    final numericValue =
        _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final amount = double.tryParse(numericValue) ?? 0;

    if (amount <= 0) {
      _showError('예산 금액을 입력해주세요.');
      return;
    }

    setState(() => _isSaving = true);

    try {
      await ref.read(createOrUpdateBudgetUseCaseProvider)(
        accountBookId: accountBookId,
        year: _selectedMonth.year,
        month: _selectedMonth.month,
        targetAmount: amount,
      );

      await ref.read(homeViewModelProvider.notifier).refresh();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('예산이 저장되었습니다.')),
        );
        context.pop();
      }
    } catch (e) {
      _showError('예산 저장에 실패했습니다: $e');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _changeMonth(int delta) {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + delta);
      _amountController.clear();
    });
    _loadCurrentBudget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          '예산 설정',
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
            onPressed: (_isLoading || _isSaving) ? null : _saveBudget,
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
                    _buildMonthSelector(),
                    const SizedBox(height: 32),
                    _buildAmountInput(),
                    const SizedBox(height: 24),
                    _buildSuggestedAmounts(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left, color: context.appColors.gray600),
            onPressed: () => _changeMonth(-1),
          ),
          Text(
            DateFormat('yyyy년 M월').format(_selectedMonth),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: context.appColors.textPrimary,
            ),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, color: context.appColors.gray600),
            onPressed: () => _changeMonth(1),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInput() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('이번 달 예산', style: TextStyle(fontSize: 14, color: context.appColors.textSecondary)),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(15)],
                  onChanged: _onAmountChanged,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: context.appColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: context.appColors.gray300),
                    border: InputBorder.none,
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? '예산 금액을 입력해주세요' : null,
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

  Widget _buildSuggestedAmounts() {
    final suggestions = [500000, 1000000, 1500000, 2000000, 3000000];
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
              label: Text('${_numberFormat.format(amount)}원'),
              onPressed: () => _amountController.text = _numberFormat.format(amount),
              backgroundColor: context.appColors.gray100,
              labelStyle: TextStyle(color: context.appColors.textPrimary),
            );
          }).toList(),
        ),
      ],
    );
  }
}
