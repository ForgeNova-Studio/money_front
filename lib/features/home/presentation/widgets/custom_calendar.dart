import 'package:flutter/material.dart';
import 'package:moneyflow/core/constants/app_constants.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:moneyflow/features/home/presentation/widgets/custom_month_picker.dart';

class CustomCalendar extends StatefulWidget {
  final DateTime focusedDay;
  final DateTime selectedDay;
  final void Function(DateTime, DateTime)? onDateSelected;
  final void Function(DateTime)? onPageChanged;
  final List<dynamic> Function(DateTime)? eventLoader;
  final CalendarFormat? format;
  final void Function(CalendarFormat)? onFormatChanged;
  final Widget Function(BuildContext, DateTime)? dayBottomBuilder;

  const CustomCalendar({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    this.onDateSelected,
    this.onPageChanged,
    this.eventLoader,
    this.format,
    this.onFormatChanged,
    this.dayBottomBuilder, // Add this
  });

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late CalendarFormat _calendarFormat;

  @override
  void initState() {
    super.initState();
    _calendarFormat = widget.format ?? CalendarFormat.month;
  }

  @override
  void didUpdateWidget(CustomCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.format != null && widget.format != oldWidget.format) {
      setState(() {
        _calendarFormat = widget.format!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      // 달력 언어 설정
      locale: 'ko_KR',

      // 애니메이션 설정
      formatAnimationDuration: const Duration(milliseconds: 300),
      formatAnimationCurve: Curves.easeInOut,

      // 세로 스와이프로 포맷 변경 방지 (좌우 스와이프로 월 이동만 허용)
      availableGestures: AvailableGestures.horizontalSwipe,

      calendarFormat: _calendarFormat,
      onFormatChanged: (format) {
        if (widget.onFormatChanged != null) {
          widget.onFormatChanged!(format);
        } else {
          setState(() {
            _calendarFormat = format;
          });
        }
      },

      // 현재 포커스된 날짜
      focusedDay: widget.focusedDay,
      firstDay: DateTime(2000),
      lastDay: DateTime(2050, 12, 31),

      // 페이지(월) 변경 시 콜백
      onPageChanged: widget.onPageChanged,

      // 각 날짜 셀에 표시할 이벤트 로드
      eventLoader: widget.eventLoader,

      // 달력 헤더 스타일 설정
      headerStyle: const HeaderStyle(
        // 왼쪽 화살표 아이콘 스타일 설정
        leftChevronIcon: Icon(
          Icons.chevron_left,
          size: 20.0,
          color: AppColors.black,
        ),

        // 오른쪽 화살표 아이콘 스타일 설정
        rightChevronIcon: Icon(
          Icons.chevron_right,
          size: 20.0,
          color: AppColors.black,
        ),

        // 왼쪽 화살표 아이콘 마진 조정
        leftChevronMargin: EdgeInsets.only(right: 8.0),

        // 오른쪽 화살표 아이콘 마진 제거
        rightChevronMargin: EdgeInsets.zero,

        // 포멧 버튼 숨기기
        formatButtonVisible: false,
      ),

      daysOfWeekStyle: const DaysOfWeekStyle(
        // 요일(평일: 월 - 금) 텍스트 스타일 설정
        weekdayStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),

        // 요일(주말: 토 - 일) 텍스트 스타일 설정
        weekendStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
      ),

      daysOfWeekHeight: 40.0,
      rowHeight: 62.0, // Slightly increased for compact content

      // 달력 바디 스타일 설정
      calendarStyle: const CalendarStyle(
        // 평일 텍스트 스타일
        defaultTextStyle:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),

        // 주말 텍스트 스타일
        weekendTextStyle:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),

        // 현재 달에 속하지 않는 날짜 셀 숨기기
        outsideDaysVisible: false,
      ),

      // day : 각 날짜 셀의 날짜
      // 각 날짜를 매개변수로 전달하여 _selectedDay와 같은 날짜인지 비교, 같으면 해당 날짜 셀 강조
      selectedDayPredicate: (day) {
        return isSameDay(day, widget.selectedDay);
      },

      // 날짜 선택 시 호출되는 콜백 함수
      onDaySelected: (selectedDay, focusedDay) {
        debugPrint('Selected Day: $selectedDay, Focused Day: $focusedDay');
        widget.onDateSelected?.call(selectedDay, focusedDay);
      },

      calendarBuilders: CalendarBuilders(
        headerTitleBuilder: (context, day) {
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => CustomMonthPicker(
                  initialDate: widget.focusedDay,
                  onDateSelected: (selectedDate) {
                    widget.onPageChanged?.call(selectedDate);
                  },
                ),
              );
            },
            child: Text(
              '${day.year}년 ${day.month}월',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },

        // 오늘 날짜 셀 커스텀 (기본과 동일하게 처리)
        todayBuilder: (context, day, focusedDay) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
            padding: const EdgeInsets.only(top: 6.0),
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${day.day}',
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0),
                ),
                if (widget.dayBottomBuilder != null)
                  Expanded(child: widget.dayBottomBuilder!(context, day)),
              ],
            ),
          );
        },

        // 선택한 날짜 셀 커스텀 (테두리만 표시)
        selectedBuilder: (context, day, focusedDay) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
            padding: const EdgeInsets.only(
                top: 4.0), // Padding slightly reduced to account for border
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color: Colors.transparent, // No background
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${day.day}',
                  style: const TextStyle(
                      color: AppColors
                          .textPrimary, // Changed from White to Primary
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0),
                ),
                if (widget.dayBottomBuilder != null)
                  Expanded(child: widget.dayBottomBuilder!(context, day)),
              ],
            ),
          );
        },

        // 기본 날짜 셀 커스텀
        defaultBuilder: (context, day, focusedDay) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
            padding: const EdgeInsets.only(top: 6.0),
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${day.day}',
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0),
                ),
                if (widget.dayBottomBuilder != null)
                  Expanded(child: widget.dayBottomBuilder!(context, day)),
              ],
            ),
          );
        },
      ),
    );
  }
}
