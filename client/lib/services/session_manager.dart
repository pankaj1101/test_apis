import 'pref_service.dart';

class SessionManager {
  SessionManager._();
  static final SessionManager instance = SessionManager._();

  String? accessToken;
  String? refreshToken;

  bool get isLoggedIn => accessToken != null;

  Future<void> initSession() async {
    accessToken = await PrefService.getAccessToken();
    refreshToken = await PrefService.getRefreshToken();
  }

  Future<void> logout() async {
    accessToken = null;
    refreshToken = null;
    await PrefService.clearAll();
  }
}
