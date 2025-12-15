import 'package:flutter/material.dart';
import 'package:moneyflow/core/constants/app_constants.dart';

class CustomMonthPicker extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const CustomMonthPicker({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<CustomMonthPicker> createState() => _CustomMonthPickerState();
}

class _CustomMonthPickerState extends State<CustomMonthPicker> {
  late PageController _yearPageController;
  late PageController _monthPageController;

  late int _selectedYear;
  late int _selectedMonth;

  bool _isYearMode = false;
  bool _isProgrammaticPageChange = false; // 프로그래밍 방식의 페이지 전환 플래그

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialDate.year;
    _selectedMonth = widget.initialDate.month;

    // 초기 페이지 계산 - 선택된 년도가 포함된 페이지 표시
    // 한 페이지에 12개(3줄 × 4열) 표시
    const startYear = 2000;
    final selectedIndex = _selectedYear - startYear;
    final yearInitialPage = selectedIndex ~/ 12; // 12개씩 페이지 구성

    _yearPageController = PageController(initialPage: yearInitialPage);

    // 월 PageController: 각 년도가 하나의 페이지
    final monthInitialPage = _selectedYear - startYear;
    _monthPageController = PageController(initialPage: monthInitialPage);
  }

  @override
  void dispose() {
    _yearPageController.dispose();
    _monthPageController.dispose();
    super.dispose();
  }

  void _moveToPrevious() {
    if (_isYearMode) {
      // 년도 모드: 이전 페이지로 이동 (위로)
      if (_yearPageController.page! > 0) {
        _yearPageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      // 월 모드: 이전 년도로 이동 (chevron_up = 위 = 이전)
      const startYear = 2000;
      final currentPage = _selectedYear - startYear;
      if (currentPage > 0) {
        _monthPageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _moveToNext() {
    if (_isYearMode) {
      // 년도 모드: 다음 페이지로 이동 (아래로)
      if (_yearPageController.page! < _getMaxPage()) {
        _yearPageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      // 월 모드: 다음 년도로 이동 (chevron_down = 아래 = 다음)
      const startYear = 2000;
      const endYear = 2050;
      final currentPage = _selectedYear - startYear;
      const maxPage = endYear - startYear;
      if (currentPage < maxPage) {
        _monthPageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _toggleYearMode() {
    // 월 모드일 때만 년도 모드로 전환 가능
    if (_isYearMode) {
      return; // 이미 년도 모드이면 아무 동작 안 함
    }

    setState(() {
      _isYearMode = true;
    });

    // 년도 모드로 전환 시 현재 선택된 년도로 페이지 이동
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _jumpToSelectedYearPage();
    });
  }

  void _jumpToSelectedYearPage() {
    const startYear = 2000;
    final selectedIndex = _selectedYear - startYear;
    final targetPage = selectedIndex ~/ 12; // 12개씩 페이지 구성

    _yearPageController.jumpToPage(
      targetPage.clamp(0, _getMaxPage()),
    );
  }

  int _getMaxPage() {
    const startYear = 2000;
    const endYear = 2050;
    const totalYears = endYear - startYear + 1;
    const itemsPerPage = 12; // 3줄 × 4열
    final maxPage = (totalYears / itemsPerPage).ceil() - 1;
    return maxPage;
  }

  void _selectYear(int year) {
    setState(() {
      _selectedYear = year;
      _isYearMode = false;
    });

    // 월 화면으로 전환된 후 PageController를 선택된 년도로 이동
    WidgetsBinding.instance.addPostFrameCallback((_) {
      const startYear = 2000;
      final targetPage = year - startYear;
      _isProgrammaticPageChange = true;
      _monthPageController.jumpToPage(targetPage);
    });
  }

  void _selectMonth(int month) {
    setState(() {
      _selectedMonth = month;
    });
  }

  void _onConfirm() {
    final selectedDate = DateTime(_selectedYear, _selectedMonth);
    widget.onDateSelected(selectedDate);
    Navigator.of(context).pop();
  }

  void _onCancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: 320,
        height: 400,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 헤더
            _buildHeader(),
            const SizedBox(height: 20),

            // 바디
            Expanded(
              child: _isYearMode ? _buildYearGrid() : _buildMonthGrid(),
            ),
            const SizedBox(height: 20),

            // 푸터
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 년도 표시 (탭 가능)
        GestureDetector(
          onTap: _toggleYearMode,
          child: Text(
            '$_selectedYear년',
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // 년도 증감 버튼
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_up, size: 24),
              onPressed: _moveToPrevious,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_down, size: 24),
              onPressed: _moveToNext,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMonthGrid() {
    const startYear = 2000;
    const endYear = 2050;
    const totalYears = endYear - startYear + 1;

    return PageView.builder(
      controller: _monthPageController,
      scrollDirection: Axis.vertical,
      itemCount: totalYears,
      onPageChanged: (pageIndex) {
        // 프로그래밍 방식의 페이지 전환은 무시
        if (_isProgrammaticPageChange) {
          _isProgrammaticPageChange = false;
          return;
        }

        // 사용자가 슬라이드할 때만 년도 업데이트
        final newYear = startYear + pageIndex;
        setState(() {
          _selectedYear = newYear;
        });
      },
      itemBuilder: (context, pageIndex) {
        final year = startYear + pageIndex;

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            final month = index + 1;
            final isSelected = month == _selectedMonth && year == _selectedYear;

            return GestureDetector(
              onTap: () => _selectMonth(month),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primary : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$month',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildYearGrid() {
    // 2000년부터 2050년까지 총 51개 년도 표시
    const startYear = 2000;
    const endYear = 2050;
    final years =
        List.generate(endYear - startYear + 1, (index) => startYear + index);

    // 한 페이지에 3줄 × 4열 = 12개씩 표시
    const itemsPerPage = 12;
    final totalPages = (years.length / itemsPerPage).ceil();

    return PageView.builder(
      controller: _yearPageController,
      scrollDirection: Axis.vertical,
      itemCount: totalPages,
      itemBuilder: (context, pageIndex) {
        final startIndex = pageIndex * itemsPerPage;
        final endIndex = (startIndex + itemsPerPage).clamp(0, years.length);
        final pageYears = years.sublist(startIndex, endIndex);

        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: pageYears.length,
          itemBuilder: (context, index) {
            final year = pageYears[index];
            final isSelected = year == _selectedYear;

            return GestureDetector(
              onTap: () => _selectYear(year),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? AppColors.primary : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$year',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: _onCancel,
          child: const Text(
            '취소',
            style: TextStyle(
              fontSize: 16.0,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          onPressed: _onConfirm,
          child: const Text(
            '확인',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
