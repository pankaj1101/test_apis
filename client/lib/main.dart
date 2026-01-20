import 'package:client/core/services/app_navigator.dart';
import 'package:client/core/services/session_manager.dart';
import 'package:client/view/dashboard_screen.dart';
import 'package:client/view/loading_screen.dart';
import 'package:client/view/login_screen.dart';
import 'package:client/view/profle_screen.dart';
import 'package:flutter/material.dart';
import 'package:loggy/loggy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SessionManager.instance.initSession();
  Loggy.initLoggy(logPrinter: const PrettyPrinter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web Login',
      navigatorKey: AppNavigator.navKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      routes: {
        "/login": (_) => const LoginScreen(),
        "/dashboard": (_) => const DashboardScreen(),
        "/profile": (_) => ProfileScreen(),
      },
      home: LoadingScreen(),
    );
  }
}
