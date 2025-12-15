import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:moneyflow/core/constants/app_constants.dart';
import 'package:moneyflow/presentation/widgets/home/custom_calendar.dart';
import 'package:moneyflow/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:moneyflow/features/auth/presentation/screens/login_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  DateTime _selectedDate = DateTime.now();

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
      body: Column(
        children: [
          // 1. Budget Info Area
          _buildBudgetInfo(),

          // 2. Custom Calendar
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: CustomCalendar(
              onDateSelected: (selected, focused) {
                setState(() {
                  _selectedDate = selected;
                });
              },
            ),
          ),

          const Divider(height: 1, color: AppColors.border),

          // 3. Transaction List Area
          Expanded(
            child: _buildTransactionList(),
          ),
        ],
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

  Widget _buildTransactionList() {
    // Dummy transactions based on date (for demo, just scramble a bit or static)
    // We will show "No transactions" if date is odd, else show some.
    // Randomize a bit based on date day to make it feel alive.
    final day = _selectedDate.day;
    final hasData = day % 2 != 0; // Show data on odd days

    if (!hasData) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined,
                size: 48, color: AppColors.gray300),
            const SizedBox(height: 16),
            Text(
              '${_selectedDate.month}월 ${_selectedDate.day}일 내역이 없습니다.',
              style: const TextStyle(color: AppColors.textTertiary),
            ),
          ],
        ),
      );
    }

    final transactions = [
      {'title': '스타벅스 강남점', 'amount': -4500, 'time': '12:30', 'category': '카페'},
      {
        'title': 'GS25 편의점',
        'amount': -12000,
        'time': '18:45',
        'category': '식비'
      },
      {'title': '월급', 'amount': 3000000, 'time': '09:00', 'category': '급여'},
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsetsGeometry.fromLTRB(20, 12, 20, 0),
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
                  '전체 -${NumberFormat('#,###').format(16500)}원', // Dummy sum
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
        Expanded(
          child: ListView.builder(
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
        ),
      ],
    );
  }
}
