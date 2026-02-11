import 'package:flutter/material.dart';

import 'package:moamoa/core/constants/app_constants.dart';
import 'package:moamoa/features/income/domain/entities/income.dart';

/// 수입원(Income Source) 정보를 담는 UI 모델 클래스.
///
/// 수입의 유형(급여, 부수입 등)을 화면에 표시하기 위한 데이터를 관리합니다.
///
/// **주요 속성:**
/// - `code`: 수입원 식별 코드 (예: 'SALARY')
/// - `name`: 표시 이름
/// - `icon`: 아이콘 데이터 (`IconData`)
/// - `color`: 표시 색상 (`Color`)
///
/// **사용 예시:**
/// ```dart
/// const source = IncomeSourceItem(
///   code: 'SALARY',
///   name: '급여',
///   icon: Icons.work,
///   color: Colors.green,
/// );
/// ```
class IncomeSourceItem {
  final String code;
  final String name;
  final IconData icon;
  final Color color;

  const IncomeSourceItem({
    required this.code,
    required this.name,
    required this.icon,
    required this.color,
  });
}

/// 사용 가능한 수입원 목록을 생성하여 반환하는 함수.
///
/// 현재 테마(`context`)에 맞는 색상을 적용하여 수입원 리스트를 구성합니다.
///
/// **주요 기능:**
/// - **수입원 리스트 생성**: 급여, 부수입, 상여금, 투자수익, 기타 등 정의된 수입원 반환.
/// - **테마 연동**: `context.appColors`를 사용하여 일관된 색상 적용.
///
/// **파라미터:**
/// - `context`: 테마 색상을 가져오기 위한 BuildContext.
///
/// **사용 예시:**
/// ```dart
/// final sources = buildIncomeSources(context);
/// ```
List<IncomeSourceItem> buildIncomeSources(BuildContext context) {
  return [
    IncomeSourceItem(
      code: IncomeSource.salary,
      name: '급여',
      icon: Icons.work,
      color: context.appColors.income,
    ),
    IncomeSourceItem(
      code: IncomeSource.sideIncome,
      name: '부수입',
      icon: Icons.attach_money,
      color: const Color(0xFF2E7D32),
    ),
    IncomeSourceItem(
      code: IncomeSource.bonus,
      name: '상여금',
      icon: Icons.card_giftcard,
      color: const Color(0xFFF57C00),
    ),
    IncomeSourceItem(
      code: IncomeSource.investment,
      name: '투자수익',
      icon: Icons.trending_up,
      color: const Color(0xFF1565C0),
    ),
    IncomeSourceItem(
      code: IncomeSource.other,
      name: '기타',
      icon: Icons.more_horiz,
      color: const Color(0xFF6D4C41),
    ),
  ];
}
