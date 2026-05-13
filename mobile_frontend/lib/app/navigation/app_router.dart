// import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_frontend/app/navigation/main_shell.dart';
import 'package:mobile_frontend/feature/auth/screens/onboarding_screen.dart';
import 'package:mobile_frontend/feature/auth/screens/sign_in_screen.dart';


/// Global [GoRouter] for the app.
///
/// **Optional auth:** users can use [MainShell] at `/home` without signing in.
/// Sign-in exists for sync (and similar) when the backend is wired — keep the
/// main shell reachable without credentials; gate only sync-sensitive flows
/// or APIs, not `/home` itself.
///
/// When Amplify is on, avoid wrapping the whole shell in [AuthenticatedView]
/// unless the product requires a hard login wall.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
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

    // Protected when using Amplify — wrap child in [AuthenticatedView].
    GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return const MainShell();
        // return const AuthenticatedView(
        //   child: MainShell(),
        // );
      },
    ),
  ],
);
