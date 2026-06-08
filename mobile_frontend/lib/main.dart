import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_frontend/app/navigation/app_router.dart';
import 'package:mobile_frontend/app/themes/app_theme.dart';
import 'package:mobile_frontend/database/database.dart';
import 'package:mobile_frontend/database/database_provider.dart';
import 'package:mobile_frontend/feature/auth/data/repositories/onboarding_repository.dart';
import 'package:mobile_frontend/feature/auth/data/sources/onboarding_local_source.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final onboardingRepository = OnboardingRepository(OnboardingLocalSource());
  final onboardingComplete = await onboardingRepository.isComplete();
  final db = await _initDatabase();
  final router = createAppRouter(onboardingComplete: onboardingComplete);

  runApp(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: MyApp(router: router),
    ),
  );
}

Future<AppDatabase> _initDatabase() async {
  final Directory appDocDir = await getApplicationDocumentsDirectory();
  final Directory dbDir = Directory('${appDocDir.path}/db');

  if (!await dbDir.exists()) {
    await dbDir.create();
  }

  return AppDatabase(dbDirectory: dbDir, sqliteFileName: 'app.db');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Kinetics',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
