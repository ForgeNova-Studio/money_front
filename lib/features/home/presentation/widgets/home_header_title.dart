import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

/// 홈 화면 AppBar의 타이틀 위젯 (가계부 선택기)
///
/// 현재 선택된 가계부 이름을 표시하며, 탭하면 가계부 변경 메뉴를 토글합니다.
/// 메뉴의 개폐 상태([isMenuOpen])에 따라 화살표 아이콘 방향이 변경됩니다.
///
/// 주요 기능:
/// - 현재 선택된 가계부명 표시 (긴 이름은 말줄임표 처리)
/// - 탭 시 드롭다운 메뉴 토글
/// - 메뉴 상태에 따른 화살표 아이콘 방향 변경 (▲/▼)
///
/// 파라미터:
/// - [selectedAccountBookName]: 현재 선택된 가계부 이름
/// - [isMenuOpen]: 드롭다운 메뉴 개폐 상태
/// - [onTap]: 타이틀 탭 시 호출되는 콜백
///
/// 사용 예시:
/// ```dart
/// HomeHeaderTitle(
///   selectedAccountBookName: '개인 가계부',
///   isMenuOpen: _isDropdownOpen,
///   onTap: () => setState(() => _isDropdownOpen = !_isDropdownOpen),
/// )
/// ```
class HomeHeaderTitle extends StatelessWidget {
  final String selectedAccountBookName;
  final bool isMenuOpen;
  final VoidCallback onTap;

  const HomeHeaderTitle({
    super.key,
    required this.selectedAccountBookName,
    required this.isMenuOpen,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      splashColor: AppColors.transparent,
      highlightColor: AppColors.transparent,
      overlayColor: WidgetStateProperty.all(AppColors.transparent),
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              selectedAccountBookName,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Icon(
            isMenuOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
            color: colorScheme.onSurface,
          ),
        ],
      ),
    );
  }
}
