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
import 'package:moneyflow/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:moneyflow/features/auth/presentation/screens/login_screen.dart';
import 'package:moneyflow/features/home/presentation/widgets/custom_calendar.dart';
import 'package:moneyflow/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:moneyflow/features/home/domain/entities/transaction_entity.dart';
import 'package:moneyflow/core/utils/format_utils.dart'; // Add this

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  CalendarFormat _calendarFormat = CalendarFormat.month;

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
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);
    final viewModel = ref.read(homeViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text(
          'MoneyFlow',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        actions: [
          // OCR 테스트 버튼
          IconButton(
            icon: const Icon(Icons.document_scanner,
                color: AppColors.textPrimary),
            onPressed: () => context.push(RouteNames.ocrTest),
            tooltip: 'OCR 테스트',
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textSecondary),
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
              format: _calendarFormat,
              focusedDay: homeState.focusedMonth,
              selectedDay: homeState.selectedDate,
              onFormatChanged: (format) {
                debugPrint('onFormatchanged');
                setState(() {
                  _calendarFormat = format;
                });
              },
              onDateSelected: (selected, focused) {
                debugPrint('onDateSelected');
                viewModel.selectDate(selected);
                setState(() {
                  _calendarFormat = CalendarFormat.week;
                });
              },
              onPageChanged: (focused) {
                debugPrint('onPageChanged');
                viewModel.changeMonth(focused);
              },
              dayBottomBuilder: (context, day) {
                return homeState.monthlyData.when(
                  data: (data) {
                    final dateKey = DateFormat('yyyy-MM-dd').format(day);
                    final summary = data[dateKey];
                    if (summary == null) return const SizedBox.shrink();

                    final hasIncome = summary.totalIncome > 0;
                    final hasExpense = summary.totalExpense > 0;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (hasIncome)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 1.0),
                            child: Text(
                              '+${formatMoneyCompact(summary.totalIncome)}',
                              style: const TextStyle(
                                color: AppColors.success,
                                fontSize: 9, // Minimum size 9pt
                                fontWeight: FontWeight.w500,
                                letterSpacing: -0.5, // Tight spacing
                                height: 1.0,
                              ),
                            ),
                          ),
                        if (hasExpense)
                          Text(
                            '-${formatMoneyCompact(summary.totalExpense)}',
                            style: const TextStyle(
                              color: AppColors.error,
                              fontSize: 9, // Minimum size 9pt
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.5, // Tight spacing
                              height: 1.0,
                            ),
                          ),
                      ],
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                );
              },
            ),
          ),

          // 3. Transactions Sheet (Fills remaining space)
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 1),
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
              child: _calendarFormat == CalendarFormat.week
                  ? NotificationListener<DraggableScrollableNotification>(
                      key: const ValueKey('modal'),
                      onNotification: (notification) {
                        if (notification.extent <= 0.05) {
                          setState(() {
                            _calendarFormat = CalendarFormat.month;
                          });
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
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
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
                              child: _buildTransactionList(isModal: true),
                            ),
                          );
                        },
                      ),
                    )
                  : const SizedBox.shrink(key: ValueKey('empty')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            _showAddTransactionModal(context, homeState.selectedDate),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.gray400,
        backgroundColor: Colors.white,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            label: '분석',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: '자산',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: '더보기',
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetInfo() {
    // Dummy Data
    final totalBudget = 500000;
    final usedAmount = 200000;
    final remainingAmount = totalBudget - usedAmount;
    final progress = usedAmount / totalBudget;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  size: 14, color: AppColors.gray400),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${NumberFormat('#,###').format(remainingAmount)}원 남음',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.gray100,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '지출 ${NumberFormat('#,###').format(usedAmount)}원',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textTertiary),
              ),
              Text(
                '예산 ${NumberFormat('#,###').format(totalBudget)}원',
                style: const TextStyle(
                    fontSize: 12, color: AppColors.textTertiary),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTransactionList({bool isModal = false}) {
    final homeState = ref.watch(homeViewModelProvider);
    final selectedDate = homeState.selectedDate;

    return homeState.monthlyData.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(32.0),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(child: Text('데이터를 불러오는데 실패했습니다.')),
      ),
      data: (data) {
        final dateKey = DateFormat('yyyy-MM-dd').format(selectedDate);
        final summary = data[dateKey];
        final transactions = summary?.transactions ?? [];
        final totalAmount =
            (summary?.totalIncome ?? 0) - (summary?.totalExpense ?? 0);
        final hasData = transactions.isNotEmpty;

        return Column(
          children: [
            if (!isModal) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${selectedDate.month}월 ${selectedDate.day}일',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.gray100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '전체 ${NumberFormat('#,###').format(totalAmount)}원',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Modal Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${selectedDate.month}월 ${selectedDate.day}일 (${[
                                '월',
                                '화',
                                '수',
                                '목',
                                '금',
                                '토',
                                '일'
                              ][selectedDate.weekday - 1]})',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${totalAmount < 0 ? '-' : ''}${NumberFormat('#,###').format(totalAmount.abs())}원',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            // TODO: Navigate to OCR screen
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: AppColors.primaryPinkLight,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              color: AppColors.primaryPinkLight,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            if (!hasData)
              Container(
                height: 200,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.receipt_long_outlined,
                        size: 48, color: AppColors.gray300),
                    const SizedBox(height: 16),
                    Text(
                      '${selectedDate.month}월 ${selectedDate.day}일 내역이 없습니다.',
                      style: const TextStyle(color: AppColors.textTertiary),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final tx = transactions[index];
                  final isExpense = tx.type == TransactionType.expense;
                  // 지출은 검정색(기본), 수입은 초록색/파란색 등으로 표시
                  final color = isExpense ? AppColors.error : AppColors.success;
                  final prefix = isExpense ? '-' : '+';
                  final amountStr = NumberFormat('#,###').format(tx.amount);
                  final timeStr = DateFormat('HH:mm').format(tx.date);

                  return InkWell(
                    onTap: () {
                      // TODO: Show transaction details modal
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 6),
                      child: Row(
                        children: [
                          // Leading Icon
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.gray50,
                            child: Icon(
                              isExpense ? Icons.coffee : Icons.attach_money,
                              color: isExpense
                                  ? AppColors.textSecondary
                                  : AppColors.success,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Title & Subtitle
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tx.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '$timeStr · ${tx.category}',
                                  style: const TextStyle(
                                      color: AppColors.textTertiary,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          // Trailing Amount
                          Text(
                            '$prefix$amountStr원',
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ],
        );
      },
    );
  }
}

void _showAddTransactionModal(BuildContext context, DateTime selectedDate) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '내역 추가',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    context.push(RouteNames.addIncome, extra: selectedDate);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.arrow_downward,
                            color: AppColors.success, size: 32),
                        SizedBox(height: 8),
                        Text(
                          '입금',
                          style: TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    context.push(RouteNames.addExpense, extra: selectedDate);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.arrow_upward,
                            color: AppColors.error, size: 32),
                        SizedBox(height: 8),
                        Text(
                          '지출',
                          style: TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    ),
  );
}
