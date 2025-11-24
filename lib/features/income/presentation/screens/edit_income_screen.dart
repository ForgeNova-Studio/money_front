import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/color_constants.dart';
import '../../domain/entities/income_model.dart';
import '../providers/income_provider.dart';
import '../../../../core/widgets/custom_text_field.dart';

/// 수입 수정 화면
///
/// 기능:
/// - 기존 수입 정보 표시 및 수정
/// - 모든 필드 수정 가능 (금액, 날짜, 출처, 설명)
/// - 유효성 검사
/// - 수정 완료 후 이전 화면으로 돌아감
class EditIncomeScreen extends StatefulWidget {
  final IncomeModel income;

  const EditIncomeScreen({
    super.key,
    required this.income,
  });

  @override
  State<EditIncomeScreen> createState() => _EditIncomeScreenState();
}

class _EditIncomeScreenState extends State<EditIncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  late DateTime _selectedDate;
  late String _selectedSource;

  /// 5개 수입 출처 목록
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
  void initState() {
    super.initState();
    // 기존 수입 정보로 초기화
    _amountController.text = NumberFormat('#,###').format(widget.income.amount);
    _descriptionController.text = widget.income.description ?? '';
    _selectedDate = widget.income.date;
    _selectedSource = widget.income.source;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
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

  /// 수입 수정 처리
  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final incomeProvider = context.read<IncomeProvider>();
    final amount = double.parse(_amountController.text.replaceAll(',', ''));

    // 수정된 수입 모델 생성
    final updatedIncome = widget.income.copyWith(
      amount: amount,
      date: _selectedDate,
      source: _selectedSource,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
    );

    try {
      // 수정 요청
      await incomeProvider.updateIncome(
        widget.income.incomeId!,
        updatedIncome,
      );

      if (mounted) {
        // 성공 메시지
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('수입이 수정되었습니다'),
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
            content: Text(incomeProvider.errorMessage ?? '수정에 실패했습니다'),
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
        title: const Text('수입 수정'),
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

              // 수입 출처 선택
              const Text(
                '수입 출처',
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
                children: _sources.map((source) {
                  final isSelected = _selectedSource == source['code'];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSource = source['code'];
                      });
                    },
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 72) / 3,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.income.withValues(alpha: 0.1)
                            : Colors.white,
                        border: Border.all(
                          color:
                              isSelected ? AppColors.income : AppColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            source['icon'],
                            color: isSelected
                                ? AppColors.income
                                : AppColors.textSecondary,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            source['name'],
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected
                                  ? AppColors.income
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

              // 설명 입력
              CustomTextField(
                label: '설명 (선택)',
                hintText: '메모를 입력하세요',
                controller: _descriptionController,
                maxLines: 3,
              ),
              const SizedBox(height: 32),

              // 수정 버튼
              Consumer<IncomeProvider>(
                builder: (context, incomeProvider, child) {
                  final isLoading =
                      incomeProvider.status == IncomeStatus.loading;

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
