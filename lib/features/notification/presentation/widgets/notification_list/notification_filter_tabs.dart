import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/notification/presentation/models/notification_filter_type.dart';

/// 알림 목록 필터 탭 위젯
///
/// 알림 목록 상단에 위치하여 유형별 필터링 기능을 제공합니다.
///
/// ## 주요 기능
/// - 가로 스크롤 가능한 필터 칩 목록 표시
/// - 선택된 필터 시각적 강조 (배경색, 그림자)
/// - 필터 변경 이벤트 처리
///
/// ## 사용 예시
/// ```dart
/// NotificationFilterTabs(
///   selectedType: state.selectedType,
///   onChanged: (type) => viewModel.updateFilter(type),
/// )
/// ```
class NotificationFilterTabs extends StatelessWidget {
  final NotificationFilterType selectedType;
  final ValueChanged<NotificationFilterType> onChanged;

  const NotificationFilterTabs({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final appColors = context.appColors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: NotificationFilterType.values.map((filter) {
            final isSelected = selectedType == filter;
            final typeColor = filter.color(appColors);

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onChanged(filter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? typeColor
                        : typeColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color:
                          typeColor.withValues(alpha: isSelected ? 1.0 : 0.3),
                      width: 1.5,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: typeColor.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    filter.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected ? Colors.white : typeColor,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
