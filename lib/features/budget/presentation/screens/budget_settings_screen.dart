import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/budget/presentation/providers/budget_providers.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';
import 'package:moamoa/features/common/widgets/transaction_form/thousands_separator_input_formatter.dart';

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
  final _amountFocusNode = FocusNode();
  final _numberFormat = NumberFormat('#,###');

  // 월별 예산 캐시 (key: "yyyy-MM")
  final Map<String, BudgetEntity?> _budgetCache = {};

  bool _isInitialLoading = true;
  bool _isSaving = false;
  late DateTime _selectedMonth;
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
    _selectedMonth = _currentMonth;
    _prefetchBudgets();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  String _monthKey(DateTime month) =>
      '${month.year}-${month.month.toString().padLeft(2, '0')}';

  bool get _isCurrentMonth =>
      _selectedMonth.year == _currentMonth.year &&
      _selectedMonth.month == _currentMonth.month;

  /// 현재 월 기준 앞뒤 1개월 프리페치
  Future<void> _prefetchBudgets() async {
    final accountBookId =
        ref.read(selectedAccountBookViewModelProvider).asData?.value;
    if (accountBookId == null) {
      if (mounted) setState(() => _isInitialLoading = false);
      return;
    }

    // 현재 월 기준 -1 ~ +1 개월 (총 3개월)
    final months = <DateTime>[];
    for (int i = -1; i <= 1; i++) {
      months.add(DateTime(_currentMonth.year, _currentMonth.month + i));
    }

    // 병렬로 모든 월 데이터 fetch
    await Future.wait(months.map((month) async {
      final key = _monthKey(month);
      if (_budgetCache.containsKey(key)) return;

      try {
        final budget = await ref.read(getMonthlyBudgetUseCaseProvider)(
          year: month.year,
          month: month.month,
          accountBookId: accountBookId,
        );
        _budgetCache[key] = budget;
      } catch (e) {
        _budgetCache[key] = null;
      }
    }));

    // 현재 월 예산을 입력 필드에 설정
    if (mounted) {
      _updateAmountFromCache();
      setState(() => _isInitialLoading = false);
    }
  }

  /// 캐시에서 현재 선택된 월의 예산을 가져와 입력 필드에 설정
  void _updateAmountFromCache() {
    final key = _monthKey(_selectedMonth);
    final budget = _budgetCache[key];
    if (budget != null) {
      _amountController.text =
          _numberFormat.format(budget.targetAmount.toInt());
    } else {
      _amountController.clear();
    }
  }

  /// 캐시에 없는 월로 이동할 경우 개별 fetch
  Future<void> _fetchAndCacheMonth(DateTime month,
      {required int direction}) async {
    final key = _monthKey(month);

    // 이미 캐시에 있으면 값만 업데이트하고 프리페칭 시도
    if (_budgetCache.containsKey(key)) {
      _updateAmountFromCache();
      if (mounted) _prefetchDirectional(month, direction);
      return;
    }

    final accountBookId =
        ref.read(selectedAccountBookViewModelProvider).asData?.value;
    if (accountBookId == null) return;

    try {
      final budget = await ref.read(getMonthlyBudgetUseCaseProvider)(
        year: month.year,
        month: month.month,
        accountBookId: accountBookId,
      );
      _budgetCache[key] = budget;

      if (mounted) {
        _updateAmountFromCache();
        // 이동 방향으로 추가 프리페치
        _prefetchDirectional(month, direction);
      }
    } catch (e) {
      _budgetCache[key] = null;
      if (mounted) _updateAmountFromCache();
    }
  }

  /// 이동한 방향으로 1개월 추가 프리페치
  void _prefetchDirectional(DateTime currentMonth, int direction) {
    if (direction == 0) return;

    final accountBookId =
        ref.read(selectedAccountBookViewModelProvider).asData?.value;
    if (accountBookId == null) return;

    // direction: -1 (이전 달로 이동) -> 더 이전 달(-1) 프리페치
    // direction: 1 (다음 달로 이동) -> 더 다음 달(+1) 프리페치
    final targetMonth =
        DateTime(currentMonth.year, currentMonth.month + direction);
    final key = _monthKey(targetMonth);

    if (_budgetCache.containsKey(key)) return;

    ref
        .read(getMonthlyBudgetUseCaseProvider)(
      year: targetMonth.year,
      month: targetMonth.month,
      accountBookId: accountBookId,
    )
        .then((budget) {
      _budgetCache[key] = budget;
    }).catchError((_) {
      _budgetCache[key] = null;
    });
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

      // 캐시 업데이트 - 저장 후 다음 방문 시 새로운 데이터 불러오도록 invalidate
      final key = _monthKey(_selectedMonth);
      _budgetCache.remove(key);

      await ref.read(homeViewModelProvider.notifier).refresh();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('예산이 저장되었습니다.'),
            backgroundColor: context.appColors.success,
          ),
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
      SnackBar(
        content: Text(message),
        backgroundColor: context.appColors.error,
      ),
    );
  }

  void _changeMonth(int delta) {
    final newMonth =
        DateTime(_selectedMonth.year, _selectedMonth.month + delta);
    setState(() {
      _selectedMonth = newMonth;
    });
    _fetchAndCacheMonth(newMonth, direction: delta);
  }

  void _goToCurrentMonth() {
    if (_isCurrentMonth) return;
    setState(() {
      _selectedMonth = _currentMonth;
    });
    _updateAmountFromCache();
  }

  void _setSuggestedAmount(int amount) {
    _amountController.text = _numberFormat.format(amount);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '예산 설정',
      titleSpacing: 0,
      backgroundColor: context.appColors.backgroundLight,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => context.pop(),
      ),
      child: _isInitialLoading
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
                          _buildMonthSelector(),
                          const SizedBox(height: 24),
                          _buildAmountInput(),
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

  Widget _buildMonthSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.chevron_left_rounded,
              color: context.appColors.gray600,
              size: 28,
            ),
            onPressed: () => _changeMonth(-1),
          ),
          Expanded(
            child: Center(
              child: Text(
                DateFormat('yyyy년 M월').format(_selectedMonth),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: context.appColors.textPrimary,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.chevron_right_rounded,
              color: context.appColors.gray600,
              size: 28,
            ),
            onPressed: () => _changeMonth(1),
          ),
          // 이번달 버튼
          if (!_isCurrentMonth) ...[
            Container(
              height: 24,
              width: 1,
              color: context.appColors.gray200,
              margin: const EdgeInsets.symmetric(horizontal: 4),
            ),
            TextButton(
              onPressed: _goToCurrentMonth,
              style: TextButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                '이번달',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: context.appColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAmountInput() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _amountFocusNode.requestFocus(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
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
            Text(
              '이번 달 예산',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: context.appColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
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
                          color: context.appColors.primary,
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
                        validator: (value) => (value == null || value.isEmpty)
                            ? '예산 금액을 입력해주세요'
                            : null,
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

  Widget _buildSuggestedAmounts() {
    final suggestions = [
      (500000, '50만'),
      (1000000, '100만'),
      (1500000, '150만'),
      (2000000, '200만'),
      (3000000, '300만'),
      (5000000, '500만'),
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
    final hasValue = _amountController.text.isNotEmpty;

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
          onPressed: (_isSaving || !hasValue) ? null : _saveBudget,
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
