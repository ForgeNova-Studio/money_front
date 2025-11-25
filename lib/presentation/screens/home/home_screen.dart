import 'package:flutter/material.dart';
import 'package:moneyflow/core/constants/app_constants.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TableCalendar(
          // 달력 언어 설정
          locale: 'ko_KR',

          // 현재 포커스된 날짜 (화면에 표시되는 오늘 날짜가 아님)
          // 어떤 달이 화면에 보일지 결정하는 용도
          focusedDay: _focusedDay,
          firstDay: DateTime(2020),
          lastDay: DateTime(2030, 12, 31),

          // 달력 헤더 스타일 설정
          headerStyle: const HeaderStyle(
            // 헤더 텍스트 스타일 설정
            titleTextStyle: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),

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
            weekdayStyle:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),

            // 요일(주말: 토 - 일) 텍스트 스타일 설정
            weekendStyle:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),

          daysOfWeekHeight: 40.0,

          // 달력 바디 스타일 설정
          calendarStyle: CalendarStyle(
              // 평일 텍스트 스타일
              defaultTextStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),

              // 주말 텍스트 스타일
              weekendTextStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),

              // 오늘 날짜 텍스트 스타일
              todayTextStyle: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),

              // 선택된 날짜 텍스트 스타일
              selectedTextStyle: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),

              // 오늘 날짜 셀 스타일
              todayDecoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primaryLight,
                  width: 2.0,
                ),
              ),

              // 선택된 날짜 셀 스타일
              selectedDecoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              )),

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
          // - pageJumpingEnabled가 true인 경우, focusedDay는 선택한 날짜로 설정됨
          onDaySelected: (selectedDay, focusedDay) {
            debugPrint('Selected Day: $selectedDay, Focused Day: $focusedDay');
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },

          // 달력의 모양을 커스터마이징할 수 있는 빌더
          // outsideBuilder: 달력의 현재 달에 속하지 않는 날짜 셀을 커스터마이징
          // - 빈 컨테이너 설정으로 현재 달 외 날짜 셀 숨김
          calendarBuilders: CalendarBuilders(
            outsideBuilder: (context, day, focusedDay) {
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
