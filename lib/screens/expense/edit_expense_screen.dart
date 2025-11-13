import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/color_constants.dart';
import '../../data/models/expense_model.dart';
import '../../providers/expense_provider.dart';
import '../../widgets/custom_text_field.dart';

/// 지출 수정 화면
///
/// 기능:
/// - 기존 지출 정보 표시 및 수정
/// - 모든 필드 수정 가능 (금액, 날짜, 카테고리, 가맹점, 결제수단, 메모)
/// - 유효성 검사
/// - 수정 완료 후 이전 화면으로 돌아감
class EditExpenseScreen extends StatefulWidget {
  final ExpenseModel expense;

  const EditExpenseScreen({
    super.key,
    required this.expense,
  });

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _merchantController = TextEditingController();
  final _memoController = TextEditingController();

  late DateTime _selectedDate;
  late String _selectedCategory;
  late String _selectedPaymentMethod;

  /// 9개 카테고리 목록
  final List<Map<String, dynamic>> _categories = [
    {'code': 'FOOD', 'name': '식비', 'icon': Icons.restaurant},
    {'code': 'TRANSPORT', 'name': '교통', 'icon': Icons.directions_car},
    {'code': 'SHOPPING', 'name': '쇼핑', 'icon': Icons.shopping_bag},
    {'code': 'CULTURE', 'name': '문화생활', 'icon': Icons.movie},
    {'code': 'HOUSING', 'name': '주거/통신', 'icon': Icons.home},
    {'code': 'MEDICAL', 'name': '의료/건강', 'icon': Icons.local_hospital},
    {'code': 'EDUCATION', 'name': '교육', 'icon': Icons.school},
    {'code': 'EVENT', 'name': '경조사', 'icon': Icons.card_giftcard},
    {'code': 'ETC', 'name': '기타', 'icon': Icons.more_horiz},
  ];

  /// 3개 결제 수단
  final List<Map<String, String>> _paymentMethods = [
    {'code': 'CARD', 'name': '카드'},
    {'code': 'CASH', 'name': '현금'},
    {'code': 'TRANSFER', 'name': '계좌이체'},
  ];

  @override
  void initState() {
    super.initState();
    // 기존 지출 정보로 초기화
    _amountController.text =
        NumberFormat('#,###').format(widget.expense.amount);
    _merchantController.text = widget.expense.merchant ?? '';
    _memoController.text = widget.expense.memo ?? '';
    _selectedDate = widget.expense.date;
    _selectedCategory = widget.expense.category;
    _selectedPaymentMethod = widget.expense.paymentMethod ?? 'CARD';
  }

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  /// 날짜 선택 다이얼로그 표시
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  /// 금액 유효성 검사
  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return '금액을 입력하세요';
    }
    final amount = double.tryParse(value.replaceAll(',', ''));
    if (amount == null || amount <= 0) {
      return '올바른 금액을 입력하세요';
    }
    return null;
  }

  /// 지출 수정 처리
  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final expenseProvider = context.read<ExpenseProvider>();
    final amount = double.parse(_amountController.text.replaceAll(',', ''));

    // 수정된 지출 모델 생성
    final updatedExpense = widget.expense.copyWith(
      amount: amount,
      date: _selectedDate,
      category: _selectedCategory,
      merchant: _merchantController.text.trim().isEmpty
          ? null
          : _merchantController.text.trim(),
      memo: _memoController.text.trim().isEmpty
          ? null
          : _memoController.text.trim(),
      paymentMethod: _selectedPaymentMethod,
      isAutoCategorized: false, // 수동으로 수정했으므로 false
    );

    try {
      // 수정 요청
      await expenseProvider.updateExpense(
        widget.expense.expenseId!,
        updatedExpense,
      );

      if (mounted) {
        // 성공 메시지
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('지출이 수정되었습니다'),
            backgroundColor: AppColors.success,
          ),
        );
        // 이전 화면으로 돌아감 (성공 신호 전달)
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        // 오류 메시지
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(expenseProvider.errorMessage ?? '수정에 실패했습니다'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('지출 수정'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 금액 입력
              CustomTextField(
                label: '금액',
                hintText: '0',
                controller: _amountController,
                validator: _validateAmount,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  _ThousandsSeparatorInputFormatter(),
                ],
                suffixIcon: const Padding(
                  padding: EdgeInsets.only(right: 16, top: 14),
                  child: Text('원', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),

              // 날짜 선택
              InkWell(
                onTap: () => _selectDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: '날짜',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                  child: Text(
                    DateFormat('yyyy년 M월 d일').format(_selectedDate),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 카테고리 선택
              const Text(
                '카테고리',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _categories.map((category) {
                  final isSelected = _selectedCategory == category['code'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category['code'];
                      });
                    },
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 72) / 3,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            category['icon'],
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category['name'],
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // 가맹점 입력
              CustomTextField(
                label: '가맹점 (선택)',
                hintText: '예: 스타벅스',
                controller: _merchantController,
              ),
              const SizedBox(height: 20),

              // 결제 수단
              const Text(
                '결제 수단',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: _paymentMethods.map((method) {
                  final isSelected = _selectedPaymentMethod == method['code'];
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPaymentMethod = method['code']!;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            method['name']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // 메모 입력
              CustomTextField(
                label: '메모 (선택)',
                hintText: '메모를 입력하세요',
                controller: _memoController,
                maxLines: 3,
              ),
              const SizedBox(height: 32),

              // 수정 버튼
              Consumer<ExpenseProvider>(
                builder: (context, expenseProvider, child) {
                  final isLoading =
                      expenseProvider.status == ExpenseStatus.loading;

                  return ElevatedButton(
                    onPressed: isLoading ? null : _handleSubmit,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('수정 완료'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 천 단위 구분 기호 입력 포맷터
/// 숫자 입력 시 자동으로 1,000 형태로 변환
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
