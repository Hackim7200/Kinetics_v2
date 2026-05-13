import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_frontend/app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const KineticsApp());
}
