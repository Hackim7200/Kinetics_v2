

import 'package:shared_preferences/shared_preferences.dart';

const _kOnboardingComplete = 'onboarding_complete';

/// Persists whether the user has finished the one-time onboarding flow.
class OnboardingPrefs {
  static Future<bool> isComplete() async {
    final p = await SharedPreferences.getInstance();
    return p.getBool(_kOnboardingComplete) ?? false;
  }

  static Future<void> setComplete() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool(_kOnboardingComplete, true);
  }
}
