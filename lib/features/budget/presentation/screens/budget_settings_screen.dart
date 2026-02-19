import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/account_book/presentation/viewmodels/selected_account_book_view_model.dart';
import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/budget/presentation/providers/budget_providers.dart';
import 'package:moamoa/features/budget/presentation/utils/budget_amount_utils.dart';
import 'package:moamoa/features/budget/presentation/widgets/budget_form_widgets.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';
import 'package:moamoa/core/utils/toast_utils.dart';

/// 예산 설정 화면
class BudgetSettingsScreen extends ConsumerStatefulWidget {
  final DateTime? initialDate;

  const BudgetSettingsScreen({
    super.key,
    this.initialDate,
  });

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
  bool _didAutoFocusAmount = false;
  late DateTime _selectedMonth;
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month);
    // initialDate가 있으면 해당 월로, 없으면 현재 월로 설정
    if (widget.initialDate != null) {
      _selectedMonth =
          DateTime(widget.initialDate!.year, widget.initialDate!.month);
    } else {
      _selectedMonth = _currentMonth;
    }
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

    // 선택 월 기준 -1 ~ +1 개월 (총 3개월)
    final months = <DateTime>[];
    for (int i = -1; i <= 1; i++) {
      months.add(DateTime(_selectedMonth.year, _selectedMonth.month + i));
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
        // 네트워크 실패를 "예산 미설정(null)"으로 캐시하지 않는다.
      }
    }));

    // 현재 월 예산을 입력 필드에 설정
    if (mounted) {
      _updateAmountFromCache();
      setState(() => _isInitialLoading = false);
      _autoFocusAmountIfNeeded();
    }
  }

  /// 예산이 설정되지 않은 경우 금액 필드 포커싱
  void _autoFocusAmountIfNeeded() {
    if (_didAutoFocusAmount) return;
    if (_amountController.text.isNotEmpty) return;
    _didAutoFocusAmount = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _amountFocusNode.requestFocus();
    });
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
      // 실패 시 null 캐시를 남기지 않아 다음 시도에서 재조회되도록 한다.
      _budgetCache.remove(key);
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
      // 프리페치 실패는 캐시하지 않고 다음 기회에 재시도한다.
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

    final amount = parseFormattedAmount(_amountController.text);

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
        context.showToast('예산이 저장되었습니다.');
        context.pop();
      }
    } catch (e) {
      _showError('예산 저장에 실패했습니다: $e');
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
    _fetchAndCacheMonth(_currentMonth, direction: 0);
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
    return BudgetAmountInputCard(
      header: Text(
        '이번 달 예산',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: context.appColors.textSecondary,
        ),
      ),
      controller: _amountController,
      focusNode: _amountFocusNode,
      onChanged: () => setState(() {}),
      amountColor: context.appColors.primary,
      validator: (value) =>
          (value == null || value.isEmpty) ? '예산 금액을 입력해주세요' : null,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      headerBottomSpacing: 16,
    );
  }

  Widget _buildSuggestedAmounts() {
    const suggestions = [
      BudgetAmountSuggestion(500000, '50만'),
      BudgetAmountSuggestion(1000000, '100만'),
      BudgetAmountSuggestion(1500000, '150만'),
      BudgetAmountSuggestion(2000000, '200만'),
      BudgetAmountSuggestion(3000000, '300만'),
      BudgetAmountSuggestion(5000000, '500만'),
    ];

    return BudgetQuickAmountGrid(
      showClear: _amountController.text.isNotEmpty,
      onClear: () {
        _amountController.clear();
        setState(() {});
      },
      suggestions: suggestions,
      isSelected: (amount) =>
          _amountController.text == _numberFormat.format(amount),
      onSelect: _setSuggestedAmount,
    );
  }

  Widget _buildSaveButton() {
    final hasValue = _amountController.text.isNotEmpty;

    return BudgetSaveButton(
      isSaving: _isSaving,
      enabled: hasValue,
      onPressed: _saveBudget,
    );
  }
}
