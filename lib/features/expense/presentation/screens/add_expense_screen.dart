// packages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// entities
import 'package:moamoa/features/expense/domain/entities/expense.dart';
import 'package:moamoa/features/expense/domain/entities/payment_method.dart';
import 'package:moamoa/features/expense/presentation/widgets/expense_category_grid.dart';
import 'package:moamoa/core/constants/expense_categories.dart';

// viewmodels
import 'package:moamoa/features/expense/presentation/viewmodels/expense_view_model.dart';
import 'package:moamoa/core/utils/toast_utils.dart';

// constants
import 'package:moamoa/core/constants/app_constants.dart';

import 'package:moamoa/features/common/widgets/transaction_form/amount_input_card.dart';
import 'package:moamoa/features/common/widgets/transaction_form/date_picker_card.dart';
import 'package:moamoa/features/common/widgets/transaction_form/form_submit_button.dart';
import 'package:moamoa/features/common/widgets/retryable_load_error_state.dart';
import 'package:moamoa/features/common/widgets/transaction_form/transaction_form_card.dart';

import 'package:moamoa/features/common/widgets/transaction_form/transaction_text_field.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';

/// 지출 등록/수정 화면
///
/// 지출 금액, 날짜, 카테고리, 메모, 결제 수단을 입력받아 지출을 등록하거나 수정합니다.
/// [expenseId]가 전달되면 수정 모드로 동작하며, 기존 데이터를 불러와 폼에 채웁니다.
///
/// **주요 기능:**
/// - 금액 입력 (콤마 포맷팅, 최대 12자리)
/// - 날짜 선택 (DatePicker)
/// - 지출 카테고리 선택 ([ExpenseCategoryGrid])
/// - 결제 수단 선택 (현금/카드)
/// - [ExpenseViewModel]을 통한 등록/수정 처리
///
/// **주요 파라미터:**
/// - [initialDate]: 홈 화면에서 선택된 날짜 (기본값: 오늘)
/// - [expenseId]: 수정할 지출의 ID (null이면 신규 등록)
///
/// **사용 예시:**
/// ```dart
/// // 신규 등록
/// AddExpenseScreen(initialDate: DateTime.now());
///
/// // 수정
/// AddExpenseScreen(expenseId: 'exp123');
/// ```
class AddExpenseScreen extends ConsumerStatefulWidget {
  final DateTime? initialDate;
  final String? expenseId;

  const AddExpenseScreen({
    super.key,
    this.initialDate,
    this.expenseId,
  });

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

/// [AddExpenseScreen]의 상태 관리 클래스
///
/// 폼 컨트롤러, 날짜/카테고리 선택 상태를 관리하며,
/// 비즈니스 로직은 [ExpenseViewModel]에 위임합니다.
///
/// **주요 책임:**
/// - UI 상태 관리 (폼 컨트롤러, 포커스 노드, 날짜/카테고리 선택)
/// - 수정 모드 시 기존 데이터 로드 및 폼 초기화 ([_loadExpense])
/// - 금액 유효성 검사 ([_validateAmount])
/// - 날짜 선택 다이얼로그 표시 ([_selectDate])
/// - 폼 제출 시 ViewModel 호출 및 결과 피드백 ([_handleSubmit])
class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _merchantController = TextEditingController();
  final _memoController = TextEditingController();
  final _amountFocusNode = FocusNode();
  final _amountFormatter = NumberFormat('#,###');

  late DateTime _selectedDate;
  String _selectedCategory = ExpenseCategoryCode.food;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;
  Expense? _originalExpense;
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _loadErrorMessage;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    if (widget.expenseId != null) {
      _isLoading = true;
      Future.microtask(_loadExpense);
    }

