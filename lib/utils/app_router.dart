import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:resto2/models/role_permission_model.dart';
import 'package:resto2/models/staff_model.dart';
import 'package:resto2/views/auth/splash_screen.dart'; // Import the new screen
import 'package:resto2/views/notifications/notification_page.dart';
import 'package:resto2/views/onboarding/onboarding_screen.dart';
import 'package:resto2/views/restaurant/master_restaurant_page.dart';
import 'package:resto2/views/staff/edit_staff_page.dart';
import 'package:resto2/views/staff/staff_management_page.dart';
import '../providers/auth_providers.dart';
import '../views/auth/forgot_password_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/register_screen.dart';
import '../views/home/home_screen.dart';
import 'constants.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateChangeProvider);
  final appUser = ref.watch(currentUserProvider);

  return GoRouter(
    initialLocation: '/', // Start at the splash screen
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationPage(),
      ),
      GoRoute(
        path: AppRoutes.manageRestaurant,
        builder: (context, state) => const MasterRestaurantPage(),
      ),
      GoRoute(
        path: AppRoutes.manageStaff,
        builder: (context, state) => const StaffManagementPage(),
      ),
      GoRoute(
        path: AppRoutes.editStaff,
        builder: (context, state) {
          final staff = state.extra as Staff;
          return EditStaffPage(staff: staff);
        },
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final onSplash = state.matchedLocation == '/';
      final userIsAuthenticating =
          state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register ||
          state.matchedLocation == AppRoutes.forgotPassword;

      // While providers are loading, stay on the splash screen.
      if (authState.isLoading ||
          (authState.value != null && appUser.isLoading)) {
        return onSplash ? null : '/';
      }

      final loggedIn = authState.hasValue && authState.value != null;

      // If the user is logged in, we need to determine where to go.
      if (loggedIn) {
        final hasRole =
            appUser.value?.role != null && appUser.value?.restaurantId != null;

        if (hasRole) {
          // If user has a role, redirect away from auth/onboarding/splash pages to home.
          if (userIsAuthenticating ||
              state.matchedLocation == AppRoutes.onboarding ||
              onSplash) {
            return AppRoutes.home;
          }
        } else {
          // If user has no role, redirect to onboarding unless they are already there or creating a restaurant.
          if (state.matchedLocation != AppRoutes.onboarding &&
              state.matchedLocation != AppRoutes.manageRestaurant) {
            return AppRoutes.onboarding;
          }
        }
      }
      // If the user is not logged in
      else {
        // Redirect from any protected page to the login screen.
        if (!userIsAuthenticating) {
          return AppRoutes.login;
        }
      }

      // No redirect needed for the current location.
      return null;
    },
  );
});
