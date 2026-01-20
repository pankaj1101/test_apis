import 'package:client/core/services/session_manager.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      // ✅ Load tokens/user from SharedPref
      await SessionManager.instance.initSession();

      if (!mounted) return;

      // ✅ Navigate based on login status
      if (SessionManager.instance.isLoggedIn) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          "/dashboard",
          (route) => false,
        );
      } else {
        Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
      }
    } catch (e) {
      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              "Loading...",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
