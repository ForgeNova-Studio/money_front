import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/core/constants/income_sources.dart';
import 'package:moamoa/features/income/presentation/widgets/income_source_item.dart';

class IncomeSourceGrid extends StatelessWidget {
  final String selectedSourceCode;
  final ValueChanged<String> onSourceSelected;

  const IncomeSourceGrid({
    super.key,
    required this.selectedSourceCode,
    required this.onSourceSelected,
  });

  @override
  Widget build(BuildContext context) {
    final sources = buildIncomeSources(context);

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
              children: sources.map((source) {
                return SizedBox(
                  width: itemWidth,
                  child: IncomeSourceEntry(
                    source: source,
                    isSelected: selectedSourceCode == source.code,
                    onTap: () => onSourceSelected(source.code),
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
