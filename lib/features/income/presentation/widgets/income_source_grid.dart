import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/core/constants/income_sources.dart';
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
class IncomeSourceGrid extends StatefulWidget {
  final String selectedSourceCode;
  final ValueChanged<String> onSourceSelected;

  const IncomeSourceGrid({
    super.key,
    required this.selectedSourceCode,
    required this.onSourceSelected,
  });

  @override
  State<IncomeSourceGrid> createState() => _IncomeSourceGridState();
}

/// [IncomeSourceGrid]의 상태 관리 클래스
///
/// `didChangeDependencies`에서 수입 출처 목록을 캐시하여
/// `build` 시마다 재생성하는 것을 방지합니다.
class _IncomeSourceGridState extends State<IncomeSourceGrid> {
  late List<IncomeSourceItem> _sources;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sources = buildIncomeSources(context);
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
              children: _sources.map((source) {
                return SizedBox(
                  width: itemWidth,
                  child: IncomeSourceEntry(
                    source: source,
                    isSelected: widget.selectedSourceCode == source.code,
                    onTap: () => widget.onSourceSelected(source.code),
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