    // 화면 진입시 키보드 올리기
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (!mounted) return;
    //   _amountFocusNode.requestFocus();
    // });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    _memoController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadExpense() async {
    final expenseId = widget.expenseId;
    if (expenseId == null) {
      return;
    }
    try {
      final expense = await ref
          .read(expenseViewModelProvider.notifier)
          .getExpenseDetail(expenseId);

      if (!mounted) return;
      setState(() {
        _originalExpense = expense;
        _selectedDate = expense.date;
        _selectedCategory = expense.category ?? _selectedCategory;
        _selectedPaymentMethod = PaymentMethod.fromCode(
          expense.paymentMethod ?? PaymentMethod.card.code,
        );
        _amountController.text = _amountFormatter.format(expense.amount);
        _merchantController.text = expense.merchant ?? '';
        _memoController.text = expense.memo ?? '';
        _isLoading = false;
        _loadErrorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loadErrorMessage = '지출 정보를 불러오지 못했습니다';
      });
      context.showErrorToast('지출 정보를 불러오지 못했습니다. 다시 시도해주세요');
    }
  }

  Future<void> _retryLoadExpense() async {
    setState(() {
      _isLoading = true;
      _loadErrorMessage = null;
    });
    await _loadExpense();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('ko', 'KR'),
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      context.showErrorToast(
        '금액을 입력하세요',
        duration: const Duration(seconds: 2),
      );
      return '';
    }
    final amount = int.tryParse(value.replaceAll(',', ''));
    if (amount == null || amount <= 0) {
      return '올바른 금액을 입력하세요';
    }
    return null;
  }

  Future<void> _handleSubmit() async {
    if (_isSubmitting) return;
    if (widget.expenseId != null && _originalExpense == null) {
      context.showErrorToast('수정할 지출 정보를 먼저 불러와 주세요');
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    final amount = int.parse(_amountController.text.replaceAll(',', ''));
    final merchant = _merchantController.text.trim().isEmpty
        ? null
        : _merchantController.text.trim();
    final memo = _memoController.text.trim().isEmpty
        ? null
        : _memoController.text.trim();

    try {
      await ref.read(expenseViewModelProvider.notifier).submitExpense(
            amount: amount,
            date: _selectedDate,
            category: _selectedCategory,
            merchant: merchant,
            memo: memo,
            paymentMethod: _selectedPaymentMethod.code,
            expenseId: widget.expenseId,
            existingExpense: _originalExpense,
          );

      if (mounted) {
        context.showToast(
          widget.expenseId == null ? '지출이 등록되었습니다' : '지출이 수정되었습니다',
          duration: const Duration(seconds: 2),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        context.showErrorToast(
          widget.expenseId == null ? '지출 등록에 실패했습니다' : '지출 수정에 실패했습니다',
        );
        if (kDebugMode) {
          debugPrint(e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isEditing = widget.expenseId != null;

    return DefaultLayout(
      title: isEditing ? '지출 수정' : '지출 등록',
      centerTitle: true,
      canPop: false,
      leading: IconButton(
        icon: Icon(Icons.close, color: colorScheme.onSurface),
        onPressed: () => Navigator.of(context).pop(),
      ),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : (_loadErrorMessage != null
              ? RetryableLoadErrorState(
                  message: _loadErrorMessage!,
                  onRetry: _retryLoadExpense,
                  onClose: () => Navigator.of(context).pop(),
                )
              : Column(
                  children: [
                    Expanded(
                      child: NotificationListener<ScrollStartNotification>(
                        onNotification: (notification) {
                          if (notification.dragDetails != null) {
                            FocusManager.instance.primaryFocus?.unfocus();
                          }
                          return false;
                        },
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(height: 20),
                                // 1. Large Amount Input
                                AmountInputCard(
                                  controller: _amountController,
                                  focusNode: _amountFocusNode,
                                  validator: _validateAmount,
                                  amountColor: context.appColors.black,
                                  unitColor: context.appColors.textPrimary,
                                  maxDigits: 12, // 입력 허용 최대 자릿수
                                ),
                                const SizedBox(height: 24),

                                // 2. Date Selection
                                DatePickerCard(
                                  selectedDate: _selectedDate,
                                  onTap: () => _selectDate(context),
                                ),
                                const SizedBox(height: 28),

                                // 3. Additional Fields (Merchant, Memo)
                                TransactionFormCard(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 6),
                                  child: Column(
                                    children: [
                                      TransactionTextField(
                                        controller: _merchantController,
                                        hint: '어디서 썼나요?',
                                        icon: Icons.store_outlined,
                                      ),
                                      const SizedBox(height: 4),
                                      const SizedBox(height: 4),
                                      TransactionTextField(
                                        controller: _memoController,
                                        hint: '메모를 남겨주세요',
                                        icon: Icons.edit_outlined,
                                        multiline: true,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 28),

                                // 4. Category Selection
                                ExpenseCategoryGrid(
                                  selectedCategoryId: _selectedCategory,
                                  onCategorySelected: (id) {
                                    setState(() {
                                      _selectedCategory = id;
                                    });
                                  },
                                ),
                                const SizedBox(height: 28),

                                // 4. 결제 수단 선택 필드
                                Text(
                                  '결제 수단',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: context.appColors.textSecondary,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: PaymentMethod.values.map((method) {
                                    final isSelected =
                                        _selectedPaymentMethod == method;
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 12),
                                      child: ChoiceChip(
                                        label: Text(method.label),
                                        selected: isSelected,
                                        onSelected: (selected) {
                                          if (selected) {
                                            setState(() {
                                              _selectedPaymentMethod = method;
                                            });
                                          }
                                        },
                                        backgroundColor: colorScheme.surface,
                                        selectedColor:
                                            colorScheme.primaryContainer,
                                        labelStyle: TextStyle(
                                          color: isSelected
                                              ? context.appColors.black54
                                              : colorScheme.onSurfaceVariant,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                        ),
                                        side: BorderSide(
                                          color: isSelected
                                              ? colorScheme.primary
                                              : Colors.transparent,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        showCheckmark: false,
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 48),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Bottom Button
                    FormSubmitButton(
                      isVisible: MediaQuery.of(context).viewInsets.bottom == 0,
                      label: isEditing ? '수정하기' : '등록하기',
                      onPressed: _isSubmitting ? null : _handleSubmit,
                    ),
                  ],
                )),
    );
  }
}
