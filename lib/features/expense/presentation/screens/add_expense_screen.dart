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

  late DateTime _selectedDate;
  String _selectedCategory = 'FOOD';
  PaymentMethod _selectedPaymentMethod = PaymentMethod.card;

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
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
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
    final amount = double.tryParse(value.replaceAll(',', ''));
    if (amount == null || amount <= 0) {
      return '올바른 금액을 입력하세요';
    }
    return null;
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'restaurant':
        return Icons.restaurant;
      case 'local_cafe':
        return Icons.local_cafe;
      case 'directions_bus':
        return Icons.directions_bus;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'home':
        return Icons.home;
      case 'movie':
        return Icons.movie;
      case 'medical_services':
        return Icons.medical_services;
      case 'school':
        return Icons.school;
      case 'more_horiz':
        return Icons.more_horiz;
      default:
        return Icons.category;
    }
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
      store: _merchantController.text.trim().isEmpty
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
    ref.watch(expenseViewModelProvider);

    return PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              '지출 등록',
              style: TextStyle(
                color: context.appColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.close, color: context.appColors.textPrimary),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 32),
                        // 1. Large Amount Input
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IntrinsicWidth(
                                child: TextFormField(
                                  controller: _amountController,
                                  validator: _validateAmount,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: context.appColors.primary,
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
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    _ThousandsSeparatorInputFormatter(),
                                  ],
                                  autofocus: true,
                                  showCursor: false,
                                ),
                              ),
                              SizedBox(width: 4),
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
                        SizedBox(height: 40),

                        // 2. Date Selection
                        GestureDetector(
                          onTap: () => _selectDate(context),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              color: context.appColors.backgroundLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today,
                                    color: context.appColors.textSecondary, size: 20),
                                SizedBox(width: 12),
                                Text(
                                  DateFormat('yyyy년 M월 d일 (E)', 'ko_KR')
                                      .format(_selectedDate),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: context.appColors.textPrimary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 32),

                        // 3. Category Selection
                        Text(
                          '카테고리',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: context.appColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 90,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: DefaultCategories.all.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(width: 20),
                            itemBuilder: (context, index) {
                              final category = DefaultCategories.all[index];
                              final isSelected =
                                  _selectedCategory == category.id;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedCategory = category.id;
                                  });
                                },
                                child: Column(
                                  children: [
                                    AnimatedContainer(
                                      duration:
                                          Duration(milliseconds: 200),
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? context.appColors.primary
                                            : context.appColors.backgroundLight,
                                        shape: BoxShape.circle,
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: context.appColors.primary
                                                      .withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: Offset(0, 4),
                                                )
                                              ]
                                            : [],
                                      ),
                                      child: Icon(
                                        _getIconData(category.icon),
                                        color: isSelected
                                            ? Colors.white
                                            : context.appColors.textSecondary,
                                        size: 24,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      category.name,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isSelected
                                            ? context.appColors.primary
                                            : context.appColors.textSecondary,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 32),

                        // 4. Additional Fields (Merchant, Memo)
                        _buildCleanTextField(
                          controller: _merchantController,
                          label: '가맹점',
                          hint: '어디서 썼나요?',
                          icon: Icons.store_outlined,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(height: 1, color: context.appColors.gray200),
                        ),
                        _buildCleanTextField(
                          controller: _memoController,
                          label: '메모',
                          hint: '메모를 남겨주세요',
                          icon: Icons.edit_outlined,
                        ),
                        SizedBox(height: 24),

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
                              padding: EdgeInsets.only(right: 12),
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
                                backgroundColor: context.appColors.backgroundLight,
                                selectedColor:
                                    context.appColors.primary.withOpacity(0.1),
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? context.appColors.primary
                                      : context.appColors.textSecondary,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                                side: BorderSide(
                                  color: isSelected
                                      ? context.appColors.primary
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
                        SizedBox(height: 48),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Button
              Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.appColors.primary,
                      foregroundColor: Colors.white,
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
  }) {
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
            style: TextStyle(color: context.appColors.textPrimary, fontSize: 16),
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
