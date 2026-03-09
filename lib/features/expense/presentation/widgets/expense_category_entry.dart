import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/core/constants/expense_categories.dart';
import 'package:moamoa/features/common/widgets/transaction_form/transaction_form_styles.dart';
import 'package:moamoa/features/expense/presentation/utils/expense_category_utils.dart';

/// 지출 카테고리 항목 위젯
///
/// 그리드 내에서 개별 지출 카테고리를 표시하는 버튼 역할을 합니다.
/// 선택 여부에 따라 배경색과 텍스트 색상이 변경됩니다.
///
/// **주요 기능:**
/// - 카테고리 아이콘 및 이름 표시
/// - 선택 상태에 따른 시각적 피드백 (색상 반전 등)
/// - 터치 시 포커스 해제 및 콜백 실행
///
/// **주요 파라미터:**
/// - [category]: 표시할 카테고리 정보 ([ExpenseCategory])
/// - [color]: 카테고리 고유 테마 색상
/// - [isSelected]: 현재 선택 여부
/// - [onTap]: 항목 선택 시 호출되는 콜백
///
/// **사용 예시:**
/// ```dart
/// ExpenseCategoryEntry(
///   category: expenseCategory,
///   color: Colors.blue,
///   isSelected: true,
///   onTap: () => print('Category tapped'),
/// );
/// ```
class ExpenseCategoryEntry extends StatelessWidget {
  final ExpenseCategory category;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const ExpenseCategoryEntry({
    super.key,
    required this.category,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: transactionFormCardDecoration(
            context,
            backgroundColor:
                isSelected ? color.withValues(alpha: 0.12) : Colors.white,
          ),
          child: Column(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isSelected ? color : color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  expenseIconFromName(category.icon),
                  color: isSelected ? Colors.white : color,
                  size: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                category.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? color : context.appColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
