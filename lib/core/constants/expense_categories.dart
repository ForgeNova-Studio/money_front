/// 지출 카테고리 엔티티
/// 지출 카테고리 정보를 담는 엔티티 클래스.
///
/// 각 지출 카테고리의 고유 ID, 표시 이름, 아이콘(Key string), 색상(Hex code)을 관리합니다.
///
/// **주요 속성:**
/// - `id`: 카테고리 식별자 (예: 'FOOD', 'TRANSPORT')
/// - `name`: 사용자에게 표시되는 카테고리 이름
/// - `icon`: 아이콘 식별 문자열 (Material Icons 매핑용)
/// - `color`: 색상 16진수 문자열 (예: 'EF6C00')
///
/// **사용 예시:**
/// ```dart
/// const category = ExpenseCategory(
///   id: 'FOOD',
///   name: '식비',
///   icon: 'restaurant',
///   color: 'EF6C00',
/// );
/// ```
class ExpenseCategory {
  final String id;
  final String name;
  final String icon;
  final String color;

  const ExpenseCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}

/// 지출 카테고리 코드 상수
class ExpenseCategoryCode {
  static const String food = 'FOOD';
  static const String cafeSnack = 'CAFE_SNACK';
  static const String transport = 'TRANSPORT';
  static const String housing = 'HOUSING';
  static const String communication = 'COMMUNICATION';
  static const String subscription = 'SUBSCRIPTION';
  static const String living = 'LIVING';
  static const String shopping = 'SHOPPING';
  static const String health = 'HEALTH';
  static const String insurance = 'INSURANCE';
  static const String education = 'EDUCATION';
  static const String culture = 'CULTURE';
  static const String travel = 'TRAVEL';
  static const String pet = 'PET';
  static const String gift = 'GIFT';
  static const String condolence = 'CONDOLENCE';
  static const String uncategorized = 'UNCATEGORIZED';
}

/// 기본 카테고리 상수
/// 앱에서 기본으로 제공하는 지출 카테고리 목록을 정의하는 클래스.
///
/// 초기 설정이나 카테고리 리셋 시 사용되는 프리셋 데이터를 포함합니다.
/// 식비, 교통, 주거 등 일반적인 가계부 카테고리를 제공합니다.
///
/// **주요 기능:**
/// - **기본 카테고리 제공**: `all` 리스트를 통해 전체 기본 카테고리에 접근 가능.
///
/// **사용 예시:**
/// ```dart
/// final defaultCategories = DefaultExpenseCategories.all;
/// ```
class DefaultExpenseCategories {
  static final List<ExpenseCategory> all = [
    ExpenseCategory(
        id: ExpenseCategoryCode.food,
        name: '식비',
        icon: 'restaurant',
        color: 'EF6C00'),
    ExpenseCategory(
        id: ExpenseCategoryCode.cafeSnack,
        name: '카페/간식',
        icon: 'local_cafe',
        color: '8D6E63'),
    ExpenseCategory(
        id: ExpenseCategoryCode.transport,
        name: '교통',
        icon: 'directions_bus',
        color: '1E88E5'),
    ExpenseCategory(
        id: ExpenseCategoryCode.housing,
        name: '주거',
        icon: 'home',
        color: '546E7A'),
    ExpenseCategory(
        id: ExpenseCategoryCode.communication,
        name: '통신/인터넷',
        icon: 'wifi',
        color: '3949AB'),
    ExpenseCategory(
        id: ExpenseCategoryCode.subscription,
        name: '구독',
        icon: 'subscriptions',
        color: '7E57C2'),
    ExpenseCategory(
        id: ExpenseCategoryCode.living,
        name: '생활',
        icon: 'home_repair_service',
        color: '43A047'),
    ExpenseCategory(
        id: ExpenseCategoryCode.shopping,
        name: '쇼핑',
        icon: 'shopping_bag',
        color: 'EC407A'),
    ExpenseCategory(
        id: ExpenseCategoryCode.health,
        name: '건강',
        icon: 'medical_services',
        color: 'E53935'),
    ExpenseCategory(
        id: ExpenseCategoryCode.insurance,
        name: '보험',
        icon: 'verified_user',
        color: '00897B'),
    ExpenseCategory(
        id: ExpenseCategoryCode.education,
        name: '교육',
        icon: 'school',
        color: '5C6BC0'),
    ExpenseCategory(
        id: ExpenseCategoryCode.culture,
        name: '문화',
        icon: 'movie',
        color: '8E24AA'),
    ExpenseCategory(
        id: ExpenseCategoryCode.travel,
        name: '여행',
        icon: 'flight_takeoff',
        color: '039BE5'),
    ExpenseCategory(
        id: ExpenseCategoryCode.pet,
        name: '반려동물',
        icon: 'pets',
        color: '6D4C41'),
    ExpenseCategory(
        id: ExpenseCategoryCode.gift,
        name: '선물',
        icon: 'card_giftcard',
        color: 'F06292'),
    ExpenseCategory(
        id: ExpenseCategoryCode.condolence,
        name: '경조사',
        icon: 'volunteer_activism',
        color: '26A69A'),
    ExpenseCategory(
        id: ExpenseCategoryCode.uncategorized,
        name: '미분류',
        icon: 'help_outline',
        color: '9E9E9E'),
  ];
}
