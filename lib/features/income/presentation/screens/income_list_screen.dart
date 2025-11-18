import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/color_constants.dart';
import '../../domain/entities/income_model.dart';
import '../providers/income_provider.dart';
import 'income_detail_screen.dart';

/// 수입 목록 화면
///
/// 기능:
/// - 날짜 범위 필터 (시작일, 종료일)
/// - 수입 출처 필터 (전체, 급여, 부수입 등)
/// - 수입 목록 표시 (날짜 최신순)
/// - 총 수입 금액 표시
/// - 수입 항목 클릭 시 상세 화면으로 이동
class IncomeListScreen extends StatefulWidget {
  const IncomeListScreen({super.key});

  @override
  State<IncomeListScreen> createState() => _IncomeListScreenState();
}

class _IncomeListScreenState extends State<IncomeListScreen> {
  // 날짜 범위 (기본: 이번 달)
  late DateTime _startDate;
  late DateTime _endDate;

  // 선택된 수입 출처 (null = 전체)
  String? _selectedSource;

  /// 5개 수입 출처 + 전체
  final List<Map<String, dynamic>> _sources = [
    {'code': null, 'name': '전체', 'icon': Icons.grid_view},
    {'code': IncomeSource.salary, 'name': '급여', 'icon': Icons.work},
    {
      'code': IncomeSource.sideIncome,
      'name': '부수입',
      'icon': Icons.attach_money
    },
    {'code': IncomeSource.bonus, 'name': '상여금', 'icon': Icons.card_giftcard},
    {
      'code': IncomeSource.investment,
      'name': '투자수익',
      'icon': Icons.trending_up
    },
    {'code': IncomeSource.other, 'name': '기타', 'icon': Icons.more_horiz},
  ];

  @override
  void initState() {
    super.initState();
    // 이번 달 1일 ~ 오늘로 초기화
    final now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = now;
    _selectedSource = null;

    // 수입 목록 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchIncomes();
    });
  }

  /// 수입 목록 조회
  Future<void> _fetchIncomes() async {
    await context.read<IncomeProvider>().fetchIncomes(
          startDate: _startDate,
          endDate: _endDate,
          source: _selectedSource,
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
      _fetchIncomes();
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
      _fetchIncomes();
    }
  }

  /// 수입 출처 선택
  void _selectSource(String? sourceCode) {
    setState(() {
      _selectedSource = sourceCode;
    });
    _fetchIncomes();
  }

  /// 수입 상세 화면으로 이동
  Future<void> _navigateToDetail(IncomeModel income) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => IncomeDetailScreen(income: income),
      ),
    );

    // 수정 또는 삭제가 완료되면 목록 새로고침
    if (result == true && mounted) {
      _fetchIncomes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('수입 내역'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 필터 영역
          _buildFilterSection(),

          // 수입 목록
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchIncomes,
              child: Consumer<IncomeProvider>(
                builder: (context, incomeProvider, child) {
                  if (incomeProvider.status == IncomeStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (incomeProvider.status == IncomeStatus.error) {
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
                            incomeProvider.errorMessage ?? '오류가 발생했습니다',
                            style:
                                const TextStyle(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _fetchIncomes,
                            child: const Text('다시 시도'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (incomeProvider.incomes.isEmpty) {
                    return _buildEmptyState();
                  }

                  return _buildIncomeList(incomeProvider);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 필터 섹션 (날짜 범위 + 수입 출처)
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

          // 수입 출처 필터
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _sources.length,
              itemBuilder: (context, index) {
                final source = _sources[index];
                final isSelected = _selectedSource == source['code'];

                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          source['icon'],
                          size: 16,
                          color:
                              isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                        const SizedBox(width: 4),
                        Text(source['name']),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (_) => _selectSource(source['code']),
                    selectedColor: AppColors.income,
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
                Icons.attach_money,
                size: 80,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 24),
              const Text(
                '수입 내역이 없습니다',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '다른 날짜 범위 또는 출처를 선택해보세요',
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

  /// 수입 목록 위젯
  Widget _buildIncomeList(IncomeProvider incomeProvider) {
    // 총 수입 금액 계산
    final totalAmount = incomeProvider.incomes.fold<double>(
      0,
      (sum, income) => sum + income.amount,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 총 수입 금액
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.income,
                AppColors.income.withValues(alpha: 0.7)
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '총 수입',
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

        // 수입 개수
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            '${incomeProvider.incomes.length}개 항목',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),

        // 수입 목록
        ...incomeProvider.incomes.map((income) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () => _navigateToDetail(income),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // 수입 출처 아이콘
                    CircleAvatar(
                      backgroundColor: AppColors.income.withValues(alpha: 0.1),
                      child: Icon(
                        _getSourceIcon(income.source),
                        color: AppColors.income,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // 수입 정보
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            income.source,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                DateFormat('MM.dd').format(income.date),
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              if (income.description != null &&
                                  income.description!.isNotEmpty) ...[
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
                      '${NumberFormat('#,###').format(income.amount)}원',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.income,
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

  /// 수입 출처를 아이콘으로 변환
  IconData _getSourceIcon(String source) {
    switch (source) {
      case '급여':
        return Icons.work;
      case '부수입':
        return Icons.attach_money;
      case '상여금':
        return Icons.card_giftcard;
      case '투자수익':
        return Icons.trending_up;
      default:
        return Icons.more_horiz;
    }
  }
}
