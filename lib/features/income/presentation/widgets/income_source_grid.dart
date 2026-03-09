import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/core/constants/income_categories.dart';
import 'package:moamoa/features/income/presentation/widgets/income_source_entry.dart';

/// 수입 출처 카테고리 그리드 위젯
///
/// [IncomeSourceEntry] 항목들을 3열 그리드로 배치합니다.
/// `LayoutBuilder` + `Wrap`을 사용하여 반응형 레이아웃을 제공합니다.
///
/// **주요 파라미터:**
/// - [selectedSourceCode]: 현재 선택된 카테고리 코드
/// - [onSourceSelected]: 카테고리 선택 시 콜백
///
/// **사용 예시:**
/// ```dart
/// IncomeSourceGrid(
///   selectedSourceCode: 'SALARY',
///   onSourceSelected: (code) => setState(() => _source = code),
/// )
/// ```
class IncomeSourceGrid extends StatelessWidget {
  final String selectedSourceCode;
  final ValueChanged<String> onSourceSelected;

  const IncomeSourceGrid({
    super.key,
    required this.selectedSourceCode,
    required this.onSourceSelected,
  });

  Color _categoryColor(String hexColor) {
    if (hexColor.length == 6) {
      final value = int.parse(hexColor, radix: 16);
      return Color(0xFF000000 | value);
    }
    // Fallback or handle 8 digit hex if needed, but we used 6 digits in constants
    try {
      return Color(
          int.parse(hexColor.replaceFirst('#', ''), radix: 16) + 0xFF000000);
    } catch (_) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              children: DefaultIncomeCategories.all.map((category) {
                return SizedBox(
                  width: itemWidth,
                  child: IncomeSourceEntry(
                    category: category,
                    color: _categoryColor(category.color),
                    isSelected: selectedSourceCode == category.id,
                    onTap: () => onSourceSelected(category.id),
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
