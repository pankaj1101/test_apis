import 'dart:ui';

import 'package:client/services/api_endpoint.dart';
import 'package:client/services/app_navigator.dart';
import 'package:client/services/auth_api_service.dart';
import 'package:client/services/pref_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  static bool _isRefreshing = false;
  static final List<VoidCallback> _retryQueue = [];

  static final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: ApiEndpoint.baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
            headers: {"Content-Type": "application/json"},
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) async {
              final token = await PrefService.getAccessToken();

              final skipAuth =
                  options.path.contains("/login") ||
                  options.path.contains("/refresh-token");

              if (!skipAuth && token != null && token.isNotEmpty) {
                options.headers["Authorization"] = "Bearer $token";
              }

              handler.next(options);
            },
            onError: (DioException error, handler) async {
              final statusCode = error.response?.statusCode;
              final requestOptions = error.requestOptions;

              final isRefreshCall = requestOptions.path.contains(
                ApiEndpoint.refreshToken,
              );

              if (isRefreshCall) {
                await PrefService.clearAll();
                return handler.next(error);
              }

              if (statusCode == 401) {
                if (_isRefreshing) {
                  _retryQueue.add(() async {
                    final newToken = await PrefService.getAccessToken();

                    requestOptions.headers["Authorization"] =
                        "Bearer $newToken";
                    
                    final response = await dio.fetch(requestOptions);
                    handler.resolve(response);
                  });
                  return;
                }

                _isRefreshing = true;

                try {
                  final authApi = AuthApiService();
                  final refreshResponse = await authApi.refreshTokenApiCall();

                  final newAccessToken = refreshResponse["access_token"];
                  final newRefreshToken = refreshResponse["refresh_token"];

                  if (newAccessToken == null ||
                      newAccessToken.toString().isEmpty) {
                    throw Exception("Refresh failed (no access_token)");
                  }

                  await PrefService.saveTokens(
                    accessToken: newAccessToken.toString(),
                    refreshToken: (newRefreshToken ?? "").toString(),
                  );

                  // ✅ retry original request
                  requestOptions.headers["Authorization"] =
                      "Bearer ${newAccessToken.toString()}";

                  final retryResponse = await dio.fetch(requestOptions);

                  // ✅ retry queued requests
                  for (final retry in _retryQueue) {
                    retry();
                  }
                  _retryQueue.clear();

                  return handler.resolve(retryResponse);
                } catch (e) {
                  _retryQueue.clear();
                  await PrefService.clearAll();
                  AppNavigator.navKey.currentState?.pushNamedAndRemoveUntil(
                    ApiEndpoint.login,
                    (route) => false,
                  );
                  return handler.next(error);
                } finally {
                  _isRefreshing = false;
                }
              }

              handler.next(error);
            },
          ),
        )
        ..interceptors.add(
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseHeader: true,
            responseBody: true,
            error: true,
          ),
        );
}
