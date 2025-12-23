/// 지출 카테고리 엔티티
class ExpenseCategory {
  final String id;
  final String name;
  final String icon;
  final String color;

  ExpenseCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

/// 기본 카테고리 상수
class DefaultCategories {
  static final List<ExpenseCategory> all = [
    ExpenseCategory(id: 'FOOD', name: '식비', icon: 'restaurant', color: 'FF5722'),
    ExpenseCategory(id: 'CAFE', name: '카페', icon: 'local_cafe', color: '795548'),
    ExpenseCategory(id: 'TRANSPORT', name: '교통', icon: 'directions_bus', color: '2196F3'),
    ExpenseCategory(id: 'SHOPPING', name: '쇼핑', icon: 'shopping_bag', color: 'E91E63'),
    ExpenseCategory(id: 'LIFE', name: '생활', icon: 'home', color: '4CAF50'),
    ExpenseCategory(id: 'CULTURE', name: '문화', icon: 'movie', color: '9C27B0'),
    ExpenseCategory(id: 'HEALTH', name: '의료/건강', icon: 'medical_services', color: 'F44336'),
    ExpenseCategory(id: 'EDUCATION', name: '교육', icon: 'school', color: '3F51B5'),
    ExpenseCategory(id: 'OTHER', name: '기타', icon: 'more_horiz', color: '9E9E9E'),
  ];
}
