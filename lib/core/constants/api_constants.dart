class ApiConstants {
  // Base URL
  // 로컬 개발: 맥의 IP 주소 사용 (아이폰에서 접근 가능)
  static const String baseUrl = 'http://localhost:8080';
  // static const String baseUrl = 'http://172.20.10.3:8080';

  // ========== Auth endpoints ==========
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String currentUser = '/api/auth/me';
  static const String socialLogin = '/api/auth/social-login';
  static const String mockSocialLogin = '/api/auth/social-login/mock';
  static const String sendSignupCode = '/api/auth/send-signup-code';
  static const String verifySignupCode = '/api/auth/verify-signup-code';
  static const String sendPasswordResetCode =
      '/api/auth/reset-password/send-code';
  static const String verifyResetPasswordCode =
      '/api/auth/verify-reset-password-code';
  static const String resetPassword = '/api/auth/reset-password';
  static const String authHealth = '/api/auth/health';
  // 개발용
  static const String devGetUserByEmail = '/api/auth/dev/users';
  static const String devDeleteUser = '/api/auth/dev/users';

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
}
