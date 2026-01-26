// packages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// entities
import 'package:moamoa/features/expense/domain/entities/expense.dart';
import 'package:moamoa/features/home/domain/entities/transaction_entity.dart';
import 'package:moamoa/features/expense/domain/entities/payment_method.dart';
import 'package:moamoa/features/expense/presentation/utils/expense_category_utils.dart';
import 'package:moamoa/features/expense/presentation/providers/expense_providers.dart';

// viewmodels
import 'package:moamoa/features/expense/presentation/viewmodels/expense_view_model.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';

// constants
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/core/constants/expense_categories.dart';
import 'package:moamoa/features/common/widgets/transaction_form/amount_input_card.dart';
import 'package:moamoa/features/common/widgets/transaction_form/date_picker_card.dart';
import 'package:moamoa/features/common/widgets/transaction_form/form_submit_button.dart';
import 'package:moamoa/features/common/widgets/transaction_form/transaction_form_card.dart';
import 'package:moamoa/features/common/widgets/transaction_form/transaction_form_styles.dart';
import 'package:moamoa/features/common/widgets/transaction_form/transaction_text_field.dart';

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

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _merchantController = TextEditingController();
  final _memoController = TextEditingController();
  final _amountFocusNode = FocusNode();
  final _amountFormatter = NumberFormat('#,###');

  late DateTime _selectedDate;
  String _selectedCategory = 'FOOD';
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;
  Expense? _originalExpense;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    if (widget.expenseId != null) {
      _isLoading = true;
      Future.microtask(_loadExpense);
    }
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
      final expense =
          await ref.read(getExpenseDetailUseCaseProvider).call(expenseId);
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
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
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
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text('금액을 입력하세요'),
            backgroundColor: context.appColors.error,
          ),
        );
      return '';
    }
    final amount = int.tryParse(value.replaceAll(',', ''));
    if (amount == null || amount <= 0) {
      return '올바른 금액을 입력하세요';
    }
    return null;
  }

  Color _categoryColor(String hexColor) {
    final value = int.parse(hexColor, radix: 16);
    return Color(0xFF000000 | value);
  }

  Future<void> _handleSubmit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = int.parse(_amountController.text.replaceAll(',', ''));

    try {
      if (widget.expenseId != null) {
        final base = _originalExpense;
        if (base == null) {
          return;
        }
        final updated = base.copyWith(
          amount: amount,
          date: _selectedDate,
          category: _selectedCategory,
          merchant: _merchantController.text.trim().isEmpty
              ? null
              : _merchantController.text.trim(),
          memo: _memoController.text.trim().isEmpty
              ? null
              : _memoController.text.trim(),
          paymentMethod: _selectedPaymentMethod.code,
        );

        // 1. Optimistic Update
        final oldTransaction = TransactionEntity.fromExpense(base);
        final newTransaction = TransactionEntity.fromExpense(
            updated.copyWith(expenseId: base.expenseId ?? widget.expenseId));

        ref
            .read(homeViewModelProvider.notifier)
            .updateTransactionOptimistically(
              oldTransaction: oldTransaction,
              newTransaction: newTransaction,
            );

        // 2. 백그라운드 API 호출
        await ref.read(updateExpenseUseCaseProvider).call(
            expenseId: base.expenseId ?? widget.expenseId!, expense: updated);
      } else {
        final expense = Expense(
          amount: amount,
          date: _selectedDate,
          category: _selectedCategory,
          merchant: _merchantController.text.trim().isEmpty
              ? null
              : _merchantController.text.trim(),
          memo: _memoController.text.trim().isEmpty
              ? null
              : _memoController.text.trim(),
          paymentMethod: _selectedPaymentMethod.code,
        );

        // 1. Optimistic Update: 먼저 로컬 상태 업데이트
        final optimisticTransaction = TransactionEntity(
          id: '', // 임시 ID (API 응답 후 갱신됨)
          amount: amount,
          date: _selectedDate,
          title: expense.merchant ?? _selectedCategory,
          category: _selectedCategory,
          memo: expense.memo,
          type: TransactionType.expense,
          createdAt: DateTime.now(),
        );
        ref
            .read(homeViewModelProvider.notifier)
            .addTransactionOptimistically(optimisticTransaction);

        // 2. 백그라운드에서 실제 API 호출
        await ref
            .read(expenseViewModelProvider.notifier)
            .createExpense(expense);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.expenseId == null ? '지출이 등록되었습니다' : '지출이 수정되었습니다',
            ),
            backgroundColor: context.appColors.success,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      // TODO: API 호출 실패 시 Optimistic Update를 롤백하는 로직 추가 필요 (이전 상태로 복구)
      if (mounted) {
        if (kDebugMode) {
          debugPrint(e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    ref.watch(expenseViewModelProvider);
    final isEditing = widget.expenseId != null;

    return PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            title: Text(
              isEditing ? '지출 수정' : '지출 등록',
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            backgroundColor: colorScheme.surface,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close, color: colorScheme.onSurface),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
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
                                ),
                                const SizedBox(height: 24),

                                // 2. Date Selection
                                DatePickerCard(
                                  selectedDate: _selectedDate,
                                  onTap: () => _selectDate(context),
                                ),
                                const SizedBox(height: 28),

                                // 3. Category Selection
                                Text(
                                  '카테고리',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: context.appColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    final itemWidth =
                                        (constraints.maxWidth - 24) / 3;
                                    return Wrap(
                                      spacing: 12,
                                      runSpacing: 12,
                                      children: DefaultExpenseCategories.all
                                          .map((category) {
                                        final isSelected =
                                            _selectedCategory == category.id;
                                        final color =
                                            _categoryColor(category.color);
                                        return SizedBox(
                                          width: itemWidth,
                                          child: Material(
                                            color: Colors.transparent,
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              onTap: () {
                                                setState(() {
                                                  _selectedCategory =
                                                      category.id;
                                                });
                                              },
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 200),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 14),
                                                decoration:
                                                    transactionFormCardDecoration(
                                                  context,
                                                  backgroundColor: isSelected
                                                      ? color.withOpacity(0.12)
                                                      : Colors.white,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      width: 36,
                                                      height: 36,
                                                      decoration: BoxDecoration(
                                                        color: isSelected
                                                            ? color
                                                            : color.withOpacity(
                                                                0.12),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(
                                                        expenseIconFromName(
                                                            category.icon),
                                                        color: isSelected
                                                            ? Colors.white
                                                            : color,
                                                        size: 18,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      category.name,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: isSelected
                                                            ? color
                                                            : context.appColors
                                                                .textSecondary,
                                                        fontWeight: isSelected
                                                            ? FontWeight.w700
                                                            : FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                ),
                                const SizedBox(height: 28),

                                // 4. Additional Fields (Merchant, Memo)
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
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      TransactionTextField(
                                        controller: _memoController,
                                        hint: '메모를 남겨주세요',
                                        icon: Icons.edit_outlined,
                                        multiline: true,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // 5. 결제 수단 선택 필드
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
                      onPressed: _handleSubmit,
                    ),
                  ],
                ),
        ));
  }
}
