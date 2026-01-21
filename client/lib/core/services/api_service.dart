import 'dart:async';
import 'dart:convert';

import 'package:client/core/services/api_endpoint.dart';
import 'package:client/core/services/app_navigator.dart';
import 'package:client/core/services/session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:loggy/loggy.dart';

import '../services/pref_service.dart';

class ApiClient with UiLoggy {
  ApiClient._();
  static final ApiClient instance = ApiClient._();
  static bool _isRefreshing = false;
  static Completer<bool>? _refreshCompleter;

  final String baseUrl = ApiEndpoint.baseUrl;

  Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse(endpoint);

    final accessToken = await PrefService.getAccessToken();
    final headers = _headers(token: accessToken);

    http.Response response = await http.get(uri, headers: headers);
    _log(uri.toString(), jsonEncode(headers), "GET", "", response);

    // If access token expired
    if (response.statusCode == 401) {
      final refreshed = await _refreshToken();

      // Navigate to login if refresh failed
      if (!refreshed) {
        await SessionManager.instance.logout();
        AppNavigator.navKey.currentState?.pushNamedAndRemoveUntil(
          "/login",
          (route) => false,
        );
        throw Exception("Session expired. Please login again.");
      }

      // Retry after refresh
      final newToken = await PrefService.getAccessToken();
      final newHeaders = _headers(token: newToken);

      response = await http.get(uri, headers: newHeaders);
      _log(
        uri.toString(),
        jsonEncode(newHeaders),
        "GET (Retry After Refresh)",
        "",
        response,
      );
    }

    return _handleResponse(response);
  }

  // ✅ MAIN POST METHOD WITH AUTO REFRESH
  Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool authRequired = true,
  }) async {
    final uri = Uri.parse(endpoint);

    String? accessToken;
    if (authRequired) accessToken = await PrefService.getAccessToken();

    final headers = _headers(token: accessToken);

    http.Response response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );

    _log(
      uri.toString(),
      jsonEncode(headers),
      "POST",
      jsonEncode(body),
      response,
    );

    // If access token expired
    if (response.statusCode == 401 && authRequired) {
      final refreshed = await _refreshToken();

      if (!refreshed) {
        throw Exception("Session expired. Please login again.");
      }

      final newToken = await PrefService.getAccessToken();
      final newHeaders = _headers(token: newToken);

      // Retry after refresh
      response = await http.post(
        uri,
        headers: newHeaders,
        body: jsonEncode(body),
      );

      _log(
        uri.toString(),
        jsonEncode(newHeaders),
        "POST (Retry After Refresh)",
        jsonEncode(body),
        response,
      );
    }

    return _handleResponse(response);
  }

  Map<String, String> _headers({String? token}) {
    final headers = <String, String>{"Content-Type": "application/json"};

    if (token != null && token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }

    return headers;
  }

  dynamic _handleResponse(http.Response response) {
    final data = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    final message = (data is Map && data["message"] != null)
        ? data["message"]
        : "Error";

    throw Exception("(${response.statusCode}) $message");
  }

  Future<bool> _refreshToken() async {
    if (_isRefreshing) {
      return await (_refreshCompleter?.future ?? Future.value(false));
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<bool>();

    try {
      final refreshToken = await PrefService.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        _refreshCompleter!.complete(false);
        return false;
      }

      final uri = Uri.parse(ApiEndpoint.refreshToken);

      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"refresh_token": refreshToken}),
      );

      _log(
        uri.toString(),
        jsonEncode({"Content-Type": "application/json"}),
        "POST (Refresh Token)",
        jsonEncode({"refresh_token": refreshToken}),
        response,
      );

      if (response.statusCode != 200) {
        _refreshCompleter!.complete(false);
        return false;
      }

      final json = jsonDecode(response.body);

      final newAccessToken = json["access_token"];
      final newRefreshToken = json["refresh_token"];

      if (newAccessToken == null) {
        _refreshCompleter!.complete(false);
        return false;
      }

      await PrefService.saveTokens(
        accessToken: newAccessToken.toString(),
        refreshToken: (newRefreshToken ?? "").toString(),
      );

      _refreshCompleter!.complete(true);
      return true;
    } catch (e, s) {
      loggy.error("Refresh token failed", e, s);
      _refreshCompleter?.complete(false);
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  void _log(
    String uri,
    String headers,
    String method,
    String data,
    http.Response response,
  ) {
    loggy.info('**********************************');
    loggy.info('Request URL :: $uri');
    loggy.info('Request Headers :: $headers');
    loggy.info('Request Method :: $method');
    loggy.info('Request Data :: $data');
    loggy.info('Status Code :: ${response.statusCode}');
    loggy.info('Response Body :: ${response.body}');
    loggy.info('**********************************');
  }
}
