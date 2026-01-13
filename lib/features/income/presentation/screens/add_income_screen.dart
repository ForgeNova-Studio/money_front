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
  final _amountFocusNode = FocusNode();

  late DateTime _selectedDate;
  String _selectedSource = IncomeSource.salary;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
  }

  List<Map<String, dynamic>> _buildSources(BuildContext context) {
    return [
      {
        'code': IncomeSource.salary,
        'name': '급여',
        'icon': Icons.work,
        'color': context.appColors.income,
      },
      {
        'code': IncomeSource.sideIncome,
        'name': '부수입',
        'icon': Icons.attach_money,
        'color': Color(0xFF2E7D32),
      },
      {
        'code': IncomeSource.bonus,
        'name': '상여금',
        'icon': Icons.card_giftcard,
        'color': Color(0xFFF57C00),
      },
      {
        'code': IncomeSource.investment,
        'name': '투자수익',
        'icon': Icons.trending_up,
        'color': Color(0xFF1565C0),
      },
      {
        'code': IncomeSource.other,
        'name': '기타',
        'icon': Icons.more_horiz,
        'color': Color(0xFF6D4C41),
      },
    ];
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _amountFocusNode.dispose();
    super.dispose();
  }

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
    final colorScheme = Theme.of(context).colorScheme;
    // Provider를 watch하여 화면이 살아있는 동안 Provider가 dispose되지 않도록 함
    ref.watch(incomeViewModelProvider);
    final sources = _buildSources(context);

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
                                              color: context.appColors.primary,
                                            ),
                                            decoration: InputDecoration(
                                              filled: false,
                                              hintText: '0',
                                              hintStyle: TextStyle(
                                                color:
                                                    context.appColors.gray300,
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
                                            color:
                                                context.appColors.textPrimary,
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
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final itemWidth = (constraints.maxWidth - 24) / 3;
                              return Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: sources.map((source) {
                                  final isSelected =
                                      _selectedSource == source['code'];
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
                                            _selectedSource = source['code'];
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 200),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 14),
                                          decoration: _buildCardDecoration(
                                            backgroundColor: isSelected
                                                ? (source['color'] as Color)
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
                                                      ? source['color'] as Color
                                                      : (source['color']
                                                              as Color)
                                                          .withOpacity(0.12),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(
                                                  source['icon'],
                                                  color: isSelected
                                                      ? Colors.white
                                                      : source['color']
                                                          as Color,
                                                  size: 18,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                source['name'],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: isSelected
                                                      ? source['color'] as Color
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

                          // 4. Description Field
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: _buildCardDecoration(),
                            child: _buildCleanTextField(
                              controller: _descriptionController,
                              label: '설명',
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
            keyboardType:
                multiline ? TextInputType.multiline : TextInputType.text,
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
