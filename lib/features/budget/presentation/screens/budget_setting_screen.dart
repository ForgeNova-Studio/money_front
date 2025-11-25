import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moneyflow/features/budget/presentation/providers/budget_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/budget_model.dart';

/// 예산 설정 화면
///
/// 기능:
/// - 월별 목표 예산 설정
/// - 기존 예산이 있으면 수정, 없으면 생성
/// - 금액 입력 및 유효성 검사
class BudgetSettingScreen extends StatefulWidget {
  final int? initialYear;
  final int? initialMonth;

  const BudgetSettingScreen({
    super.key,
    this.initialYear,
    this.initialMonth,
  });

  @override
  State<BudgetSettingScreen> createState() => _BudgetSettingScreenState();
}

class _BudgetSettingScreenState extends State<BudgetSettingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();

  late int _selectedYear;
  late int _selectedMonth;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedYear = widget.initialYear ?? now.year;
    _selectedMonth = widget.initialMonth ?? now.month;

    // 기존 예산 조회
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExistingBudget();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  /// 기존 예산 조회
  Future<void> _loadExistingBudget() async {
    final budgetProvider = context.read<BudgetProvider>();
    await budgetProvider.fetchBudget(_selectedYear, _selectedMonth);

    if (budgetProvider.budget != null && mounted) {
      _amountController.text =
          NumberFormat('#,###').format(budgetProvider.budget!.targetAmount);
    }
  }

  /// 예산 저장
  Future<void> _saveBudget() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amountText = _amountController.text.replaceAll(',', '');
    final amount = double.tryParse(amountText);

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('유효한 금액을 입력해주세요')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final budget = BudgetModel(
      year: _selectedYear,
      month: _selectedMonth,
      targetAmount: amount,
    );

    final budgetProvider = context.read<BudgetProvider>();
    await budgetProvider.createOrUpdateBudget(budget);

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      if (budgetProvider.status == BudgetStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('예산이 설정되었습니다')),
        );
        Navigator.of(context).pop(true);
      } else if (budgetProvider.status == BudgetStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(budgetProvider.errorMessage ?? '예산 설정에 실패했습니다'),
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
        title: const Text('목표 예산 설정'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<BudgetProvider>(
        builder: (context, budgetProvider, child) {
          if (budgetProvider.status == BudgetStatus.loading && !_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 안내 문구
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '월별 목표 예산을 설정하고\n지출을 관리하세요',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // 년도/월 선택
                  const Text(
                    '기간 선택',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      // 년도 선택
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: _selectedYear,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              items: List.generate(
                                10,
                                (index) {
                                  final year = DateTime.now().year - 5 + index;
                                  return DropdownMenuItem(
                                    value: year,
                                    child: Text('$year년'),
                                  );
                                },
                              ),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedYear = value;
                                  });
                                  _loadExistingBudget();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // 월 선택
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: _selectedMonth,
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              items: List.generate(
                                12,
                                (index) => DropdownMenuItem(
                                  value: index + 1,
                                  child: Text('${index + 1}월'),
                                ),
                              ),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _selectedMonth = value;
                                  });
                                  _loadExistingBudget();
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 목표 금액 입력
                  const Text(
                    '목표 금액',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        if (newValue.text.isEmpty) {
                          return newValue;
                        }
                        final number = int.tryParse(newValue.text);
                        if (number == null) {
                          return oldValue;
                        }
                        final formatted = NumberFormat('#,###').format(number);
                        return TextEditingValue(
                          text: formatted,
                          selection: TextSelection.collapsed(
                            offset: formatted.length,
                          ),
                        );
                      }),
                    ],
                    decoration: InputDecoration(
                      hintText: '예: 1,000,000',
                      suffixText: '원',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.primary, width: 2),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '목표 금액을 입력해주세요';
                      }
                      final amountText = value.replaceAll(',', '');
                      final amount = double.tryParse(amountText);
                      if (amount == null || amount <= 0) {
                        return '유효한 금액을 입력해주세요';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '월간 지출 목표 금액을 설정하세요',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 48),

                  // 저장 버튼
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveBudget,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            '저장',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
