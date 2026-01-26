import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:moamoa/features/home/domain/entities/transaction_entity.dart';
import 'package:moamoa/features/home/presentation/states/home_state.dart';
import 'package:moamoa/features/home/presentation/widgets/transaction_list_section.dart';

class HomeTransactionSheet extends StatelessWidget {
  final HomeState homeState;
  final Future<void> Function(TransactionEntity transaction) onDelete;
  final VoidCallback onCameraTap;
  final VoidCallback onResetToMonthView;
  final ValueChanged<bool>? onRevealActiveChanged;

  const HomeTransactionSheet({
    super.key,
    required this.homeState,
    required this.onDelete,
    required this.onCameraTap,
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
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, -2),
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
                        onCameraTap: onCameraTap,
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
