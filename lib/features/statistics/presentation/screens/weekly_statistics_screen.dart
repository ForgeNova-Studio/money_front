import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/weekly_statistics_model.dart';
import '../providers/statistics_provider.dart';

/// 주간 통계 화면
///
/// 기능:
/// - 최근 7일간 일별 지출 라인 차트
/// - 최다 지출 카테고리 표시
/// - 일평균 지출 금액 표시
/// - 날짜 범위 선택 기능
class WeeklyStatisticsScreen extends StatefulWidget {
  const WeeklyStatisticsScreen({super.key});

  @override
  State<WeeklyStatisticsScreen> createState() => _WeeklyStatisticsScreenState();
}

class _WeeklyStatisticsScreenState extends State<WeeklyStatisticsScreen> {
  late DateTime _startDate;

  @override
  void initState() {
    super.initState();
    // 7일 전으로 초기화
    _startDate = DateTime.now().subtract(const Duration(days: 6));

    // 통계 데이터 로드
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchStatistics();
    });
  }

  /// 통계 데이터 조회
  Future<void> _fetchStatistics() async {
    await context.read<StatisticsProvider>().fetchWeeklyStatistics(_startDate);
  }

  /// 시작일 선택
  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
      });
      _fetchStatistics();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.background,
      appBar: AppBar(
        title: Text('주간 통계'),
        backgroundColor: context.appColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer<StatisticsProvider>(
        builder: (context, statsProvider, child) {
          if (statsProvider.status == StatisticsStatus.loading) {
            return Center(child: CircularProgressIndicator());
          }

          if (statsProvider.status == StatisticsStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline,
                      size: 64, color: context.appColors.error),
                  SizedBox(height: 16),
                  Text(
                    statsProvider.errorMessage ?? '오류가 발생했습니다',
                    style: TextStyle(color: context.appColors.textSecondary),
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

          final weeklyStats = statsProvider.weeklyStatistics;
          if (weeklyStats == null) {
            return const Center(child: Text('통계 데이터가 없습니다'));
          }

          return RefreshIndicator(
            onRefresh: _fetchStatistics,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 날짜 선택 버튼
                  _buildDateSelector(),
                  const SizedBox(height: 24),

                  // 요약 카드
                  _buildSummaryCards(weeklyStats),
                  const SizedBox(height: 24),

                  // 라인 차트
                  _buildLineChart(weeklyStats),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 날짜 선택 버튼
  Widget _buildDateSelector() {
    final endDate = _startDate.add(Duration(days: 6));
    return InkWell(
      onTap: _selectStartDate,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.appColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, color: context.appColors.primary),
                SizedBox(width: 12),
                Text(
                  '${DateFormat('MM.dd').format(_startDate)} ~ ${DateFormat('MM.dd').format(endDate)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Icon(Icons.arrow_drop_down, color: context.appColors.textSecondary),
          ],
        ),
      ),
    );
  }

  /// 요약 카드
  Widget _buildSummaryCards(WeeklyStatisticsModel weeklyStats) {
    return Row(
      children: [
        // 최다 지출 카테고리
        Expanded(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.appColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '최다 지출',
                  style: TextStyle(
                    fontSize: 14,
                    color: context.appColors.textSecondary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  _getCategoryName(weeklyStats.topCategory),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: context.appColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12),
        // 일평균 지출
        Expanded(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.appColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '일평균',
                  style: TextStyle(
                    fontSize: 14,
                    color: context.appColors.textSecondary,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '${NumberFormat('#,###').format(weeklyStats.averageDaily)}원',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: context.appColors.secondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 라인 차트
  Widget _buildLineChart(WeeklyStatisticsModel weeklyStats) {
    if (weeklyStats.dailyExpenses.isEmpty) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            '지출 데이터가 없습니다',
            style: TextStyle(color: context.appColors.textSecondary),
          ),
        ),
      );
    }

    // 최대 금액 찾기 (차트 스케일링용)
    final maxAmount = weeklyStats.dailyExpenses
        .map((e) => e.amount)
        .reduce((a, b) => a > b ? a : b);

    final spots = weeklyStats.dailyExpenses.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.amount);
    }).toList();

    return Container(
      height: 300,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '일별 지출 추이',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxAmount > 0 ? maxAmount / 5 : 10000,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: context.appColors.border,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 &&
                            index < weeklyStats.dailyExpenses.length) {
                          final date = weeklyStats.dailyExpenses[index].date;
                          return Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              DateFormat('MM/dd').format(date),
                              style: TextStyle(
                                color: context.appColors.textSecondary,
                                fontSize: 10,
                              ),
                            ),
                          );
                        }
                        return Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: maxAmount > 0 ? maxAmount / 5 : 10000,
                      reservedSize: 50,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${(value / 1000).toInt()}k',
                          style: TextStyle(
                            color: context.appColors.textSecondary,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (weeklyStats.dailyExpenses.length - 1).toDouble(),
                minY: 0,
                maxY: maxAmount * 1.2,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: context.appColors.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: context.appColors.primary,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: context.appColors.primary.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
