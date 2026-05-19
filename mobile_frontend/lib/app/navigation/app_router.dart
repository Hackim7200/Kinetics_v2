import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_frontend/app/navigation/app_shell.dart';
import 'package:mobile_frontend/database/database.dart';
import 'package:mobile_frontend/feature/auth/screens/onboarding_screen.dart';
import 'package:mobile_frontend/feature/auth/screens/sign_in_screen.dart';

/// Builds the app [GoRouter] (initial route depends on onboarding completion).
///
/// **Optional auth:** users can use [AppShell] at `/home` without signing in.
/// Sign-in exists for sync (and similar) when the backend is wired — keep the
/// main shell reachable without credentials; gate only sync-sensitive flows
/// or APIs, not `/home` itself.
///
GoRouter createAppRouter({
  required bool onboardingComplete,
  required AppDatabase db,
}) {
  return GoRouter(
    initialLocation: onboardingComplete ? '/home' : '/',
    routes: <RouteBase>[
      // Public — no auth
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const OnboardingScreen();
        },
      ),
      GoRoute(
        path: '/sign-in',
        builder: (BuildContext context, GoRouterState state) {
          return const SignInScreen();
        },
      ),

      GoRoute(
        path: '/home',
        builder: (BuildContext context, GoRouterState state) {
          return AppShell(db: db);
        },
      ),
    ],
  );
}
