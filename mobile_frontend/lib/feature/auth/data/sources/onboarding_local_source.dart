import 'package:shared_preferences/shared_preferences.dart';

const _onboardingCompleteKey = 'onboarding_complete';

/// Raw SharedPreferences access for onboarding completion flag.
class OnboardingLocalSource {
  Future<bool> isOnboardingComplete() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool(_onboardingCompleteKey) ?? false;
  }

  Future<void> setOnboardingComplete() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_onboardingCompleteKey, true);
  }
}
