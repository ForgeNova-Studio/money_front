// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

// core
import 'package:moneyflow/core/constants/app_constants.dart';
import 'package:moneyflow/core/router/route_names.dart';

// features

import 'package:moneyflow/features/home/presentation/widgets/custom_calendar.dart';
import 'package:moneyflow/features/home/presentation/widgets/transaction_list_section.dart';
import 'package:moneyflow/features/home/presentation/states/home_state.dart';
import 'package:moneyflow/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:moneyflow/features/home/domain/entities/transaction_entity.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isFabExpanded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeViewModelProvider.notifier).fetchMonthlyData(DateTime.now());
    });
  }

  // 수입/지출 삭제
  Future<void> _handleDeleteTransaction(TransactionEntity transaction) async {
    if (transaction.id.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('삭제할 수 없는 항목입니다.')),
        );
      }
      return;
    }

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('삭제'),
        content: const Text('이 내역을 삭제할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !mounted) {
      return;
    }

    try {
      await ref
          .read(homeViewModelProvider.notifier)
          .deleteTransaction(transaction);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('삭제되었습니다.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('삭제 실패: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);
    final calendarFormat = homeState.calendarFormat;

    return Scaffold(
      backgroundColor: context.appColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          '내 가계부',
          style: TextStyle(
            color: context.appColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (_) => _collapseFabIfNeeded(),
          child: const SizedBox.expand(),
        ),
        backgroundColor: context.appColors.backgroundLight,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _collapseFabIfNeeded(),
        child: Column(
          children: [
            // 1. Budget Info Area
            _buildBudgetInfo(),

            // 2. Custom Calendar
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: CustomCalendar(
                format: calendarFormat,
                focusedDay: homeState.focusedMonth,
                selectedDay: homeState.selectedDate,
                monthlyData: homeState.monthlyData,
                onFormatChanged: _handleFormatChanged,
                onDateSelected: _handleDateSelected,
                onPageChanged: _handlePageChanged,
              ),
            ),

            // 3. Transactions Sheet (Fills remaining space)
            Expanded(child: _buildTransactionSheet(homeState)),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(homeState.selectedDate),
    );
  }

  // Calendar Format 변경(월간/주간)
  void _handleFormatChanged(CalendarFormat format) {
    _collapseFabIfNeeded();
    ref.read(homeViewModelProvider.notifier).setCalendarFormat(format);
  }

  // Calendar 날짜 선택
  void _handleDateSelected(DateTime selected, DateTime focused) {
    _collapseFabIfNeeded();
    ref.read(homeViewModelProvider.notifier).selectDate(selected);
  }

  // Calendar 페이지 변경(월/주 변경)
  void _handlePageChanged(DateTime focused) {
    _collapseFabIfNeeded();
    ref.read(homeViewModelProvider.notifier).changeMonth(focused);
  }

  void _collapseFabIfNeeded() {
    if (_isFabExpanded) {
      setState(() => _isFabExpanded = false);
    }
  }

  Widget _buildTransactionSheet(HomeState homeState) {
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
                  ref.read(homeViewModelProvider.notifier).resetToMonthView();
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
                        onDelete: _handleDeleteTransaction,
                        onCameraTap: () {
                          // TODO: Navigate to OCR screen
                        },
                      ),
                    ),
                  );
                },
              ),
            )
          : SizedBox.shrink(key: ValueKey('empty')),
    );
  }

  Widget _buildBudgetInfo() {
    // Dummy Data
    final totalBudget = 500000;
    final usedAmount = 200000;
    final remainingAmount = totalBudget - usedAmount;
    final progress = usedAmount / totalBudget;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: context.appColors.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${DateTime.now().month}월 예산',
                style: TextStyle(
                  fontSize: 16,
                  color: context.appColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  size: 14, color: context.appColors.gray400),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '${NumberFormat('#,###').format(remainingAmount)}원 남음',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: context.appColors.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: context.appColors.gray100,
              valueColor:
                  AlwaysStoppedAnimation<Color>(context.appColors.primary),
              minHeight: 8,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '지출 ${NumberFormat('#,###').format(usedAmount)}원',
                style: TextStyle(
                    fontSize: 12, color: context.appColors.textTertiary),
              ),
              Text(
                '예산 ${NumberFormat('#,###').format(totalBudget)}원',
                style: TextStyle(
                    fontSize: 12, color: context.appColors.textTertiary),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(DateTime selectedDate) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // 확장된 메뉴
        if (_isFabExpanded) ...[
          SizedBox(
            width: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Material(
                color: context.appColors.gray800,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildFabMenuItem(
                      icon: Icons.arrow_downward,
                      label: '수입',
                      color: Colors.blue,
                      onTap: () {
                        setState(() => _isFabExpanded = false);
                        context.push(RouteNames.addIncome, extra: selectedDate);
                      },
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: context.appColors.gray700,
                    ),
                    _buildFabMenuItem(
                      icon: Icons.arrow_upward,
                      label: '지출',
                      color: Colors.orange,
                      onTap: () {
                        setState(() => _isFabExpanded = false);
                        context.push(RouteNames.addExpense,
                            extra: selectedDate);
                      },
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: context.appColors.gray700,
                    ),
                    _buildFabMenuItem(
                      icon: Icons.document_scanner,
                      label: 'OCR',
                      color: Colors.green,
                      onTap: () {
                        setState(() => _isFabExpanded = false);
                        context.push(RouteNames.ocrTest);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        // 메인 FAB 버튼 (+ 또는 X)
        SizedBox(
          width: 80,
          height: 35,
          child: FloatingActionButton(
            onPressed: () => setState(() => _isFabExpanded = !_isFabExpanded),
            backgroundColor: _isFabExpanded
                ? context.appColors.gray600
                : context.appColors.primary,
            foregroundColor: context.appColors.textWhite,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                _isFabExpanded ? Icons.close : Icons.add,
                key: ValueKey(_isFabExpanded),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFabMenuItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: context.appColors.textWhite,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
