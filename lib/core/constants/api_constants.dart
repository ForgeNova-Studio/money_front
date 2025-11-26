class ApiConstants {
  // Base URL
  static const String baseUrl = 'http://localhost:8080';

  // Auth endpoints
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String socialLogin = '/api/auth/social-login';
  static const String refreshToken = '/api/auth/refresh';
  static const String logout = '/api/auth/logout';
  static const String currentUser = '/api/auth/me';
  static const String checkEmail = '/api/auth/check-email';

  // Expense endpoints
  static const String expenses = '/api/expenses';
  static const String expensesOcr = '/api/expenses/ocr';

  // Income endpoints
  static const String incomes = '/api/incomes';

  // Budget endpoints
  static const String budgets = '/api/budgets';

  // Statistics endpoints
  static const String statisticsUrl = '/api/statistics';
  static const String statisticsMonthly = '/api/statistics/monthly';
  static const String statisticsWeekly = '/api/statistics/weekly';

  // Couple endpoints
  static const String couplesInvite = '/api/couples/invite';
  static const String couplesJoin = '/api/couples/join';
}
