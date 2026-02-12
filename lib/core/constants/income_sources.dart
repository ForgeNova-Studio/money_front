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
  final String imagePath;
  final Color color;

  const IncomeSourceItem({
    required this.code,
    required this.name,
    required this.icon,
    required this.imagePath,
    required this.color,
  });
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IncomeSourceItem &&
        other.code == code &&
        other.name == name &&
        other.icon == icon &&
        other.imagePath == imagePath &&
        other.color == color;
  }

  @override
  int get hashCode => Object.hash(code, name, icon, imagePath, color);
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
class IncomeSourceDefinition {
  final String name;
  final IconData
      icon; // Keep icon as fallback or for places where image cannot be used
  final String imagePath;
  final Color color;

  const IncomeSourceDefinition({
    required this.name,
    required this.icon,
    required this.imagePath,
    required this.color,
  });
}

const String _basePath = 'assets/images/income';

const Map<String, IncomeSourceDefinition> _incomeDefinitions = {
  IncomeSource.salary: IncomeSourceDefinition(
    name: '급여',
    icon: Icons.attach_money,
    imagePath: '$_basePath/icon_income_money.png',
    color: Color(0xFF4CAF50),
  ),
  IncomeSource.sideIncome: IncomeSourceDefinition(
    name: '부수입',
    icon: Icons.work,
    imagePath: '$_basePath/icon_income_coins.png',
    color: Color(0xFF2E7D32),
  ),
  IncomeSource.allowance: IncomeSourceDefinition(
    name: '용돈',
    icon: Icons.account_balance_wallet,
    imagePath: '$_basePath/icon_income_allowance.png',
    color: Color(0xFF8D6E63),
  ),
  IncomeSource.bonus: IncomeSourceDefinition(
    name: '상여금',
    icon: Icons.card_giftcard,
    imagePath: '$_basePath/icon_income_bonus.png',
    color: Color(0xFFF57C00),
  ),
  IncomeSource.investment: IncomeSourceDefinition(
    name: '투자수익',
    icon: Icons.trending_up,
    imagePath: '$_basePath/icon_income_invest.png',
    color: Color(0xFF1565C0),
  ),
  IncomeSource.other: IncomeSourceDefinition(
    name: '기타',
    icon: Icons.more_horiz,
    imagePath: '$_basePath/icon_elipsis.png',
    color: Color(0xFF6D4C41),
  ),
};

/// Helper to access definitions without context
IncomeSourceDefinition? getIncomeSourceDefinition(String code) {
  return _incomeDefinitions[code];
}

List<IncomeSourceItem> buildIncomeSources(BuildContext context) {
  return [
    IncomeSource.salary,
    IncomeSource.sideIncome,
    IncomeSource.allowance,
    IncomeSource.bonus,
    IncomeSource.investment,
    IncomeSource.other,
  ].map((code) {
    final def = _incomeDefinitions[code]!;
    // Apply theme color specifically for salary if needed, others use fixed colors
    final color =
        code == IncomeSource.salary ? context.appColors.income : def.color;

    return IncomeSourceItem(
      code: code,
      name: def.name,
      icon: def.icon,
      imagePath: def.imagePath,
      color: color,
    );
  }).toList();
}

String resolveIncomeCategoryLabel(String source) {
  return getIncomeSourceDefinition(source)?.name ?? source;
}

IconData resolveIncomeCategoryIcon(String source) {
  return getIncomeSourceDefinition(source)?.icon ?? Icons.attach_money;
}

String? resolveIncomeCategoryImage(String source) {
  return getIncomeSourceDefinition(source)?.imagePath;
}
