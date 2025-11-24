import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/expense_model.dart';
import '../providers/expense_provider.dart';
import 'expense_detail_screen.dart';

/// 지출 목록 화면
///
/// 기능:
/// - 날짜 범위 필터 (시작일, 종료일)
/// - 카테고리 필터 (전체, 식비, 교통 등)
/// - 지출 목록 표시 (날짜 최신순)
/// - 총 지출 금액 표시
/// - 지출 항목 클릭 시 상세 화면으로 이동
class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> {
  // 날짜 범위 (기본: 이번 달)
  late DateTime _startDate;
  late DateTime _endDate;

  // 선택된 카테고리 (null = 전체)
  String? _selectedCategory;

  /// 9개 카테고리 + 전체
  final List<Map<String, dynamic>> _categories = [
    {'code': null, 'name': '전체', 'icon': Icons.grid_view},
    {'code': 'FOOD', 'name': '식비', 'icon': Icons.restaurant},
    {'code': 'TRANSPORT', 'name': '교통', 'icon': Icons.directions_car},
    {'code': 'SHOPPING', 'name': '쇼핑', 'icon': Icons.shopping_bag},
    {'code': 'CULTURE', 'name': '문화생활', 'icon': Icons.movie},
    {'code': 'HOUSING', 'name': '주거/통신', 'icon': Icons.home},
    {'code': 'MEDICAL', 'name': '의료/건강', 'icon': Icons.local_hospital},
    {'code': 'EDUCATION', 'name': '교육', 'icon': Icons.school},
    {'code': 'EVENT', 'name': '경조사', 'icon': Icons.card_giftcard},
    {'code': 'ETC', 'name': '기타', 'icon': Icons.more_horiz},
  ];

  @override
  void initState() {
    super.initState();
    // 이번 달 1일 ~ 오늘로 초기화
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = now;
    _selectedCategory = null;

    // 지출 목록 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchExpenses();
    });
  }

  /// 지출 목록 조회
  Future<void> _fetchExpenses() async {
    await context.read<ExpenseProvider>().fetchExpenses(
          startDate: _startDate,
          endDate: _endDate,
          category: _selectedCategory,
        );
  }

  /// 시작일 선택
  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: _endDate,
    );

    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
      _fetchExpenses();
    }
  }

  /// 종료일 선택
  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
      _fetchExpenses();
    }
  }

  /// 카테고리 선택
  void _selectCategory(String? categoryCode) {
    setState(() {
      _selectedCategory = categoryCode;
    });
    _fetchExpenses();
  }

  /// 지출 상세 화면으로 이동
  Future<void> _navigateToDetail(ExpenseModel expense) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ExpenseDetailScreen(expense: expense),
      ),
    );

    // 수정 또는 삭제가 완료되면 목록 새로고침
    if (result == true && mounted) {
      _fetchExpenses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('지출 내역'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 필터 영역
          _buildFilterSection(),

          // 지출 목록
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchExpenses,
              child: Consumer<ExpenseProvider>(
                builder: (context, expenseProvider, child) {
                  if (expenseProvider.status == ExpenseStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (expenseProvider.status == ExpenseStatus.error) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: AppColors.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            expenseProvider.errorMessage ?? '오류가 발생했습니다',
                            style:
                                const TextStyle(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _fetchExpenses,
                            child: const Text('다시 시도'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (expenseProvider.expenses.isEmpty) {
                    return _buildEmptyState();
                  }

                  return _buildExpenseList(expenseProvider);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 필터 섹션 (날짜 범위 + 카테고리)
  Widget _buildFilterSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 날짜 범위 선택
          Row(
            children: [
              // 시작일
              Expanded(
                child: InkWell(
                  onTap: _selectStartDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            DateFormat('yyyy.MM.dd').format(_startDate),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('~', style: TextStyle(fontSize: 16)),
              ),
              // 종료일
              Expanded(
                child: InkWell(
                  onTap: _selectEndDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            DateFormat('yyyy.MM.dd').format(_endDate),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 카테고리 필터
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category['code'];

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          category['icon'],
                          size: 16,
                          color:
                              isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                        const SizedBox(width: 4),
                        Text(category['name']),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (_) => _selectCategory(category['code']),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 빈 상태 위젯
  Widget _buildEmptyState() {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            children: [
              Icon(
                Icons.receipt_long,
                size: 80,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 24),
              const Text(
                '지출 내역이 없습니다',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '다른 날짜 범위 또는 카테고리를 선택해보세요',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 지출 목록 위젯
  Widget _buildExpenseList(ExpenseProvider expenseProvider) {
    // 총 지출 금액 계산
    final totalAmount = expenseProvider.expenses.fold<double>(
      0,
      (sum, expense) => sum + expense.amount,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 총 지출 금액
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '총 지출',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${NumberFormat('#,###').format(totalAmount)}원',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // 지출 개수
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            '${expenseProvider.expenses.length}개 항목',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),

        // 지출 목록
        ...expenseProvider.expenses.map((expense) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () => _navigateToDetail(expense),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // 카테고리 아이콘
                    CircleAvatar(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: Icon(
                        _getCategoryIcon(expense.category),
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // 지출 정보
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            expense.merchant ??
                                _getCategoryName(expense.category),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                DateFormat('MM.dd').format(expense.date),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              if (expense.memo != null &&
                                  expense.memo!.isNotEmpty) ...[
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.note,
                                  size: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    // 금액
                    Text(
                      '${NumberFormat('#,###').format(expense.amount)}원',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  /// 카테고리 코드를 아이콘으로 변환
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

  /// 카테고리 코드를 이름으로 변환
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
}
