import 'package:flutter/material.dart';

// Route Constants
class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String onboarding = '/onboarding';
  static const String notifications = '/notifications';
  static const String manageRestaurant = '/manage-restaurant';
  static const String manageStaff = '/manage-staff';
  static const String editStaff = '/edit-staff';
}

// UI String Constants
class UIStrings {
  static const String appTitle = 'Restaurant App';

  // Auth Screens
  static const String loginTitle = 'Login';
  static const String registerTitle = 'Register';
  static const String forgotPasswordTitle = 'Forgot Password';

  static const String emailLabel = 'Email';
  static const String passwordLabel = 'Password';

  static const String displayNameLabel = 'Display Name';
  static const String confirmPasswordLabel = 'Confirm Password';

  static const String loginButton = 'Login';
  static const String registerButton = 'Register';
  static const String resetButton = 'Reset Password';

  static const String dontHaveAccount = 'Don\'t have an account? Register';
  static const String alreadyHaveAccount = 'Already have an account? Login';
  static const String forgotPasswordPrompt = 'Forgot Password?';
}

// You can also add color and style constants here
class AppColors {
  static const Color primary = Colors.orange;
  static const Color error = Colors.redAccent;
}

class DBConstants {
  static const String usersCollection = 'users';
}
