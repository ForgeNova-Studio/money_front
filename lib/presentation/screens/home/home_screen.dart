import 'package:flutter/material.dart';
import 'package:moneyflow/features/budget/presentation/providers/budget_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/color_constants.dart';
import '../../../features/auth/presentation/providers/auth_provider.dart';
import '../../../features/expense/presentation/providers/expense_provider.dart';
import '../../../features/income/presentation/providers/income_provider.dart';
import '../../../features/couple/presentation/providers/couple_provider.dart';
import '../../../features/expense/presentation/screens/add_expense_screen.dart';
import '../../../features/expense/presentation/screens/expense_detail_screen.dart';
import '../../../features/expense/presentation/screens/expense_list_screen.dart';
import '../../../features/income/presentation/screens/add_income_screen.dart';
import '../../../features/income/presentation/screens/income_detail_screen.dart';
import '../../../features/income/presentation/screens/income_list_screen.dart';
import '../../../features/statistics/presentation/screens/statistics_screen.dart';
import '../settings/settings_screen.dart';
import '../../../features/couple/presentation/screens/couple_invite_screen.dart';
import '../../../features/couple/presentation/screens/couple_join_screen.dart';
import '../../../features/budget/presentation/screens/budget_setting_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // 최근 지출 내역, 최근 수입 내역, 커플 정보, 예산 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExpenseProvider>().fetchRecentExpenses();
      context.read<IncomeProvider>().fetchRecentIncomes();
      context.read<CoupleProvider>().loadCurrentCouple();
      // 현재 월의 예산 조회
      final now = DateTime.now();
      context.read<BudgetProvider>().fetchBudget(now.year, now.month);
    });
  }

  /// + 버튼 클릭 시 액션 선택 다이얼로그 표시
  Future<void> _showAddActionDialog() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 제목
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Text(
                        '추가하기',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 지출 등록
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.arrow_downward,
                        color: AppColors.error),
                  ),
                  title: const Text('지출 등록',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('지출 내역을 추가합니다',
                      style: TextStyle(fontSize: 12)),
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToAddExpense();
                  },
                ),

                // 수입 등록
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.arrow_upward,
                        color: AppColors.primary),
                  ),
                  title: const Text('수입 등록',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('수입 내역을 추가합니다',
                      style: TextStyle(fontSize: 12)),
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToAddIncome();
                  },
                ),

                // 예산 설정
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.account_balance_wallet,
                        color: Colors.orange),
                  ),
                  title: const Text('예산 설정',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('월별 목표 예산을 설정합니다',
                      style: TextStyle(fontSize: 12)),
                  onTap: () {
                    Navigator.pop(context);
                    _navigateToBudgetSetting();
                  },
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 지출 등록 화면으로 이동
  Future<void> _navigateToAddExpense() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
    );

    // 지출이 추가되면 목록 새로고침
    if (result == true && mounted) {
      context.read<ExpenseProvider>().fetchRecentExpenses();
      // 예산 정보도 새로고침 (지출이 추가되면 예산 사용액 변경됨)
      final now = DateTime.now();
      context.read<BudgetProvider>().fetchBudget(now.year, now.month);
    }
  }

  /// 수입 등록 화면으로 이동
  Future<void> _navigateToAddIncome() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddIncomeScreen()),
    );

    // 수입이 추가되면 목록 새로고침
    if (result == true && mounted) {
      context.read<IncomeProvider>().fetchRecentIncomes();
    }
  }

  /// 예산 설정 화면으로 이동
  Future<void> _navigateToBudgetSetting() async {
    final now = DateTime.now();
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BudgetSettingScreen(
          initialYear: now.year,
          initialMonth: now.month,
        ),
      ),
    );

    // 예산 설정이 완료되면 새로고침
    if (result == true && mounted) {
      context.read<BudgetProvider>().fetchBudget(now.year, now.month);
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
      // 예산 정보도 새로고침
      final now = DateTime.now();
      context.read<BudgetProvider>().fetchBudget(now.year, now.month);
    }
  }

  /// 수입 상세 화면으로 이동
  Future<void> _navigateToIncomeDetail(income) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => IncomeDetailScreen(income: income),
      ),
    );

    // 수정 또는 삭제가 완료되면 목록 새로고침
    if (result == true && mounted) {
      context.read<IncomeProvider>().fetchRecentIncomes();
    }
  }

  /// 수입 목록 화면으로 이동
  Future<void> _navigateToIncomeList() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const IncomeListScreen(),
      ),
    );

    // 목록 화면에서 수정/삭제가 발생하면 홈 화면도 새로고침
    if (result == true && mounted) {
      context.read<IncomeProvider>().fetchRecentIncomes();
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
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${authProvider.user?.nickname ?? '사용자'}님!',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),

                // 월간 목표 예산 카드
                Consumer<BudgetProvider>(
                  builder: (context, budgetProvider, child) {
                    return _buildBudgetCard(budgetProvider);
                  },
                ),
                const SizedBox(height: 24),

                // 커플 연동 안내 카드
                Consumer<CoupleProvider>(
                  builder: (context, coupleProvider, child) {
                    final couple = coupleProvider.couple;
                    final isLinked = couple?.linked ?? false;

                    // 커플이 연동되지 않은 경우에만 안내 카드 표시
                    if (!isLinked &&
                        coupleProvider.status != CoupleStatus.loading) {
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
                                color: AppColors.textSecondary
                                    .withValues(alpha: 0.5),
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
                                    AppColors.error.withValues(alpha: 0.1),
                                child: Icon(
                                  _getCategoryIcon(expense.category),
                                  color: AppColors.error,
                                ),
                              ),
                              title: Text(
                                expense.merchant ??
                                    _getCategoryName(expense.category),
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

                const SizedBox(height: 32),

                // 최근 수입 내역
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '최근 수입',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    TextButton(
                      onPressed: _navigateToIncomeList,
                      child: const Text('전체보기'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 수입 목록
                Consumer<IncomeProvider>(
                  builder: (context, incomeProvider, child) {
                    if (incomeProvider.status == IncomeStatus.loading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    if (incomeProvider.recentIncomes.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              Icon(
                                Icons.account_balance_wallet,
                                size: 64,
                                color: AppColors.textSecondary
                                    .withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '아직 수입 내역이 없습니다',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '+ 버튼을 눌러 첫 수입을 등록해보세요',
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
                      itemCount: incomeProvider.recentIncomes.length,
                      itemBuilder: (context, index) {
                        final income = incomeProvider.recentIncomes[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          // 수입 항목 클릭 시 상세 화면으로 이동
                          child: InkWell(
                            onTap: () => _navigateToIncomeDetail(income),
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
                                  _getIncomeSourceIcon(income.source),
                                  color: AppColors.primary,
                                ),
                              ),
                              title: Text(
                                income.description ??
                                    _getIncomeSourceName(income.source),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat('yyyy.MM.dd').format(income.date),
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              trailing: Text(
                                '+${NumberFormat('#,###').format(income.amount)}원',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
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
        onPressed: _showAddActionDialog,
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

  IconData _getIncomeSourceIcon(String source) {
    switch (source) {
      case 'SALARY':
        return Icons.work;
      case 'SIDE_INCOME':
        return Icons.attach_money;
      case 'BONUS':
        return Icons.card_giftcard;
      case 'INVESTMENT':
        return Icons.trending_up;
      default:
        return Icons.more_horiz;
    }
  }

  String _getIncomeSourceName(String source) {
    switch (source) {
      case 'SALARY':
        return '급여';
      case 'SIDE_INCOME':
        return '부수입';
      case 'BONUS':
        return '상여금';
      case 'INVESTMENT':
        return '투자수익';
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

  /// 월간 목표 예산 카드
  Widget _buildBudgetCard(BudgetProvider budgetProvider) {
    final now = DateTime.now();
    final budget = budgetProvider.budget;

    // 예산이 없는 경우
    if (budget == null) {
      return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
        child: InkWell(
          onTap: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BudgetSettingScreen(
                  initialYear: now.year,
                  initialMonth: now.month,
                ),
              ),
            );
            if (result == true && mounted) {
              context.read<BudgetProvider>().fetchBudget(now.year, now.month);
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '이번 달 목표 예산',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '목표를 설정해보세요',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 예산이 있는 경우
    final usagePercentage = budget.usagePercentage.clamp(0, 100);
    Color progressColor = AppColors.primary;
    if (budget.usagePercentage >= 80) {
      progressColor = AppColors.error;
    } else if (budget.usagePercentage >= 50) {
      progressColor = Colors.orange;
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BudgetSettingScreen(
                initialYear: budget.year,
                initialMonth: budget.month,
              ),
            ),
          );
          if (result == true && mounted) {
            context.read<BudgetProvider>().fetchBudget(now.year, now.month);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: progressColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.account_balance_wallet,
                          color: progressColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${budget.year}년 ${budget.month}월 예산',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.edit,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 금액 정보
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '현재 소비',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${NumberFormat('#,###').format(budget.currentSpending)}원',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: progressColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        '목표 금액',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${NumberFormat('#,###').format(budget.targetAmount)}원',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 진행 바
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: usagePercentage / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${usagePercentage.toStringAsFixed(1)}% 사용',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '${NumberFormat('#,###').format(budget.remainingAmount)}원 남음',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
