import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

/// 홈 화면 앱바 헤더
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
