class ApiConstants {
  // Base URL
  // 빌드 시 --dart-define=API_BASE_URL=... 로 주입
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://158.179.166.233:80', // 서버ip이므로 수정X
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
  // 동적 경로: /api/notifications/{notificationId}/read
  static String notificationMarkAsRead(String notificationId) =>
      '/api/notifications/$notificationId/read';
}
