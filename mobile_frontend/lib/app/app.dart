import 'package:flutter/material.dart';

import 'themes/app_theme.dart';
import 'navigation/app_router.dart';

// import 'package:amplify_authenticator/amplify_authenticator.dart';

class KineticsApp extends StatelessWidget {
  const KineticsApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap with [Authenticator] when Amplify is enabled in [main.dart].
    // return Authenticator(
    //   child: MaterialApp.router(
    return MaterialApp.router(
      title: 'Overload Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
    //   ),
    // );
  }
}
