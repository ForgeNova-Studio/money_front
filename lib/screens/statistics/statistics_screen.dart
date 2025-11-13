import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/color_constants.dart';
import '../../providers/statistics_provider.dart';

/// 통계 화면
///
/// 기능:
/// - 기간 선택 (년/월)
/// - 총 지출 금액 표시
/// - 카테고리별 파이 차트
/// - 전월 대비 증감 표시
/// - 카테고리별 상세 리스트
class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late int _selectedYear;
  late int _selectedMonth;

  @override
  void initState() {
    super.initState();
    // 현재 년월로 초기화
    final now = DateTime.now();
    _selectedYear = now.year;
    _selectedMonth = now.month;

    // 통계 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchStatistics();
    });
  }

  /// 통계 데이터 조회
  Future<void> _fetchStatistics() async {
    await context
        .read<StatisticsProvider>()
        .fetchMonthlyStatistics(_selectedYear, _selectedMonth);
  }

  /// 년도 선택
  Future<void> _selectYear() async {
    final year = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('년도 선택'),
        children: List.generate(5, (index) {
          final year = DateTime.now().year - index;
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(context, year),
            child: Text('$year년'),
          );
        }),
      ),
    );

    if (year != null && year != _selectedYear) {
      setState(() {
        _selectedYear = year;
      });
      _fetchStatistics();
    }
  }

  /// 월 선택
  Future<void> _selectMonth() async {
    final month = await showDialog<int>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('월 선택'),
        children: List.generate(12, (index) {
          final month = index + 1;
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(context, month),
            child: Text('$month월'),
          );
        }),
      ),
    );

    if (month != null && month != _selectedMonth) {
      setState(() {
        _selectedMonth = month;
      });
      _fetchStatistics();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('통계'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchStatistics,
        child: Consumer<StatisticsProvider>(
          builder: (context, statisticsProvider, child) {
            if (statisticsProvider.status == StatisticsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (statisticsProvider.status == StatisticsStatus.error) {
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
                      statisticsProvider.errorMessage ?? '오류가 발생했습니다',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchStatistics,
                      child: const Text('다시 시도'),
                    ),
                  ],
                ),
              );
            }

            final stats = statisticsProvider.monthlyStatistics;

            if (stats == null) {
              return _buildEmptyState();
            }

            return _buildStatistics(stats);
          },
        ),
      ),
    );
  }

  /// 빈 상태 위젯
  Widget _buildEmptyState() {
    return ListView(
      children: [
        // 기간 선택
        _buildPeriodSelector(),

        Padding(
          padding: const EdgeInsets.all(48),
          child: Column(
            children: [
              Icon(
                Icons.pie_chart_outline,
                size: 80,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 24),
              const Text(
                '통계 데이터가 없습니다',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '지출을 등록하면 통계를 확인할 수 있습니다',
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

  /// 통계 위젯
  Widget _buildStatistics(stats) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 기간 선택
        _buildPeriodSelector(),
        const SizedBox(height: 16),

        // 총 지출 금액 카드
        _buildTotalAmountCard(stats),
        const SizedBox(height: 16),

        // 전월 대비 카드
        _buildComparisonCard(stats),
        const SizedBox(height: 24),

        // 카테고리별 파이 차트
        if (stats.categoryBreakdown.isNotEmpty) ...[
          _buildCategoryChart(stats),
          const SizedBox(height: 24),
        ],

        // 카테고리별 상세 리스트
        _buildCategoryList(stats),
      ],
    );
  }

  /// 기간 선택 위젯
  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 년도 선택
          InkWell(
            onTap: _selectYear,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    '$_selectedYear년',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_drop_down, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // 월 선택
          InkWell(
            onTap: _selectMonth,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Text(
                    '$_selectedMonth월',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_drop_down, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 총 지출 금액 카드
  Widget _buildTotalAmountCard(stats) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '총 지출',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${NumberFormat('#,###').format(stats.totalAmount)}원',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// 전월 대비 카드
  Widget _buildComparisonCard(stats) {
    final comparison = stats.comparisonWithLastMonth;
    final isIncrease = comparison.diff >= 0;
    final color = isIncrease ? AppColors.error : AppColors.success;
    final icon = isIncrease ? Icons.arrow_upward : Icons.arrow_downward;
    final sign = isIncrease ? '+' : '';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '전월 대비',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$sign${NumberFormat('#,###').format(comparison.diff.abs())}원',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$sign${comparison.diffPercentage.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// 카테고리별 파이 차트
  Widget _buildCategoryChart(stats) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '카테고리별 지출',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: _buildPieSections(stats.categoryBreakdown),
                sectionsSpace: 2,
                centerSpaceRadius: 60,
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 파이 차트 섹션 생성
  List<PieChartSectionData> _buildPieSections(List categoryBreakdown) {
    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.success,
      AppColors.warning,
      AppColors.error,
      AppColors.info,
      const Color(0xFF9C27B0),
      const Color(0xFFE91E63),
      const Color(0xFF795548),
    ];

    return categoryBreakdown.asMap().entries.map((entry) {
      final index = entry.key;
      final item = entry.value;
      final color = colors[index % colors.length];

      return PieChartSectionData(
        color: color,
        value: item.amount,
        title: '${item.percentage}%',
        radius: 50,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  /// 카테고리별 상세 리스트
  Widget _buildCategoryList(stats) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              '카테고리별 상세',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          ...stats.categoryBreakdown.map((item) {
            return Column(
              children: [
                const Divider(height: 1),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    child: Icon(
                      _getCategoryIcon(item.category),
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  title: Text(
                    _getCategoryName(item.category),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    '${item.percentage}%',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  trailing: Text(
                    '${NumberFormat('#,###').format(item.amount)}원',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
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
