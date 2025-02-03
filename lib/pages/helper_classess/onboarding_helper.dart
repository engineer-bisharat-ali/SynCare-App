import 'package:shared_preferences/shared_preferences.dart';

class OnboardingHelper {
  static const String _onboardingKey = 'onboarding_completed';

  // ----------------------------
  //Method for to check isOnboarding is completed
  // ----------------------------
  static Future<bool> isOnboardingCompleted() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Check if the key exists (false for fresh installs)
    bool keyExists = prefs.containsKey(_onboardingKey);
    if (!keyExists) {
      await prefs.setBool(_onboardingKey, false); // Initialize to false
    }
    return prefs.getBool(_onboardingKey) ?? false;
  }

  // ----------------------------
  //Method for to set flag for Onboarding screen
  // ----------------------------
  static Future<void> setOnboardingCompleted(bool flag) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, flag);
  }
}
