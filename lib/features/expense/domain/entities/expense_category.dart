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
    ExpenseCategory(id: 'FOOD', name: '식비', icon: 'restaurant', color: 'EF6C00'),
    ExpenseCategory(id: 'CAFE_SNACK', name: '카페/간식', icon: 'local_cafe', color: '8D6E63'),
    ExpenseCategory(id: 'TRANSPORT', name: '교통', icon: 'directions_bus', color: '1E88E5'),
    ExpenseCategory(id: 'HOUSING', name: '주거', icon: 'home', color: '546E7A'),
    ExpenseCategory(id: 'COMMUNICATION', name: '통신/인터넷', icon: 'wifi', color: '3949AB'),
    ExpenseCategory(id: 'SUBSCRIPTION', name: '구독', icon: 'subscriptions', color: '7E57C2'),
    ExpenseCategory(id: 'LIVING', name: '생활', icon: 'home_repair_service', color: '43A047'),
    ExpenseCategory(id: 'SHOPPING', name: '쇼핑', icon: 'shopping_bag', color: 'EC407A'),
    ExpenseCategory(id: 'HEALTH', name: '건강', icon: 'medical_services', color: 'E53935'),
    ExpenseCategory(id: 'INSURANCE', name: '보험', icon: 'verified_user', color: '00897B'),
    ExpenseCategory(id: 'EDUCATION', name: '교육', icon: 'school', color: '5C6BC0'),
    ExpenseCategory(id: 'CULTURE', name: '문화', icon: 'movie', color: '8E24AA'),
    ExpenseCategory(id: 'TRAVEL', name: '여행', icon: 'flight_takeoff', color: '039BE5'),
    ExpenseCategory(id: 'PET', name: '반려동물', icon: 'pets', color: '6D4C41'),
    ExpenseCategory(id: 'GIFT', name: '선물', icon: 'card_giftcard', color: 'F06292'),
    ExpenseCategory(id: 'CONDOLENCE', name: '경조사', icon: 'volunteer_activism', color: '26A69A'),
    ExpenseCategory(id: 'UNCATEGORIZED', name: '미분류', icon: 'help_outline', color: '9E9E9E'),
  ];
}
