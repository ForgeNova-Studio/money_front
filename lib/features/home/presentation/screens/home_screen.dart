// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:moneyflow/features/home/presentation/widgets/transaction_modal.dart';
import 'package:table_calendar/table_calendar.dart';

// core
import 'package:moneyflow/core/constants/app_constants.dart';
import 'package:moneyflow/core/router/route_names.dart';

// features
import 'package:moneyflow/features/auth/presentation/viewmodels/auth_view_model.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(homeViewModelProvider.notifier)
          .fetchMonthlyData(DateTime.now());
    });
  }

  Future<void> _handleLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그아웃'),
        content: const Text('정말 로그아웃 하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('로그아웃'),
          ),
        ],
      ),
    );

    if (shouldLogout == true && mounted) {
      try {
        await ref.read(authViewModelProvider.notifier).logout();
        if (mounted) {
          // GoRouter의 redirect 로직이 자동으로 로그인 화면으로 이동시킴
          context.go(RouteNames.login);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('로그아웃 실패: $e')),
          );
        }
      }
    }
  }

  // 수입/지출 추가 모달 열기
  void _showAddTransactionModal(BuildContext context, DateTime selectedDate) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => TransactionModal(selectedDate: selectedDate),
    );
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
          'MoneyFlow',
          style: TextStyle(
            color: context.appColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: context.appColors.backgroundLight,
        elevation: 0,
        actions: [
          // OCR 테스트 버튼
          IconButton(
            icon: Icon(Icons.document_scanner,
                color: context.appColors.textPrimary),
            onPressed: () => context.push(RouteNames.ocrTest),
            tooltip: 'OCR 테스트',
          ),
          IconButton(
            icon: Icon(Icons.logout, color: context.appColors.textSecondary),
            onPressed: _handleLogout,
            tooltip: '로그아웃',
          ),
        ],
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
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
      floatingActionButton: _buildFloatingActionButton(homeState.selectedDate),
    );
  }

  // Calendar Format 변경(월간/주간)
  void _handleFormatChanged(CalendarFormat format) {
    ref.read(homeViewModelProvider.notifier).setCalendarFormat(format);
  }

  // Calendar 날짜 선택
  void _handleDateSelected(DateTime selected, DateTime focused) {
    ref.read(homeViewModelProvider.notifier).selectDate(selected);
  }

  // Calendar 페이지 변경(월/주 변경)
  void _handlePageChanged(DateTime focused) {
    ref.read(homeViewModelProvider.notifier).changeMonth(focused);
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
    return FloatingActionButton(
      onPressed: () => _showAddTransactionModal(context, selectedDate),
      backgroundColor: context.appColors.primary,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}
