/// 수입 카테고리 엔티티
/// 수입 카테고리 정보를 담는 엔티티 클래스.
///
/// **주요 속성:**
/// - `id`: 카테고리 식별자 (예: 'SALARY')
/// - `name`: 사용자에게 표시되는 카테고리 이름
/// - `icon`: 아이콘 이미지 경로 (assets/images/...)
/// - `color`: 색상 16진수 문자열
class IncomeCategory {
  final String id;
  final String name;
  final String icon;
  final String color;

  const IncomeCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

/// 수입 카테고리 코드 상수
class IncomeCategoryCode {
  static const String salary = 'SALARY';
  static const String sideIncome = 'SIDE_INCOME';
  static const String allowance = 'ALLOWANCE';
  static const String bonus = 'BONUS';
  static const String investment = 'INVESTMENT';
  static const String other = 'OTHER';
}

/// 기본 수입 카테고리 상수
class DefaultIncomeCategories {
  static const String _basePath = 'assets/images/income';

  static final List<IncomeCategory> all = [
    IncomeCategory(
      id: IncomeCategoryCode.salary,
      name: '급여',
      icon: '$_basePath/icon_income_money.png',
      color: '10B981', // AppColors.income
    ),
    IncomeCategory(
      id: IncomeCategoryCode.sideIncome,
      name: '부수입',
      icon: '$_basePath/icon_income_coins.png',
      color: '2E7D32',
    ),
    IncomeCategory(
      id: IncomeCategoryCode.allowance,
      name: '용돈',
      icon: '$_basePath/icon_income_allowance.png',
      color: '8D6E63',
    ),
    IncomeCategory(
      id: IncomeCategoryCode.bonus,
      name: '상여금',
      icon: '$_basePath/icon_income_bonus.png',
      color: 'F57C00',
    ),
    IncomeCategory(
      id: IncomeCategoryCode.investment,
      name: '투자수익',
      icon: '$_basePath/icon_income_invest.png',
      color: '1565C0',
    ),
    IncomeCategory(
      id: IncomeCategoryCode.other,
      name: '기타',
      icon: '$_basePath/icon_elipsis.png',
      color: '6D4C41',
    ),
  ];
}
