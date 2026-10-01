import 'package:flutter/material.dart';
import '../../features/auth/splash_screen.dart';
import '../../features/auth/onboarding_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../features/home/student_home_screen.dart';
import '../../admin/dashboard/admin_dashboard_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String studentHome = '/student_home';
  static const String adminDashboard = '/admin_dashboard';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        onboarding: (context) => const OnboardingScreen(),
        login: (context) => const LoginScreen(),
        studentHome: (context) => const StudentHomeScreen(),
        adminDashboard: (context) => const AdminDashboardScreen(),
      };
}
