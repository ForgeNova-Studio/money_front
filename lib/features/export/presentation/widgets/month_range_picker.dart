import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moamoa/core/constants/app_constants.dart';

/// 시작/종료 월 범위 선택 위젯
class MonthRangePicker extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final ValueChanged<DateTime> onStartChanged;
  final ValueChanged<DateTime> onEndChanged;

  const MonthRangePicker({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartChanged,
    required this.onEndChanged,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Row(
      children: [
        Expanded(
          child: _MonthButton(
            label: DateFormat('yyyy년 M월').format(startDate),
            onTap: () => _showMonthPicker(
              context,
              initialDate: startDate,
              onSelected: onStartChanged,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '~',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: appColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: _MonthButton(
            label: DateFormat('yyyy년 M월').format(endDate),
            onTap: () => _showMonthPicker(
              context,
              initialDate: endDate,
              onSelected: onEndChanged,
            ),
          ),
        ),
      ],
    );
  }

  void _showMonthPicker(
    BuildContext context, {
    required DateTime initialDate,
    required ValueChanged<DateTime> onSelected,
  }) {
    final now = DateTime.now();
    int selectedYear = initialDate.year;
    int selectedMonth = initialDate.month;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final appColors = context.appColors;

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 핸들 바
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: appColors.gray200,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 연도 선택
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: selectedYear > now.year - 5
                              ? () => setSheetState(() => selectedYear--)
                              : null,
                          icon: Icon(Icons.chevron_left_rounded,
                              color: appColors.gray600),
                        ),
                        Text(
                          '$selectedYear년',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: appColors.textPrimary,
                          ),
                        ),
                        IconButton(
                          onPressed: selectedYear < now.year
                              ? () => setSheetState(() => selectedYear++)
                              : null,
                          icon: Icon(Icons.chevron_right_rounded,
                              color: selectedYear < now.year
                                  ? appColors.gray600
                                  : appColors.gray300),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // 월 그리드
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 2.0,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        final month = index + 1;
                        final isFuture = selectedYear == now.year &&
                            month > now.month;
                        final isSelected = month == selectedMonth;

                        return GestureDetector(
                          onTap: isFuture
                              ? null
                              : () {
                                  setSheetState(() => selectedMonth = month);
                                },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? appColors.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? appColors.primary
                                    : appColors.gray100,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '$month월',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isFuture
                                    ? appColors.gray300
                                    : isSelected
                                        ? Colors.white
                                        : appColors.textPrimary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // 확인 버튼
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          onSelected(DateTime(selectedYear, selectedMonth));
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          '선택',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _MonthButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _MonthButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: appColors.gray50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: appColors.gray100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: appColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 20,
              color: appColors.gray400,
            ),
          ],
        ),
      ),
    );
  }
}
