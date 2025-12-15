import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:moneyflow/core/constants/app_constants.dart';
import 'package:moneyflow/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:moneyflow/features/auth/presentation/screens/login_screen.dart';
import 'package:moneyflow/features/home/presentation/widgets/custom_calendar_2.dart';
import 'package:moneyflow/features/home/presentation/widgets/custom_month_picker.dart'; // Import if needed for TableCalendar internals or types
import 'package:table_calendar/table_calendar.dart'; // Import for CalendarFormat

class HomeScreen2 extends ConsumerStatefulWidget {
  const HomeScreen2({super.key});

  @override
  ConsumerState<HomeScreen2> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen2> {
  int _selectedIndex = 0;
  DateTime _selectedDate = DateTime.now();
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
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textSecondary),
            onPressed: _handleLogout,
            tooltip: '로그아웃',
          ),
        ],
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Estimate header height (Budget + Week Calendar)
          // Budget ~150 + Padding ~16 + WeekCalendar ~150 = ~316
          const double estimatedHeaderHeight = 320.0;
          final double bodyHeight = constraints.maxHeight;

          // Calculate fraction
          double initialSheetSize =
              (bodyHeight - estimatedHeaderHeight) / bodyHeight;
          // Clamp for safety
          if (initialSheetSize < 0.2) initialSheetSize = 0.2;
          if (initialSheetSize > 0.8) initialSheetSize = 0.8;

          return Stack(
            children: [
              // Layer 1: Main Content (Budget + Calendar)
              Column(
                children: [
                  // 1. Budget Info Area
                  _buildBudgetInfo(),

                  // 2. Custom Calendar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: CustomCalendar(
                      format: _calendarFormat,
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      },
                      onDateSelected: (selected, focused) {
                        setState(() {
                          _selectedDate = selected;
                          _calendarFormat = CalendarFormat.week;
                        });
                        // Modal shows automatically via Stack + State
                      },
                    ),
                  ),
                ],
              ),

              // Layer 2: Draggable Sheet (Transactions)
              Positioned.fill(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
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
                            initialChildSize: initialSheetSize,
                            minChildSize: 0.0,
                            maxChildSize: initialSheetSize,
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
          );
        },
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
    // Dummy transactions based on date
    final day = _selectedDate.day;
    final hasData = day % 2 != 0; // Show data on odd days

    final transactions = hasData
        ? [
            {
              'title': '스타벅스 강남점',
              'amount': -4500,
              'time': '12:30',
              'category': '카페'
            },
            {
              'title': 'GS25 편의점',
              'amount': -12000,
              'time': '18:45',
              'category': '식비'
            },
            {
              'title': '월급',
              'amount': 3000000,
              'time': '09:00',
              'category': '급여'
            },
          ]
        : [];

    final totalAmount = hasData
        ? -16500 // Dummy sum for demo
        : 0;

    return Column(
      children: [
        if (!isModal) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_selectedDate.month}월 ${_selectedDate.day}일',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                          '${_selectedDate.month}월 ${_selectedDate.day}일 (${[
                            '월',
                            '화',
                            '수',
                            '목',
                            '금',
                            '토',
                            '일'
                          ][_selectedDate.weekday - 1]})',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${totalAmount == 0 ? '' : '-'}${NumberFormat('#,###').format(totalAmount.abs())}원',
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
        // Since SingleChildScrollView is already in the DraggableScrollableSheet builder,
        // we should just return the list items here?
        // Actually, ListView.builder inside SingleChildScrollView is bad.
        // We should just use ListView.builder with shrinkWrap true and physics NeverScrollable
        // OR let the caller handle scrolling.
        // For DraggableScrollableSheet, the child should usually be the scrollable.
        // In the builder above: `_buildTransactionList(isModal: true)`.
        // Let's adjust this method to return a list of widgets or handle scrolling properly.
        // But for minimal diff, let's keep ListView inside Expanded but change how it's called.
        // Wait, DraggableScrollableSheet gives a controller. We passed it to SingleChildScrollView.
        // So inside here we should not use Expanded/ListView if we want that outer scroll to work?
        // Actually, best practice for DraggableScrollableSheet is to use the controller on a ListView.
        // So let's refactor _buildTransactionList slightly to accept a controller?
        // Or changing the caller side.
        // To avoid big refactor of _buildTransactionList signature now, let's look at it.
        // It returns a Column with Expanded(ListView).
        // This won't work well inside SingleChildScrollView.
        // Detailed fix below.
        if (!hasData)
          Container(
            height:
                200, // Give it a fixed height or use Expanded within a Column
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.receipt_long_outlined,
                    size: 48, color: AppColors.gray300),
                const SizedBox(height: 16),
                Text(
                  '${_selectedDate.month}월 ${_selectedDate.day}일 내역이 없습니다.',
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
              final amount = tx['amount'] as int;
              final isExpense = amount < 0;
              final color =
                  isExpense ? AppColors.textPrimary : AppColors.success;
              final amountStr = NumberFormat('#,###').format(amount);

              return InkWell(
                onTap: () {
                  // TODO: Show transaction details modal
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
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
                              tx['title'] as String,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${tx['time']} · ${tx['category']}',
                              style: const TextStyle(
                                  color: AppColors.textTertiary, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      // Trailing Amount
                      Text(
                        '$amountStr원',
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
  }
}
