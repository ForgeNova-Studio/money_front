// packages
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// core
import '../../../../core/constants/app_constants.dart';

// features
import 'package:moneyflow/features/income/presentation/viewmodels/income_view_model.dart';
import 'package:moneyflow/features/home/presentation/viewmodels/home_view_model.dart';

// entities
import 'package:moneyflow/features/income/domain/entities/income.dart';

class AddIncomeScreen extends ConsumerStatefulWidget {
  final DateTime? initialDate;

  const AddIncomeScreen({
    super.key,
    this.initialDate,
  });

  @override
  ConsumerState<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends ConsumerState<AddIncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  late DateTime _selectedDate;
  String _selectedSource = IncomeSource.salary;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  final List<Map<String, dynamic>> _sources = [
    {'code': IncomeSource.salary, 'name': '급여', 'icon': Icons.work},
    {
      'code': IncomeSource.sideIncome,
      'name': '부수입',
      'icon': Icons.attach_money
    },
    {'code': IncomeSource.bonus, 'name': '상여금', 'icon': Icons.card_giftcard},
    {
      'code': IncomeSource.investment,
      'name': '투자수익',
      'icon': Icons.trending_up
    },
    {'code': IncomeSource.other, 'name': '기타', 'icon': Icons.more_horiz},
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
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

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.parse(_amountController.text.replaceAll(',', ''));

    final income = Income(
      amount: amount,
      date: _selectedDate,
      source: _selectedSource,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    try {
      await ref.read(incomeViewModelProvider.notifier).createIncome(income);

      if (mounted) {
        // 새로운 데이터 즉시 갱신 되도록 변경
        ref
            .read(homeViewModelProvider.notifier)
            .fetchMonthlyData(_selectedDate, forceRefresh: true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('수입이 등록되었습니다'),
            backgroundColor: context.appColors.success,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted && kDebugMode) {
        debugPrint(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Provider를 watch하여 화면이 살아있는 동안 Provider가 dispose되지 않도록 함
    ref.watch(incomeViewModelProvider);

    return PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              '수입 등록',
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
                                    color: context.appColors.income,
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

                        // 3. Source Selection (Similar to Category in Expense)
                        Text(
                          '수입 출처',
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
                            itemCount: _sources.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(width: 20),
                            itemBuilder: (context, index) {
                              final source = _sources[index];
                              final isSelected =
                                  _selectedSource == source['code'];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedSource = source['code'];
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
                                            ? context.appColors.income
                                            : context.appColors.backgroundLight,
                                        shape: BoxShape.circle,
                                        boxShadow: isSelected
                                            ? [
                                                BoxShadow(
                                                  color: context.appColors.income
                                                      .withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: Offset(0, 4),
                                                )
                                              ]
                                            : [],
                                      ),
                                      child: Icon(
                                        source['icon'],
                                        color: isSelected
                                            ? Colors.white
                                            : context.appColors.textSecondary,
                                        size: 24,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      source['name'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isSelected
                                            ? context.appColors.income
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
                        const SizedBox(height: 32),

                        // 4. Description Field
                        _buildCleanTextField(
                          controller: _descriptionController,
                          label: '설명',
                          hint: '어떤 수입인가요?',
                          icon: Icons.edit_outlined,
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
                      backgroundColor: context.appColors.income,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Icon(icon, color: context.appColors.textSecondary, size: 24),
        ),
        SizedBox(width: 16),
        Expanded(
          child: SizedBox(
            height: 120,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: context.appColors.gray400),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
              ),
              style: TextStyle(
                color: context.appColors.textPrimary,
                fontSize: 16,
                height: 1.5,
              ),
              maxLines: null,
              expands: true,
              keyboardType: TextInputType.multiline,
              textAlignVertical: TextAlignVertical.top,
            ),
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
