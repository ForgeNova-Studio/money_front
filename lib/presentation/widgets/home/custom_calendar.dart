import 'package:flutter/material.dart';
import 'package:moneyflow/core/constants/app_constants.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatefulWidget {
  const CustomCalendar({super.key});

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      // 달력 언어 설정
      locale: 'ko_KR',

      // 현재 포커스된 날짜 (화면에 표시되는 오늘 날짜가 아님)
      // 어떤 달이 화면에 보일지 결정하는 용도
      focusedDay: _focusedDay,
      firstDay: DateTime(2020),
      lastDay: DateTime(2030, 12, 31),

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
        return isSameDay(day, _selectedDay);
      },

      // 날짜 선택 시 호출되는 콜백 함수
      // selectedDay : 선택된 날짜
      // focusedDay :
      // - 같은 달 내 선택: focusedDay는 선택한 날짜와 동일
      // - 다른 달 선택: focusedDay는 현재 보고 있는 달의 마지막 날로 설정됨
      // - pageJumpingEnabled = true 설정 시 -> focusedDay는 선택한 날짜로 설정되고 달이 전환됨
      onDaySelected: (selectedDay, focusedDay) {
        debugPrint('Selected Day: $selectedDay, Focused Day: $focusedDay');
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },

      calendarBuilders: CalendarBuilders(
        headerTitleBuilder: (context, day) {
          return GestureDetector(
            onTap: () {
              debugPrint('Header Title Tapped: $day');
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

        // 오늘 날짜 셀 커스텀
        // - 선택된 날짜 X : 흰색 배경 + 핑크색 테두리 + 검은색 텍스트 스타일 적용
        // - 선택된 날짜 O : 핑크색 원형 배경 + 흰색 텍스트 스타일 적용
        todayBuilder: (context, day, focusedDay) {
          return Container(
            margin: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: _selectedDay != null
                  ? Border.all(
                      color: AppColors.primaryLight,
                      width: 2.0,
                    )
                  : null,
              color: _selectedDay == null ? AppColors.primary : Colors.white,
            ),
            child: Center(
              child: Text(
                '${day.day}',
                style: TextStyle(
                    color: _selectedDay != null
                        ? AppColors.textPrimary
                        : AppColors.textWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
            ),
          );
        },

        // 선택한 날짜 셀 커스텀
        // - 사용자가 선택한 날짜 셀에 [ 핑크색 원형 배경 + 흰색 텍스트 스타일 적용 (애니메이션 X) ]
        // - TableCalendar의 기본 선택 동작에는 애니메이션이 포함되어 있음
        selectedBuilder: (context, day, focusedDay) {
          return Container(
            margin: const EdgeInsets.all(6.0),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${day.day}',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
            ),
          );
        },
      ),
    );
  }
}
