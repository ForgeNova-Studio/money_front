import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/core/utils/toast_utils.dart';
import 'package:moamoa/features/budget/domain/entities/budget_entity.dart';
import 'package:moamoa/features/budget/presentation/states/budget_settings_state.dart';
import 'package:moamoa/features/budget/presentation/utils/budget_amount_utils.dart';
import 'package:moamoa/features/budget/presentation/viewmodels/budget_settings_view_model.dart';
import 'package:moamoa/features/budget/presentation/widgets/budget_form_widgets.dart';
import 'package:moamoa/features/budget/presentation/widgets/budget_month_selector.dart';
import 'package:moamoa/features/budget/presentation/widgets/budget_settings_actions.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';

/// 예산 설정 화면
///
/// 사용자가 특정 월의 예산을 설정하거나 수정, 삭제할 수 있는 화면입니다.
/// ViewModel을 통해 상태를 관리하며, 예산 금액 입력 및 빠른 금액 선택 기능을 제공합니다.
///
/// **Key Features:**
/// *   월별 예산 조회 및 월 이동 (`BudgetMonthSelector`)
/// *   예산 금액 직접 입력 및 콤마 포맷팅 (`BudgetAmountInputCard`)
/// *   빠른 예산 금액 추천 버튼 제공 (`BudgetQuickAmountGrid`)
/// *   선택된 월의 예산 저장 및 삭제 처리 (`BudgetSettingsActions`)
///
/// **Parameters:**
/// *   [initialDate] - 화면 진입 시 초기 기준으로 설정될 날짜입니다. (선택 사항)
///
/// **Usage Example:**
/// ```dart
/// // 라우터를 통한 이동 예시 (GoRouter 사용 시)
/// context.push(
///   '/budget/settings?year=2026&month=02',
/// );
///
/// // 직접 위젯 생성 예시
/// BudgetSettingsScreen(
///   initialDate: DateTime.now(),
/// )
/// ```
class BudgetSettingsScreen extends ConsumerStatefulWidget {
  const BudgetSettingsScreen({
    super.key,
    this.initialDate,
  });

  final DateTime? initialDate;

  @override
  ConsumerState<BudgetSettingsScreen> createState() =>
      _BudgetSettingsScreenState();
}

/// [BudgetSettingsScreen]의 상태 관리를 담당하는 State 클래스
///
/// 폼 검증([_formKey])
/// 금액 텍스트 컨트롤러([_amountController])
/// 금액 포커스([_amountFocusNode]) 등을 비롯한 로컬 UI 상태를 관리합니다.
/// [budgetSettingsViewModelProvider]를 수신하여 상태를 동기화하고, 에러 메시지나 정상 처리 등의 이벤트 위임 알림(Toast, Pop 등)을 처리합니다.
class _BudgetSettingsScreenState extends ConsumerState<BudgetSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _amountFocusNode = FocusNode();
  final _numberFormat = NumberFormat('#,###');

  bool _didInitialize = false;
  bool _didAutoFocusAmount = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _didInitialize) return;
      _didInitialize = true;
      ref
          .read(budgetSettingsViewModelProvider.notifier)
          .initialize(widget.initialDate);
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  /// 예산 금액 동기화
  /// 예산이 null이면 금액 컨트롤러를 초기화한다.
  /// 예산이 null이 아니면 예산 금액을 금액 컨트롤러에 설정한다.
  void _syncAmountFromBudget(BudgetEntity? budget) {
    if (budget == null) {
      _amountController.clear();
      return;
    }

    _amountController.text = _numberFormat.format(budget.targetAmount.toInt());
  }

  /// 이벤트 핸들러
  /// [BudgetSettingsEvent]를 베이스로 하는 다양한 이벤트를 처리하여 UI를 업데이트한다.
  /// - [BudgetSettingsShowError]
  /// - [BudgetSettingsPopWithToast]
  /// - [BudgetSettingsPop]
  /// 처리 완료후에는 [BudgetSettingsViewModel.clearEvent]를 호출하여 이벤트를 비운다.
  void _handleEvent(BudgetSettingsEvent event) {
    switch (event) {
      case BudgetSettingsShowError(:final message):
        context.showErrorToast(
          message,
          duration: const Duration(seconds: 2),
        );
      case BudgetSettingsPopWithToast(:final message):
        context.showToast(message);
        context.pop();
      case BudgetSettingsPop():
        context.pop();
    }

    // 이벤트 비우기 위한 호출
    ref.read(budgetSettingsViewModelProvider.notifier).clearEvent();
  }

  /// 예산 삭제
  Future<void> _onDeletePressed(DateTime selectedMonth) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('예산 삭제'),
        content: Text(
          '${DateFormat('yyyy년 M월').format(selectedMonth)} 예산을 삭제하면\n해당 월은 "예산 미설정" 상태가 됩니다.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: context.appColors.error,
            ),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    ref.read(budgetSettingsViewModelProvider.notifier).deleteSelectedBudget();
  }

  /// 예산 저장
  void _onSavePressed() {
    if (!_formKey.currentState!.validate()) return;
    final amount = parseFormattedAmount(_amountController.text);
    ref.read(budgetSettingsViewModelProvider.notifier).saveBudget(amount);
  }

  /// 빠른 금액 선택
  void _setSuggestedAmount(int amount) {
    _amountController.text = _numberFormat.format(amount);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<BudgetSettingsState>(
      budgetSettingsViewModelProvider,
      (previous, next) {
        final monthChanged = previous?.selectedMonth != next.selectedMonth;
        final budgetChanged = previous?.selectedBudget != next.selectedBudget;

        if (monthChanged || budgetChanged) {
          _syncAmountFromBudget(next.selectedBudget);
        }

        if (!_didAutoFocusAmount &&
            !next.isInitialLoading &&
            _amountController.text.isEmpty) {
          _didAutoFocusAmount = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _amountFocusNode.requestFocus();
          });
        }

        final event = next.event;
        if (event != null) {
          _handleEvent(event);
        }
      },
    );

    final state = ref.watch(budgetSettingsViewModelProvider);

    return DefaultLayout(
      title: '예산 설정',
      titleSpacing: 0,
      backgroundColor: context.appColors.backgroundLight,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => context.pop(),
      ),
      child: state.isInitialLoading
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
                          BudgetMonthSelector(
                            selectedMonth: state.selectedMonth,
                            isCurrentMonth: state.isCurrentMonth,
                            onPrevious: () {
                              ref
                                  .read(
                                      budgetSettingsViewModelProvider.notifier)
                                  .changeMonth(-1);
                            },
                            onNext: () {
                              ref
                                  .read(
                                      budgetSettingsViewModelProvider.notifier)
                                  .changeMonth(1);
                            },
                            onGoToCurrentMonth: () {
                              ref
                                  .read(
                                      budgetSettingsViewModelProvider.notifier)
                                  .goToCurrentMonth();
                            },
                          ),
                          const SizedBox(height: 24),
                          _buildAmountInput(),
                          const SizedBox(height: 32),
                          _buildSuggestedAmounts(),
                        ],
                      ),
                    ),
                  ),
                ),
                BudgetSettingsActions(
                  hasBudget: state.selectedBudget != null,
                  hasValue: _amountController.text.isNotEmpty,
                  isSaving: state.isSaving,
                  isDeleting: state.isDeleting,
                  onSave: _onSavePressed,
                  onDelete: () => _onDeletePressed(state.selectedMonth),
                ),
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
}
