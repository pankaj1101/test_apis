import 'package:client/core/services/api_endpoint.dart';
import 'package:client/core/services/api_service.dart';
import 'package:client/core/services/pref_service.dart';
import 'package:client/model/dashboard_overview.dart';
import 'package:client/model/login_response_model.dart';
import 'package:client/model/recent_transaction.dart';

class AuthApiService {
  Future<LoginResponseModel> loginWithMobilePassword({
    required String mobile,
    required String password,
  }) async {
    try {
      final response = await ApiClient.instance.post(ApiEndpoint.login, {
        "mobile": mobile,
        "password": password,
      });

      return LoginResponseModel.fromJson(response);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<DashboardOverview> dashboardOverview() async {
    try {
      final response = await ApiClient.instance.get(
        ApiEndpoint.dashboardOverview,
      );

      return DashboardOverview.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<RecentTransactionModel> recentTransaction() async {
    try {
      final response = await ApiClient.instance.get(
        ApiEndpoint.recentTransaction,
      );
      return RecentTransactionModel.fromJson(response);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> refreshTokenApiCall() async {
    try {
      final refreshToken = await PrefService.getRefreshToken();
      final response = await ApiClient.instance.post(ApiEndpoint.refreshToken, {
        "refresh_token": refreshToken,
      });
      return response as Map<String, dynamic>;
    } catch (e) {
      throw Exception(e);
    }
  }
}
