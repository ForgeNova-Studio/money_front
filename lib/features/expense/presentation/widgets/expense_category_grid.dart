import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/core/constants/expense_categories.dart';
import 'package:moamoa/features/expense/presentation/widgets/expense_category_entry.dart';

/// 지출 카테고리 선택 그리드 위젯
///
/// 사용자가 지출 카테고리를 선택할 수 있도록 그리드 형태로 카테고리 목록을 표시합니다.
/// [DefaultExpenseCategories]에 정의된 모든 카테고리를 렌더링합니다.
///
/// **주요 기능:**
/// - '카테고리' 섹션 타이틀 표시
/// - 반응형 그리드 레이아웃 (한 줄에 3개씩 배치)
/// - 각 카테고리 항목([ExpenseCategoryEntry]) 생성 및 상태 전달
///
/// **주요 파라미터:**
/// - [selectedCategoryId]: 현재 선택된 카테고리의 ID
/// - [onCategorySelected]: 카테고리 선택 시 호출되는 콜백 (선택된 ID 전달)
///
/// **사용 예시:**
/// ```dart
/// ExpenseCategoryGrid(
///   selectedCategoryId: 'FOOD',
///   onCategorySelected: (id) {
///     print('Selected category: $id');
///   },
/// );
/// ```
class ExpenseCategoryGrid extends StatelessWidget {
  final String selectedCategoryId;
  final ValueChanged<String> onCategorySelected;

  const ExpenseCategoryGrid({
    super.key,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  Color _categoryColor(String hexColor) {
    final value = int.parse(hexColor, radix: 16);
    return Color(0xFF000000 | value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '카테고리',
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
              children: DefaultExpenseCategories.all.map((category) {
                final color = _categoryColor(category.color);
                return SizedBox(
                  width: itemWidth,
                  child: ExpenseCategoryEntry(
                    category: category,
                    color: color,
                    isSelected: selectedCategoryId == category.id,
                    onTap: () => onCategorySelected(category.id),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
