import 'package:flutter/material.dart';

/// 관리자 전용 배지 위젯
///
/// 관리자 권한이 필요한 기능이나 화면임을 표시하는 시각적 요소입니다.
/// 붉은색 계열의 아이콘과 텍스트로 구성됩니다.
class AdminOnlyBadge extends StatelessWidget {
  const AdminOnlyBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.admin_panel_settings, size: 16, color: Colors.red),
          SizedBox(width: 6),
          Text(
            '관리자 전용',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
