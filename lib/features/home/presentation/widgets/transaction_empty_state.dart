import 'package:flutter/material.dart';
import 'package:moamoa/core/constants/app_constants.dart';

/// 거래 내역이 없을 때 표시되는 빈 상태(Empty State) 위젯
///
/// 선택된 날짜에 거래 내역이 없을 경우 아이콘과 메시지를 표시합니다.
///
/// 주요 기능:
/// - 영수증 아이콘과 안내 메시지 표시
/// - 선택된 날짜 기반 동적 메시지 생성
///
/// 파라미터:
/// - [selectedDate]: 현재 선택된 날짜 (메시지에 표시됨)
///
/// 사용 예시:
/// ```dart
/// TransactionEmptyState(selectedDate: DateTime.now())
/// ```
class TransactionEmptyState extends StatelessWidget {
  const TransactionEmptyState({super.key, required this.selectedDate});

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 48, color: context.appColors.gray300),
          SizedBox(height: 16),
          Text(
            '${selectedDate.month}월 ${selectedDate.day}일 내역이 없습니다.',
            style: TextStyle(color: context.appColors.textTertiary),
          ),
        ],
      ),
    );
  }
}
