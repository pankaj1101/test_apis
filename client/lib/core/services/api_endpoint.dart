class ApiEndpoint {
  ApiEndpoint._();

  static const String baseUrl = 'http://localhost:3000';

  // For Android emulator use this
  // static const String baseUrl = 'http://10.0.2.2:3000';

  static const String login = '$baseUrl/api/login';
  static const String dashboardOverview = '$baseUrl/api/dashboard_overview';
  static const String recentTransaction = '$baseUrl/api/recent_transaction';
  static const String refreshToken = '$baseUrl/api/refresh-token';
}
