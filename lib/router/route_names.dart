/// 앱 전체 라우트 경로 정의
class RouteNames {
  RouteNames._();

  // ==================== Splash Route ====================
  /// 스플래시 화면 (앱 초기화)
  static const String splash = '/splash';

  // ==================== Public Routes ====================
  /// 로그인 화면
  static const String login = '/login';

  /// 회원가입 화면
  static const String register = '/register';

  /// 비밀번호 찾기 화면
  static const String findPassword = '/find-password';

  /// 비밀번호 재설정 화면
  static const String resetPassword = '/reset-password';
  /// 온보딩 화면
  static const String onboarding = '/onboarding';

  // ==================== Protected Routes ====================
  /// 메인 홈 화면
  static const String home = '/home';

  // ==================== Expense Routes ====================
  /// 지출 목록 화면
  static const String expenses = '/expenses';

  /// 지출 추가 화면
  static const String addExpense = '/expenses/add';

  /// 지출 상세 화면 (동적 경로)
  static String expenseDetail(String id) => '/expenses/$id';

  /// 지출 수정 화면 (동적 경로)
  static String editExpense(String id) => '/expenses/$id/edit';

  // ==================== Income Routes ====================
  /// 수입 목록 화면
  static const String incomes = '/incomes';

  /// 수입 추가 화면
  static const String addIncome = '/incomes/add';

  /// 수입 상세 화면 (동적 경로)
  static String incomeDetail(String id) => '/incomes/$id';

  /// 수입 수정 화면 (동적 경로)
  static String editIncome(String id) => '/incomes/$id/edit';

  // ==================== Statistics Routes ====================
  /// 통계 화면
  static const String statistics = '/statistics';

  /// 주간 통계 화면
  static const String weeklyStatistics = '/statistics/weekly';

  // ==================== Budget Route ====================
  /// 예산 설정 화면
  static const String budget = '/budget';

  /// 예산 설정 화면 (월별)
  static const String budgetSettings = '/budget/settings';

  // ==================== Asset Route ====================
  /// 자산 화면
  static const String assets = '/assets';

  /// 초기 잔액 설정 화면
  static const String initialBalanceSettings = '/assets/initial-balance';

  // ==================== Couple Routes ====================
  /// 커플 메인 화면
  static const String couple = '/couple';

  /// 커플 초대 화면
  static const String coupleInvite = '/couple/invite';

  /// 커플 가입 화면
  static const String coupleJoin = '/couple/join';

  // ==================== Settings Route ====================
  /// 설정 화면
  static const String settings = '/settings';

  // ==================== AccountBook Routes ====================
  /// 가계부 생성 화면
  static const String accountBookCreate = '/account-books/create';

  // ==================== OCR Route ====================
  /// OCR 테스트 화면
  static const String ocrTest = '/ocr-test';

  // ==================== Helper Methods ====================
  /// 인증 화면 여부 확인
  static bool isAuthRoute(String location) {
    return location == login ||
        location == register ||
        location == findPassword ||
        location == resetPassword ||
        location == onboarding;
  }

  /// Public 화면 여부 확인 (인증 불필요)
  static bool isPublicRoute(String location) {
    return isAuthRoute(location);
  }

  /// Protected 화면 여부 확인 (인증 필요)
  static bool isProtectedRoute(String location) {
    return !isPublicRoute(location);
  }
}
