// packages
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// core
import 'package:moneyflow/core/constants/app_constants.dart';
import 'package:moneyflow/core/constants/income_sources.dart';
import 'package:moneyflow/features/common/widgets/transaction_form/amount_input_card.dart';
import 'package:moneyflow/features/common/widgets/transaction_form/date_picker_card.dart';
import 'package:moneyflow/features/common/widgets/transaction_form/form_submit_button.dart';
import 'package:moneyflow/features/common/widgets/transaction_form/transaction_form_card.dart';
import 'package:moneyflow/features/common/widgets/transaction_form/transaction_form_styles.dart';
import 'package:moneyflow/features/common/widgets/transaction_form/transaction_text_field.dart';

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
  final _amountFocusNode = FocusNode();

  late DateTime _selectedDate;
  String _selectedSource = IncomeSource.salary;

  @override
  void initState() {
    super.initState();

    // 홈에서 선택된 날짜가 있다면 선택됨
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  // 날짜 선택 모달 열기
  Future<void> _selectDate(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
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

  // 금액 유효성 검사
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

  // 등록
  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.parse(_amountController.text.replaceAll(',', ''));

    // Income 엔티티 작성
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
    final colorScheme = Theme.of(context).colorScheme;
    // Provider를 watch하여 화면이 살아있는 동안 Provider가 dispose되지 않도록 함
    ref.watch(incomeViewModelProvider);
    final sources = buildIncomeSources(context);

    return PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            title: Text(
              '수입 등록',
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
                // 스크롤 시작시 키보드를 자동으로 내리기 위한 처리
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
                          // 1. 금액 입력 필드
                          AmountInputCard(
                            controller: _amountController,
                            focusNode: _amountFocusNode,
                            validator: _validateAmount,
                            amountColor: context.appColors.primary,
                            unitColor: context.appColors.textPrimary,
                          ),
                          const SizedBox(height: 24),

                          // 2. 날짜 선택 필드
                          DatePickerCard(
                            selectedDate: _selectedDate,
                            onTap: () => _selectDate(context),
                          ),
                          const SizedBox(height: 28),

                          // 3. Source Selection
                          Text(
                            '수입 출처',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: context.appColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // 수입 출처 GridView
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final itemWidth = (constraints.maxWidth - 24) / 3;
                              return Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: sources.map((source) {
                                  final isSelected =
                                      _selectedSource == source.code;
                                  return SizedBox(
                                    width: itemWidth,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(20),
                                        onTap: () {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          setState(() {
                                            _selectedSource = source.code;
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 14),
                                          decoration:
                                              transactionFormCardDecoration(
                                            context,
                                            backgroundColor: isSelected
                                                ? source.color.withOpacity(0.12)
                                                : Colors.white,
                                          ),
                                          child: Column(
                                            children: [
                                              Container(
                                                width: 36,
                                                height: 36,
                                                decoration: BoxDecoration(
                                                  color: isSelected
                                                      ? source.color
                                                      : source.color
                                                          .withOpacity(0.12),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  source.icon,
                                                  color: isSelected
                                                      ? Colors.white
                                                      : source.color,
                                                  size: 18,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                source.name,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: isSelected
                                                      ? source.color
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

                          // 4. 메모 필드
                          TransactionFormCard(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            child: TransactionTextField(
                              controller: _descriptionController,
                              hint: '어떤 수입인가요?',
                              icon: Icons.edit_outlined,
                              multiline: true,
                            ),
                          ),
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 등록하기 버튼
              FormSubmitButton(
                isVisible: MediaQuery.of(context).viewInsets.bottom == 0,
                label: '등록하기',
                onPressed: _handleSubmit,
              ),
            ],
          ),
        ));
  }
}
