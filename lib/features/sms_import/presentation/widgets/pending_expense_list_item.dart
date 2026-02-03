import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/core/constants/expense_categories.dart';
import 'package:moamoa/features/expense/presentation/utils/expense_category_utils.dart';
import 'package:moamoa/features/common/widgets/transaction_form/transaction_form_styles.dart';
import 'package:moamoa/features/sms_import/domain/entities/pending_expense.dart';

/// 대기 중인 지출 항목 위젯
class PendingExpenseListItem extends StatefulWidget {
  final PendingExpense expense;
  final ValueChanged<String?>? onCategoryChanged;
  final ValueChanged<String>? onMemoChanged;
  final ValueChanged<String>? onMerchantChanged;
  final VoidCallback? onDelete;

  const PendingExpenseListItem({
    super.key,
    required this.expense,
    this.onCategoryChanged,
    this.onMemoChanged,
    this.onMerchantChanged,
    this.onDelete,
  });

  @override
  State<PendingExpenseListItem> createState() => _PendingExpenseListItemState();
}

class _PendingExpenseListItemState extends State<PendingExpenseListItem> {
  late TextEditingController _memoController;
  late TextEditingController _merchantController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _memoController = TextEditingController(text: widget.expense.memo ?? '');
    _merchantController = TextEditingController(text: widget.expense.merchant);
  }

  @override
  void didUpdateWidget(PendingExpenseListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.expense.memo != widget.expense.memo) {
      _memoController.text = widget.expense.memo ?? '';
    }
    if (oldWidget.expense.merchant != widget.expense.merchant) {
      _merchantController.text = widget.expense.merchant;
    }
  }

  @override
  void dispose() {
    _memoController.dispose();
    _merchantController.dispose();
    super.dispose();
  }

  Color _categoryColor(String hexColor) {
    final value = int.parse(hexColor, radix: 16);
    return Color(0xFF000000 | value);
  }

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat('#,###');
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
                          widget.expense.merchant,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: context.appColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dateFormat.format(widget.expense.date),
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
                    '${numberFormat.format(widget.expense.amount)}원',
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

          // 확장 영역 (카테고리 선택 + 메모 + 삭제)
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _buildExpandedContent(context),
            crossFadeState:
                _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryIcon() {
    final category = widget.expense.category;
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
        color: color.withOpacity(0.12),
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

          // 가맹점명 수정
          Text(
            '가게명',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.appColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _merchantController,
            decoration: InputDecoration(
              hintText: '가게명을 입력하세요',
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
            ),
            style: TextStyle(
              fontSize: 14,
              color: context.appColors.textPrimary,
            ),
            onChanged: widget.onMerchantChanged,
          ),
          const SizedBox(height: 16),

          // 카테고리 선택
          Text(
            '카테고리',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.appColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          _buildCategoryChips(context),
          const SizedBox(height: 16),

          // 메모 입력
          Text(
            '메모',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: context.appColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _memoController,
            decoration: InputDecoration(
              hintText: '메모를 입력하세요',
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
            ),
            style: TextStyle(
              fontSize: 14,
              color: context.appColors.textPrimary,
            ),
            onChanged: widget.onMemoChanged,
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
                side: BorderSide(color: context.appColors.error.withOpacity(0.3)),
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

  Widget _buildCategoryChips(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: DefaultExpenseCategories.all.map((category) {
        final isSelected = widget.expense.category == category.id;
        final color = _categoryColor(category.color);

        return GestureDetector(
          onTap: () {
            widget.onCategoryChanged?.call(category.id);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.15) : context.appColors.backgroundGray,
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
