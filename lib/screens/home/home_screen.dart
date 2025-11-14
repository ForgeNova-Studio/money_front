import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../core/constants/color_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/expense_provider.dart';
import '../../providers/couple_provider.dart';
import '../expense/add_expense_screen.dart';
import '../expense/expense_detail_screen.dart';
import '../expense/expense_list_screen.dart';
import '../statistics/statistics_screen.dart';
import '../settings/settings_screen.dart';
import '../couple/couple_invite_screen.dart';
import '../couple/couple_join_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // 최근 지출 내역 및 커플 정보 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpenseProvider>().fetchRecentExpenses();
      context.read<CoupleProvider>().loadCurrentCouple();
    });
  }

  /// 지출 등록 화면으로 이동
  Future<void> _navigateToAddExpense() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
    );

    // 지출이 추가되면 목록 새로고침
    if (result == true && mounted) {
      context.read<ExpenseProvider>().fetchRecentExpenses();
    }
  }

  /// 지출 상세 화면으로 이동
  Future<void> _navigateToDetail(expense) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ExpenseDetailScreen(expense: expense),
      ),
    );

    // 수정 또는 삭제가 완료되면 목록 새로고침
    if (result == true && mounted) {
      context.read<ExpenseProvider>().fetchRecentExpenses();
    }
  }

  /// 지출 목록 화면으로 이동
  /// 전체 지출 내역을 날짜 범위 및 카테고리로 필터링하여 조회
  Future<void> _navigateToExpenseList() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const ExpenseListScreen(),
      ),
    );

    // 목록 화면에서 수정/삭제가 발생하면 홈 화면도 새로고침
    if (result == true && mounted) {
      context.read<ExpenseProvider>().fetchRecentExpenses();
    }
  }

  /// 통계 화면으로 이동
  void _navigateToStatistics() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const StatisticsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('MoneyFlow'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          // 통계 버튼
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: _navigateToStatistics,
            tooltip: '통계',
          ),
          // 설정 버튼
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            tooltip: '설정',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<ExpenseProvider>().fetchRecentExpenses();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 환영 메시지
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '안녕하세요,',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${authProvider.user?.nickname ?? '사용자'}님!',
                          style:
                              Theme.of(context).textTheme.displaySmall?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 32),

                // 커플 연동 안내 카드
                Consumer<CoupleProvider>(
                  builder: (context, coupleProvider, child) {
                    final couple = coupleProvider.couple;
                    final isLinked = couple?.linked ?? false;

                    // 커플이 연동되지 않은 경우에만 안내 카드 표시
                    if (!isLinked && coupleProvider.status != CoupleStatus.loading) {
                      return Column(
                        children: [
                          _buildCoupleMatchingCard(),
                          const SizedBox(height: 24),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                // 최근 지출 내역
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '최근 지출',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextButton(
                      onPressed: _navigateToExpenseList,
                      child: const Text('전체보기'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 지출 목록
                Consumer<ExpenseProvider>(
                  builder: (context, expenseProvider, child) {
                    if (expenseProvider.status == ExpenseStatus.loading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (expenseProvider.recentExpenses.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(
                                Icons.receipt_long,
                                size: 64,
                                color: AppColors.textSecondary.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '아직 지출 내역이 없습니다',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '+ 버튼을 눌러 첫 지출을 등록해보세요',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: expenseProvider.recentExpenses.length,
                      itemBuilder: (context, index) {
                        final expense = expenseProvider.recentExpenses[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          // 지출 항목 클릭 시 상세 화면으로 이동
                          child: InkWell(
                            onTap: () => _navigateToDetail(expense),
                            borderRadius: BorderRadius.circular(12),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              leading: CircleAvatar(
                                backgroundColor:
                                    AppColors.primary.withValues(alpha: 0.1),
                                child: Icon(
                                  _getCategoryIcon(expense.category),
                                  color: AppColors.primary,
                                ),
                              ),
                              title: Text(
                                expense.merchant ?? _getCategoryName(expense.category),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat('yyyy.MM.dd').format(expense.date),
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              trailing: Text(
                                '${NumberFormat('#,###').format(expense.amount)}원',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddExpense,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'FOOD':
        return Icons.restaurant;
      case 'TRANSPORT':
        return Icons.directions_car;
      case 'SHOPPING':
        return Icons.shopping_bag;
      case 'CULTURE':
        return Icons.movie;
      case 'HOUSING':
        return Icons.home;
      case 'MEDICAL':
        return Icons.local_hospital;
      case 'EDUCATION':
        return Icons.school;
      case 'EVENT':
        return Icons.card_giftcard;
      default:
        return Icons.more_horiz;
    }
  }

  String _getCategoryName(String category) {
    switch (category) {
      case 'FOOD':
        return '식비';
      case 'TRANSPORT':
        return '교통';
      case 'SHOPPING':
        return '쇼핑';
      case 'CULTURE':
        return '문화생활';
      case 'HOUSING':
        return '주거/통신';
      case 'MEDICAL':
        return '의료/건강';
      case 'EDUCATION':
        return '교육';
      case 'EVENT':
        return '경조사';
      default:
        return '기타';
    }
  }

  /// 커플 매칭 안내 카드
  Widget _buildCoupleMatchingCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.favorite,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '커플 모드',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '파트너와 함께 가계부를 관리하세요',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const CoupleInviteScreen(),
                        ),
                      );
                      // 커플 연동 후 새로고침
                      if (result == true && mounted) {
                        context.read<CoupleProvider>().loadCurrentCouple();
                      }
                    },
                    icon: const Icon(Icons.person_add, size: 20),
                    label: const Text('초대하기'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: AppColors.primary),
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const CoupleJoinScreen(),
                        ),
                      );
                      // 커플 연동 후 새로고침
                      if (result == true && mounted) {
                        context.read<CoupleProvider>().loadCurrentCouple();
                      }
                    },
                    icon: const Icon(Icons.link, size: 20),
                    label: const Text('가입하기'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
