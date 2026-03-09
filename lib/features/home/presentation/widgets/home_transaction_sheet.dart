import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:moamoa/features/home/domain/entities/transaction_entity.dart';
import 'package:moamoa/features/home/presentation/states/home_state.dart';
import 'package:moamoa/features/home/presentation/widgets/transaction_list_section.dart';

/// 주간 캘린더 뷰에서 표시되는 드래그 가능한 거래 내역 시트
///
/// 캘린더가 주간 뷰([CalendarFormat.week])일 때 화면 하단에서 슬라이드 업되어
/// 선택된 날짜의 거래 내역을 모달 형태로 표시합니다.
///
/// 주요 기능:
/// - 슬라이드 업 애니메이션으로 등장
/// - 드래그하여 아래로 내리면 월간 뷰로 복귀
/// - 거래 내역 스와이프 삭제 지원
///
/// 파라미터:
/// - [homeState]: 홈 화면 상태 (캘린더 형식, 선택 날짜, 월간 데이터 포함)
/// - [onDelete]: 거래 삭제 콜백 (true 반환 시 삭제, false 시 스와이프 원복)
/// - [onResetToMonthView]: 시트가 완전히 닫힐 때 월간 뷰로 복귀하는 콜백
/// - [onRevealActiveChanged]: 스와이프 상태 변경 콜백 (선택)
///
/// 사용 예시:
/// ```dart
/// HomeTransactionSheet(
///   homeState: homeState,
///   onDelete: (tx) async => await handleDelete(tx),
///   onResetToMonthView: () => resetToMonthView(),
///   onRevealActiveChanged: (active) => handleRevealChange(active),
/// )
/// ```
class HomeTransactionSheet extends StatelessWidget {
  final HomeState homeState;
  final Future<bool> Function(TransactionEntity transaction) onDelete;
  final VoidCallback onResetToMonthView;
  final ValueChanged<bool>? onRevealActiveChanged;

  const HomeTransactionSheet({
    super.key,
    required this.homeState,
    required this.onDelete,
    required this.onResetToMonthView,
    this.onRevealActiveChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) {
        final offsetAnimation = Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ));
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      child: homeState.calendarFormat == CalendarFormat.week
          ? NotificationListener<DraggableScrollableNotification>(
              key: const ValueKey('modal'),
              onNotification: (notification) {
                if (notification.extent <= 0.05) {
                  onResetToMonthView();
                }
                return true;
              },
              child: DraggableScrollableSheet(
                initialChildSize: 1.0,
                minChildSize: 0.0,
                maxChildSize: 1.0,
                snap: true,
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.12),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.only(top: 16),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: TransactionListSection(
                        monthlyData: homeState.monthlyData,
                        selectedDate: homeState.selectedDate,
                        isModal: true,
                        onDelete: onDelete,
                        onRevealActiveChanged: onRevealActiveChanged,
                      ),
                    ),
                  );
                },
              ),
            )
          : const SizedBox.shrink(key: ValueKey('empty')),
    );
  }
}
