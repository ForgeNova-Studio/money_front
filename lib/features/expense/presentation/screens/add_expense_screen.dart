// packages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// entities
import 'package:moneyflow/features/expense/domain/entities/expense.dart';
import 'package:moneyflow/features/expense/domain/entities/expense_category.dart';
import 'package:moneyflow/features/expense/domain/entities/payment_method.dart';
import 'package:moneyflow/features/expense/presentation/utils/expense_category_utils.dart';

// viewmodels
import 'package:moneyflow/features/expense/presentation/viewmodels/expense_view_model.dart';
import 'package:moneyflow/features/home/presentation/viewmodels/home_view_model.dart';

// constants
import 'package:moneyflow/core/constants/app_constants.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  final DateTime? initialDate;

  const AddExpenseScreen({
    super.key,
    this.initialDate,
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

  late DateTime _selectedDate;
  String _selectedCategory = 'FOOD';
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    _memoController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
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

  BoxDecoration _buildCardDecoration({
    Color? backgroundColor,
    double borderRadius = 20,
  }) {
    return BoxDecoration(
      color: backgroundColor ?? Colors.white,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: context.appColors.shadow.withOpacity(0.08),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
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
    final amount = double.tryParse(value.replaceAll(',', ''));
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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.parse(_amountController.text.replaceAll(',', ''));

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

    try {
      await ref.read(expenseViewModelProvider.notifier).createExpense(expense);

      if (mounted) {
        // 새로운 데이터 즉시 갱신 되도록 변경
        ref
            .read(homeViewModelProvider.notifier)
            .fetchMonthlyData(_selectedDate, forceRefresh: true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('지출이 등록되었습니다'),
            backgroundColor: context.appColors.success,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
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

    return PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            title: Text(
              '지출 등록',
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
            surfaceTintColor: context.appColors.transparent,
          ),
          body: Column(
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
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _amountFocusNode.requestFocus(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 24),
                            decoration: _buildCardDecoration(),
                            child: Column(
                              children: [
                                Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      IntrinsicWidth(
                                        child: TextFormField(
                                          controller: _amountController,
                                          focusNode: _amountFocusNode,
                                          validator: _validateAmount,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          onTap: () {
                                            _amountFocusNode.requestFocus();
                                          },
                                          style: TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                            color: context.appColors.black,
                                          ),
                                          decoration: InputDecoration(
                                            filled: false,
                                            hintText: '0',
                                            hintStyle: TextStyle(
                                              color: context.appColors.gray300,
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            focusedErrorBorder:
                                                InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            errorStyle: const TextStyle(
                                              height: 0,
                                              color: Colors.transparent,
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            _ThousandsSeparatorInputFormatter(),
                                          ],
                                          autofocus: false,
                                          showCursor: false,
                                          cursorColor: Colors.transparent,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '원',
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.w600,
                                          color: context.appColors.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 2. Date Selection
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            decoration: _buildCardDecoration(),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: context.appColors.primary
                                        .withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.calendar_today,
                                    color: context.appColors.primary,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    DateFormat('yyyy년 M월 d일 (E)', 'ko_KR')
                                        .format(_selectedDate),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: context.appColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: context.appColors.gray400,
                                ),
                              ],
                            ),
                          ),
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
                            final itemWidth = (constraints.maxWidth - 24) / 3;
                            return Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: DefaultCategories.all.map((category) {
                                final isSelected =
                                    _selectedCategory == category.id;
                                final color = _categoryColor(category.color);
                                return SizedBox(
                                  width: itemWidth,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      onTap: () {
                                        setState(() {
                                          _selectedCategory = category.id;
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 14),
                                        decoration: _buildCardDecoration(
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
                                                    : color.withOpacity(0.12),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                expenseIconFromName(category.icon),
                                                color: isSelected
                                                    ? Colors.white
                                                    : color,
                                                size: 18,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              category.name,
                                              textAlign: TextAlign.center,
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
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: _buildCardDecoration(),
                          child: Column(
                            children: [
                              _buildCleanTextField(
                                controller: _merchantController,
                                label: '가맹점',
                                hint: '어디서 썼나요?',
                                icon: Icons.store_outlined,
                              ),
                              Divider(
                                height: 1,
                                color: context.appColors.gray200,
                              ),
                              _buildCleanTextField(
                                controller: _memoController,
                                label: '메모',
                                hint: '메모를 남겨주세요',
                                icon: Icons.edit_outlined,
                                multiline: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // 5. Payment Method
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
                            final isSelected = _selectedPaymentMethod == method;
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
                                selectedColor: colorScheme.primaryContainer,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? colorScheme.primary
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
                                  borderRadius: BorderRadius.circular(20),
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
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) {
                  final slide = Tween<Offset>(
                    begin: const Offset(0, 0.2),
                    end: Offset.zero,
                  ).animate(animation);
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(position: slide, child: child),
                  );
                },
                child: MediaQuery.of(context).viewInsets.bottom == 0
                    ? Padding(
                        key: const ValueKey('submit-button'),
                        padding: EdgeInsets.fromLTRB(24, 0, 24, 40),
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _handleSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              '등록하기',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(
                        key: ValueKey('submit-placeholder'),
                      ),
              ),
            ],
          ),
        ));
  }

  Widget _buildCleanTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool multiline = false,
    int? minLines,
  }) {
    final resolvedMinLines = multiline ? (minLines ?? 3) : 1;
    return Row(
      children: [
        Icon(icon, color: context.appColors.textSecondary, size: 24),
        SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: context.appColors.gray400),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 16),
            ),
            style:
                TextStyle(color: context.appColors.textPrimary, fontSize: 16),
            keyboardType: multiline ? TextInputType.multiline : TextInputType.text,
            textInputAction:
                multiline ? TextInputAction.newline : TextInputAction.done,
            minLines: resolvedMinLines,
            maxLines: multiline ? null : 1,
          ),
        ),
      ],
    );
  }
}

/// 천 단위 구분 기호 입력 포맷터
class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,###');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final number = int.tryParse(newValue.text.replaceAll(',', ''));
    if (number == null) {
      return oldValue;
    }

    final formatted = _formatter.format(number);
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
