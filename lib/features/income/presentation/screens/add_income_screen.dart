// packages
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// core
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/core/constants/income_sources.dart';
import 'package:moamoa/features/common/widgets/transaction_form/amount_input_card.dart';
import 'package:moamoa/features/common/widgets/transaction_form/date_picker_card.dart';
import 'package:moamoa/features/common/widgets/transaction_form/form_submit_button.dart';
import 'package:moamoa/features/common/widgets/transaction_form/transaction_form_card.dart';
import 'package:moamoa/features/common/widgets/transaction_form/transaction_form_styles.dart';
import 'package:moamoa/features/common/widgets/transaction_form/transaction_text_field.dart';
import 'package:moamoa/features/income/presentation/providers/income_providers.dart';

// features
import 'package:moamoa/features/income/presentation/viewmodels/income_view_model.dart';
import 'package:moamoa/features/home/presentation/viewmodels/home_view_model.dart';

// entities
import 'package:moamoa/features/income/domain/entities/income.dart';
import 'package:moamoa/features/home/domain/entities/transaction_entity.dart';

class AddIncomeScreen extends ConsumerStatefulWidget {
  final DateTime? initialDate;
  final String? incomeId;

  const AddIncomeScreen({
    super.key,
    this.initialDate,
    this.incomeId,
  });

  @override
  ConsumerState<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends ConsumerState<AddIncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountFocusNode = FocusNode();
  final _amountFormatter = NumberFormat('#,###');

  late DateTime _selectedDate;
  String _selectedSource = IncomeSource.salary;
  Income? _originalIncome;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // 홈에서 선택된 날짜가 있다면 선택됨
    _selectedDate = widget.initialDate ?? DateTime.now();
    if (widget.incomeId != null) {
      _isLoading = true;
      Future.microtask(_loadIncome);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadIncome() async {
    final incomeId = widget.incomeId;
    if (incomeId == null) {
      return;
    }
    try {
      final income = await ref
          .read(getIncomeDetailUsecaseProvider)
          .call(incomeId: incomeId);
      if (!mounted) return;
      setState(() {
        _originalIncome = income;
        _selectedDate = income.date;
        _selectedSource = income.source;
        _amountController.text = _amountFormatter.format(income.amount);
        _descriptionController.text = income.description ?? '';
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
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
    final amount = int.tryParse(value.replaceAll(',', ''));
    if (amount == null || amount <= 0) {
      return '올바른 금액을 입력하세요';
    }
    return null;
  }

  // 등록
  Future<void> _handleSubmit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = int.parse(_amountController.text.replaceAll(',', ''));

    try {
      if (widget.incomeId != null) {
        final base = _originalIncome;
        if (base == null) {
          return;
        }
        final updated = base.copyWith(
          amount: amount,
          date: _selectedDate,
          source: _selectedSource,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
        );

        // 1. Optimistic Update
        final oldTransaction = TransactionEntity.fromIncome(base);
        final newTransaction = TransactionEntity.fromIncome(
            updated.copyWith(incomeId: base.incomeId ?? widget.incomeId));

        ref
            .read(homeViewModelProvider.notifier)
            .updateTransactionOptimistically(
              oldTransaction: oldTransaction,
              newTransaction: newTransaction,
            );

        // 2. 백그라운드 API 호출
        await ref.read(updateIncomeUsecaseProvider).call(
              incomeId: base.incomeId ?? widget.incomeId!,
              income: updated,
            );
      } else {
        // Income 엔티티 작성
        final income = Income(
          amount: amount,
          date: _selectedDate,
          source: _selectedSource,
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
        );

        // 1. Optimistic Update: 먼저 로컬 상태 업데이트
        final optimisticTransaction = TransactionEntity(
          id: '', // 임시 ID (API 응답 후 갱신됨)
          amount: amount,
          date: _selectedDate,
          title: income.description ?? _selectedSource,
          category: _selectedSource,
          memo: null,
          type: TransactionType.income,
          createdAt: DateTime.now(),
        );
        ref
            .read(homeViewModelProvider.notifier)
            .addTransactionOptimistically(optimisticTransaction);

        // 2. 백그라운드에서 실제 API 호출
        await ref.read(incomeViewModelProvider.notifier).createIncome(income);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.incomeId == null ? '수입이 등록되었습니다' : '수입이 수정되었습니다',
            ),
            backgroundColor: context.appColors.success,
          ),
        );
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      // TODO: API 호출 실패 시 Optimistic Update를 롤백하는 로직 추가 필요 (이전 상태로 복구)
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
    final isEditing = widget.incomeId != null;

    return PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: colorScheme.surface,
          appBar: AppBar(
            title: Text(
              isEditing ? '수입 수정' : '수입 등록',
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
                                    final itemWidth =
                                        (constraints.maxWidth - 24) / 3;
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
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              onTap: () {
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();
                                                setState(() {
                                                  _selectedSource = source.code;
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
                                                      ? source.color
                                                          .withOpacity(0.12)
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
                                                                .withOpacity(
                                                                    0.12),
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
                                                      textAlign:
                                                          TextAlign.center,
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
                      label: isEditing ? '수정하기' : '등록하기',
                      onPressed: _handleSubmit,
                    ),
                  ],
                ),
        ));
  }
}
