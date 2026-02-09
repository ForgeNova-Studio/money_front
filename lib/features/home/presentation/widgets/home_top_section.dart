import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:moamoa/features/home/domain/entities/daily_transaction_summary.dart';
import 'package:moamoa/features/home/presentation/widgets/custom_calendar.dart';
import 'package:moamoa/features/home/presentation/widgets/home_budget_info_card.dart';
import 'package:moamoa/features/home/presentation/widgets/home_pending_expenses_banner.dart';

/// 홈 화면 상단 영역을 구성하는 복합 위젯
///
/// 다음 3가지 주요 요소를 수직으로 배치하여 표시합니다:
/// 1. [HomeBudgetInfoCard]: 이번 달 예산/자산 현황 및 지출 가능 금액
/// 2. [HomePendingExpensesBanner]: 승인 대기 중인 지출 내역 (OCR/SMS 등)
/// 3. [CustomCalendar]: 월간/주간 수입 지출 내역을 시각화하는 캘린더
class HomeTopSection extends StatelessWidget {
  final CalendarFormat calendarFormat;
  final DateTime focusedDay;
  final DateTime selectedDay;
  final AsyncValue<Map<String, DailyTransactionSummary>> monthlyData;
  final ValueChanged<CalendarFormat> onFormatChanged;
  final void Function(DateTime, DateTime) onDateSelected;
  final void Function(DateTime) onPageChanged;

  const HomeTopSection({
    super.key,
    required this.calendarFormat,
    required this.focusedDay,
    required this.selectedDay,
    required this.monthlyData,
    required this.onFormatChanged,
    required this.onDateSelected,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          // 1. 예산/자산 정보
          const HomeBudgetInfoCard(),

          // 2. 대기중인 지출 내역
          const HomePendingExpensesBanner(),

          // 3. Custom Calendar
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: CustomCalendar(
              format: calendarFormat,
              focusedDay: focusedDay,
              selectedDay: selectedDay,
              monthlyData: monthlyData,
              onFormatChanged: onFormatChanged,
              onDateSelected: onDateSelected,
              onPageChanged: onPageChanged,
            ),
          ),
        ],
      ),
    );
  }
}
