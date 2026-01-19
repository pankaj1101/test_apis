import 'package:client/model/dashboard_overview.dart';
import 'package:client/model/login_response_model.dart';
import 'package:client/model/recent_transaction.dart';
import 'package:client/services/api_endpoint.dart';
import 'package:client/services/pref_service.dart';
import 'package:dio/dio.dart';
import 'dio_client.dart';

class AuthApiService {
  Future<LoginResponseModel> loginWithMobilePassword({
    required String mobile,
    required String password,
  }) async {
    try {
      final Response response = await DioClient.dio.post(
        ApiEndpoint.login,
        data: {"mobile": mobile, "password": password},
      );

      return LoginResponseModel.fromJson(response.data);
    } on DioException catch (e) {
      final msg = e.response?.data?["message"] ?? e.message ?? "Login failed";
      throw Exception(msg);
    }
  }

  Future<DashboardOverview> dashboardOverview() async {
    try {
      final Response response = await DioClient.dio.get(
        ApiEndpoint.dashboardOverview,
      );
      return DashboardOverview.fromJson(response.data);
    } on DioException catch (e) {
      final msg =
          e.response?.data?["message"] ??
          e.message ??
          "Failed to fetch overview";
      throw Exception(msg);
    }
  }

  Future<RecentTransactionModel> recentTransaction() async {
    try {
      final Response response = await DioClient.dio.get(
        ApiEndpoint.recentTransaction,
      );
      return RecentTransactionModel.fromJson(response.data);
    } on DioException catch (e) {
      final msg =
          e.response?.data?["message"] ??
          e.message ??
          "Failed to fetch recent transactions";
      throw Exception(msg);
    }
  }

  Future<Map<String, dynamic>> refreshTokenApiCall() async {
    try {
      final refreshToken = await PrefService.getRefreshToken();
      final Response response = await DioClient.dio.post(
        ApiEndpoint.refreshToken,
        data: {"refresh_token": refreshToken},
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      final msg =
          e.response?.data?["message"] ??
          e.message ??
          "Failed to refresh token";
      throw Exception(msg);
    }
  }
}
