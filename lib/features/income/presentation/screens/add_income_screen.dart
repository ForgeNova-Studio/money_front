// packages
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// core
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/common/widgets/transaction_form/amount_input_card.dart';
import 'package:moamoa/features/common/widgets/transaction_form/date_picker_card.dart';
import 'package:moamoa/features/common/widgets/transaction_form/form_submit_button.dart';
import 'package:moamoa/features/common/widgets/retryable_load_error_state.dart';
import 'package:moamoa/features/common/widgets/transaction_form/transaction_form_card.dart';
import 'package:moamoa/features/common/widgets/transaction_form/transaction_text_field.dart';
import 'package:moamoa/features/common/widgets/default_layout.dart';
import 'package:moamoa/features/income/presentation/widgets/income_source_grid.dart';
import 'package:moamoa/core/constants/income_categories.dart'; // Added import

// features
import 'package:moamoa/features/income/presentation/viewmodels/income_view_model.dart';
import 'package:moamoa/core/utils/toast_utils.dart';

// entities
import 'package:moamoa/features/income/domain/entities/income.dart';

/// 수입 등록/수정 화면
///
/// 수입 금액, 날짜, 카테고리, 메모를 입력받아 수입을 등록하거나 수정합니다.
/// [incomeId]가 전달되면 수정 모드로 동작하며, 기존 데이터를 불러와 폼에 채웁니다.
///
/// **주요 기능:**
/// - 금액 입력 (콤마 포맷팅, 최대 12자리)
/// - 날짜 선택 (DatePicker)
/// - 수입 카테고리 선택 (IncomeSourceGrid)
/// - 메모 입력
/// - IncomeViewModel을 통한 등록/수정 처리 및 Optimistic Update
///
/// **주요 파라미터:**
/// - [initialDate]: 홈 화면에서 선택된 날짜 (기본값: 오늘)
/// - [incomeId]: 수정할 수입의 ID (null이면 신규 등록)
///
/// **사용 예시:**
/// ```dart
/// // 신규 등록
/// AddIncomeScreen(initialDate: DateTime.now());
///
/// // 수정
/// AddIncomeScreen(incomeId: 'abc123');
/// ```
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

/// [AddIncomeScreen]의 상태 관리 클래스
///
/// 폼 컨트롤러, 날짜/카테고리 선택 상태를 관리하며,
/// 비즈니스 로직은 [IncomeViewModel]에 위임합니다.
///
/// **주요 책임:**
/// - UI 상태 관리 (폼 컨트롤러, 포커스 노드, 날짜/카테고리 선택)
/// - 수정 모드 시 기존 데이터 로드 및 폼 초기화 ([_loadIncome])
/// - 금액 유효성 검사 ([_validateAmount])
/// - 날짜 선택 다이얼로그 표시 ([_selectDate])
/// - 폼 제출 시 ViewModel 호출 및 결과 피드백 ([_handleSubmit])
class _AddIncomeScreenState extends ConsumerState<AddIncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _amountFocusNode = FocusNode();
  final _amountFormatter = NumberFormat('#,###');

  late DateTime _selectedDate;
  String _selectedSource = IncomeCategoryCode.salary;
  Income? _originalIncome;
  bool _isLoading = false;
  bool _isSubmitting = false;
  String? _loadErrorMessage;

  @override
  void initState() {
    super.initState();

    // 홈에서 선택된 날짜가 있다면 선택됨
    _selectedDate = widget.initialDate ?? DateTime.now();
    if (widget.incomeId != null) {
      _isLoading = true;
      Future.microtask(_loadIncome);
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
    _descriptionController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

  /// 수정일 경우, 수입 정보를 가져옴
  Future<void> _loadIncome() async {
    final incomeId = widget.incomeId;
    if (incomeId == null) return;

    try {
      final income = await ref
          .read(incomeViewModelProvider.notifier)
          .getIncomeDetail(incomeId);

      if (!mounted) return;
      setState(() {
        _originalIncome = income;
        _selectedDate = income.date;
        _selectedSource = income.source;
        _amountController.text = _amountFormatter.format(income.amount);
        _descriptionController.text = income.description ?? '';
        _isLoading = false;
        _loadErrorMessage = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _loadErrorMessage = '수입 정보를 불러오지 못했습니다';
      });
      context.showErrorToast('수입 정보를 불러오지 못했습니다. 다시 시도해주세요');
    }
  }

  Future<void> _retryLoadIncome() async {
    setState(() {
      _isLoading = true;
      _loadErrorMessage = null;
    });
    await _loadIncome();
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
      context.showErrorToast('금액을 입력하세요');
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
    if (_isSubmitting) return;
    if (widget.incomeId != null && _originalIncome == null) {
      context.showErrorToast('수정할 수입 정보를 먼저 불러와 주세요');
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSubmitting = true);

    final amount = int.parse(_amountController.text.replaceAll(',', ''));
    final description = _descriptionController.text.trim().isEmpty
        ? null
        : _descriptionController.text.trim();

    try {
      await ref.read(incomeViewModelProvider.notifier).submitIncome(
            amount: amount,
            date: _selectedDate,
            source: _selectedSource,
            description: description,
            incomeId: widget.incomeId,
            existingIncome: _originalIncome,
          );

      if (mounted) {
        context
            .showToast(widget.incomeId == null ? '수입이 등록되었습니다' : '수입이 수정되었습니다');
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        context.showErrorToast(
          widget.incomeId == null ? '수입 등록에 실패했습니다' : '수입 수정에 실패했습니다',
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
    // Provider를 watch하여 화면이 살아있는 동안 Provider가 dispose되지 않도록 함
    ref.watch(incomeViewModelProvider);
    final isEditing = widget.incomeId != null;

    return DefaultLayout(
      title: isEditing ? '수입 수정' : '수입 등록',
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
                  onRetry: _retryLoadIncome,
                  onClose: () => Navigator.of(context).pop(),
                )
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
                                const SizedBox(height: 20),

                                // 1. 금액 입력 필드
                                AmountInputCard(
                                  controller: _amountController,
                                  focusNode: _amountFocusNode,
                                  validator: _validateAmount,
                                  amountColor: context.appColors.primary,
                                  unitColor: context.appColors.textPrimary,
                                  maxDigits: 12, // 입력 허용 최대 자릿수
                                ),

                                const SizedBox(height: 24),

                                // 2. 날짜 선택 필드
                                DatePickerCard(
                                  selectedDate: _selectedDate,
                                  onTap: () => _selectDate(context),
                                ),

                                const SizedBox(height: 28),

                                // 3. 메모 필드
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

                                const SizedBox(height: 28),

                                // 4. 카테고리 그리드
                                IncomeSourceGrid(
                                  selectedSourceCode: _selectedSource,
                                  onSourceSelected: (code) {
                                    setState(() {
                                      _selectedSource = code;
                                    });
                                  },
                                ),
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
                      onPressed: _isSubmitting ? null : _handleSubmit,
                    ),
                  ],
                )),
    );
  }
}
