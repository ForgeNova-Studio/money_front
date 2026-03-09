import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/core/constants/expense_categories.dart';
import 'package:moamoa/features/expense/presentation/utils/expense_category_utils.dart';
import 'package:moamoa/features/common/widgets/transaction_form/transaction_form_styles.dart';
import '../../domain/entities/pending_receipt.dart';

/// OCR 스캔된 영수증 항목 위젯
class PendingReceiptListItem extends StatefulWidget {
  final PendingReceipt receipt;
  final ValueChanged<int>? onAmountChanged;
  final ValueChanged<DateTime>? onDateChanged;
  final ValueChanged<String?>? onCategoryChanged;
  final ValueChanged<String>? onMemoChanged;
  final ValueChanged<String>? onMerchantChanged;
  final VoidCallback? onDelete;

  const PendingReceiptListItem({
    super.key,
    required this.receipt,
    this.onAmountChanged,
    this.onDateChanged,
    this.onCategoryChanged,
    this.onMemoChanged,
    this.onMerchantChanged,
    this.onDelete,
  });

  @override
  State<PendingReceiptListItem> createState() => _PendingReceiptListItemState();
}

class _PendingReceiptListItemState extends State<PendingReceiptListItem> {
  late TextEditingController _amountController;
  late TextEditingController _memoController;
  late TextEditingController _merchantController;
  bool _isExpanded = false;
  final _numberFormat = NumberFormat('#,###');

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: _numberFormat.format(widget.receipt.amount),
    );
    _memoController = TextEditingController(text: widget.receipt.memo ?? '');
    _merchantController = TextEditingController(text: widget.receipt.merchant);
  }

  @override
  void didUpdateWidget(PendingReceiptListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.receipt.amount != widget.receipt.amount) {
      _amountController.text = _numberFormat.format(widget.receipt.amount);
    }
    if (oldWidget.receipt.memo != widget.receipt.memo) {
      _memoController.text = widget.receipt.memo ?? '';
    }
    if (oldWidget.receipt.merchant != widget.receipt.merchant) {
      _merchantController.text = widget.receipt.merchant;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _memoController.dispose();
    _merchantController.dispose();
    super.dispose();
  }

  Color _categoryColor(String hexColor) {
    final value = int.parse(hexColor, radix: 16);
    return Color(0xFF000000 | value);
  }

  void _onAmountSubmitted(String value) {
    final cleanValue = value.replaceAll(',', '').replaceAll(' ', '');
    final amount = int.tryParse(cleanValue);
    if (amount != null && amount > 0) {
      widget.onAmountChanged?.call(amount);
    } else {
      // 잘못된 입력 시 원래 값으로 복원
      _amountController.text = _numberFormat.format(widget.receipt.amount);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: widget.receipt.date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      locale: const Locale('ko', 'KR'),
    );
    if (picked != null) {
      widget.onDateChanged?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('M/d (E)', 'ko');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: transactionFormCardDecoration(context),
      child: Column(
        children: [
          // 메인 정보 영역
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // 카테고리 아이콘
                  _buildCategoryIcon(),
                  const SizedBox(width: 12),

                  // 가맹점 + 날짜
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.receipt.merchant,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: context.appColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dateFormat.format(widget.receipt.date),
                          style: TextStyle(
                            fontSize: 13,
                            color: context.appColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 금액
                  Text(
                    '${_numberFormat.format(widget.receipt.amount)}원',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: context.appColors.expense,
                    ),
                  ),

                  // 확장 화살표
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: context.appColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 확장 영역
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildExpandedContent(context),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon() {
    final category = widget.receipt.category;
    final categoryData = category != null
        ? DefaultExpenseCategories.all.firstWhere(
            (c) => c.id == category,
            orElse: () => DefaultExpenseCategories.all.last,
          )
        : DefaultExpenseCategories.all.last; // 기타

    final color = _categoryColor(categoryData.color);

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        shape: BoxShape.circle,
      ),
      child: Icon(
        expenseIconFromName(categoryData.icon),
        color: color,
        size: 22,
      ),
    );
  }

  Widget _buildExpandedContent(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: context.appColors.divider),
          const SizedBox(height: 12),

          // 금액 수정
          _buildLabeledField(
            context,
            label: '금액',
            child: TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _ThousandsSeparatorInputFormatter(),
              ],
              decoration: _inputDecoration(context, '금액을 입력하세요'),
              style: TextStyle(
                fontSize: 14,
                color: context.appColors.textPrimary,
              ),
              onSubmitted: _onAmountSubmitted,
              onTapOutside: (_) {
                FocusScope.of(context).unfocus();
                _onAmountSubmitted(_amountController.text);
              },
            ),
          ),
          const SizedBox(height: 16),

          // 날짜 수정
          _buildLabeledField(
            context,
            label: '날짜',
            child: InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: context.appColors.backgroundGray,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(
                      DateFormat('yyyy년 M월 d일 (E)', 'ko')
                          .format(widget.receipt.date),
                      style: TextStyle(
                        fontSize: 14,
                        color: context.appColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: context.appColors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 가맹점명 수정
          _buildLabeledField(
            context,
            label: '가게명',
            child: TextField(
              controller: _merchantController,
              decoration: _inputDecoration(context, '가게명을 입력하세요'),
              style: TextStyle(
                fontSize: 14,
                color: context.appColors.textPrimary,
              ),
              onChanged: widget.onMerchantChanged,
            ),
          ),
          const SizedBox(height: 16),

          // 카테고리 선택
          _buildLabeledField(
            context,
            label: '카테고리',
            child: _buildCategoryChips(context),
          ),
          const SizedBox(height: 16),

          // 메모 입력
          _buildLabeledField(
            context,
            label: '메모',
            child: TextField(
              controller: _memoController,
              decoration: _inputDecoration(context, '메모를 입력하세요'),
              style: TextStyle(
                fontSize: 14,
                color: context.appColors.textPrimary,
              ),
              onChanged: widget.onMemoChanged,
            ),
          ),
          const SizedBox(height: 16),

          // 삭제 버튼
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: widget.onDelete,
              icon: Icon(
                Icons.delete_outline,
                size: 18,
                color: context.appColors.error,
              ),
              label: Text(
                '이 항목 삭제',
                style: TextStyle(color: context.appColors.error),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                side: BorderSide(
                    color: context.appColors.error.withValues(alpha: 0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabeledField(BuildContext context,
      {required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: context.appColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: context.appColors.textTertiary),
      filled: true,
      fillColor: context.appColors.backgroundGray,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    );
  }

  Widget _buildCategoryChips(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: DefaultExpenseCategories.all.map((category) {
        final isSelected = widget.receipt.category == category.id;
        final color = _categoryColor(category.color);

        return GestureDetector(
          onTap: () {
            widget.onCategoryChanged?.call(category.id);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withValues(alpha: 0.15)
                  : context.appColors.backgroundGray,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? color : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  expenseIconFromName(category.icon),
                  size: 16,
                  color: isSelected ? color : context.appColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? color : context.appColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// 천 단위 구분자 포맷터
class _ThousandsSeparatorInputFormatter extends TextInputFormatter {
  final _numberFormat = NumberFormat('#,###');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final cleanText = newValue.text.replaceAll(',', '');
    final number = int.tryParse(cleanText);

    if (number == null) {
      return oldValue;
    }

    final formattedText = _numberFormat.format(number);

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
