/// API 엔드포인트 상수를 관리하는 클래스.
///
/// 애플리케이션 전체에서 사용되는 모든 백엔드 API 경로를 중앙집중식으로 정의합니다.
/// 기본 URL(Base URL)과 각 도메인별(인증, 사용자, 지출, 수입 등) 엔드포인트를 제공합니다.
///
/// **주요 기능:**
/// - **Base URL 관리**: `API_BASE_URL` 환경 변수를 통해 빌드 시점 또는 실행 시점에 베이스 URL 주입 가능.
/// - **정적 엔드포인트**: 로그인, 회원가입 등 고정된 API 경로 상수 제공.
/// - **동적 경로 생성**: ID 등을 인자로 받아 동적인 API 경로를 생성하는 헬퍼 메서드 제공.
///
/// **사용 예시:**
/// ```dart
/// // 기본 로그인 URL 사용
/// final loginUrl = ApiConstants.baseUrl + ApiConstants.login;
///
/// // ID를 포함한 동적 경로 사용
/// final detailUrl = ApiConstants.baseUrl + ApiConstants.expenseById('123');
/// ```
class ApiConstants {
  // Base URL
  // 빌드 시 --dart-define=API_BASE_URL=... 로 주입
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.moamoa.forgenova-lab.xyz',
  );

  // ========== Auth endpoints ==========
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String currentUser = '/api/auth/me';
  static const String refreshToken = '/api/auth/refresh';
  static const String socialLogin = '/api/auth/social-login';
  static const String mockSocialLogin = '/api/auth/social-login/mock';
  static const String sendSignupCode = '/api/auth/send-signup-code';
  static const String verifySignupCode = '/api/auth/verify-signup-code';
  static const String sendPasswordResetCode =
      '/api/auth/reset-password/send-code';
  static const String verifyResetPasswordCode =
      '/api/auth/reset-password/verify-code';
  static const String resetPassword = '/api/auth/reset-password';
  static const String authHealth = '/api/auth/health';
  // 개발용
  static const String devGetUserByEmail = '/api/auth/dev/users';
  static const String devDeleteUser = '/api/auth/dev/users';
  static const String devGetAllUsers = '/api/auth/dev/users/all';
  static const String logout = '/api/auth/logout';

  // ========== User endpoints ==========
  static const String usersMe = '/api/users/me';

  // ========== Terms endpoints ==========
  static const String termsActive = '/api/terms/active';
  static const String userAgreements = '/api/users/me/agreements';
  static const String marketingConsent = '/api/users/me/marketing-consent';

  // ========== Home endpoints ==========
  static const String homeMonthlyData = '/api/home/monthly-data';

  // ========== Expense endpoints ==========
  static const String expenses = '/api/expenses';
  static const String expensesRecent = '/api/expenses/recent';
  static const String expensesOcr = '/api/expenses/ocr';
  // 동적 경로: /api/expenses/{expenseId}
  static String expenseById(String expenseId) => '/api/expenses/$expenseId';

  // ========== Income endpoints ==========
  static const String incomes = '/api/incomes';
  static const String incomesRecent = '/api/incomes/recent';
  // 동적 경로: /api/incomes/{incomeId}
  static String incomeById(String incomeId) => '/api/incomes/$incomeId';

  // ========== Budget endpoints ==========
  static const String budgets = '/api/budgets';
  // 동적 경로: /api/budgets/{budgetId}
  static String budgetById(String budgetId) => '/api/budgets/$budgetId';

  // ========== Statistics endpoints ==========
  static const String statisticsMonthly = '/api/statistics/monthly';
  static const String statisticsCategoryComparison =
      '/api/statistics/monthly/category-comparison';
  static const String statisticsWeekly = '/api/statistics/weekly';
  static const String statisticsAssets = '/api/statistics/assets';

  // ========== Couple endpoints ==========
  static const String couplesInvite = '/api/couples/invite';
  static const String couplesJoin = '/api/couples/join';
  static const String couplesUnlink = '/api/couples/unlink';
  static const String couplesMe = '/api/couples/me';

  // ========== Recurring Expense endpoints ==========
  static const String recurringExpenses = '/api/recurring-expenses';
  static const String recurringExpensesActive =
      '/api/recurring-expenses/active';
  static const String recurringExpensesSubscriptions =
      '/api/recurring-expenses/subscriptions';
  static const String recurringExpensesUpcoming =
      '/api/recurring-expenses/upcoming';
  static const String recurringExpensesMonthlyTotal =
      '/api/recurring-expenses/monthly-total';
  static const String recurringExpensesDetectSubscriptions =
      '/api/recurring-expenses/detect-subscriptions';
  // 동적 경로: /api/recurring-expenses/{recurringExpenseId}
  static String recurringExpenseById(String recurringExpenseId) =>
      '/api/recurring-expenses/$recurringExpenseId';

  // ========== Asset endpoints ==========
  static const String assets = '/api/assets';
  static const String assetsSummary = '/api/assets/summary';
  // 동적 경로: /api/assets/{assetId}
  static String assetById(String assetId) => '/api/assets/$assetId';

  // ========== AccountBook endpoints ==========
  static const String accountBooks = '/api/account-books';
  // 동적 경로: /api/account-books/{accountBookId}
  static String accountBookById(String accountBookId) =>
      '/api/account-books/$accountBookId';
  // 동적 경로: /api/account-books/{accountBookId}/members
  static String accountBookMembers(String accountBookId) =>
      '/api/account-books/$accountBookId/members';

  // ========== Notification endpoints ==========
  static const String notifications = '/api/notifications';
  static const String notificationsUnreadCount =
      '/api/notifications/unread-count';
  static const String notificationsSendAll = '/api/notifications/send-all';
  // 동적 경로: /api/notifications/{notificationId}/read
  static String notificationMarkAsRead(String notificationId) =>
      '/api/notifications/$notificationId/read';
}
