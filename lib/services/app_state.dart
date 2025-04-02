import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState {
  static const _keyOnboardingComplete = 'onboarding_complete';

  static Future<bool> get isFirstLaunch async {
    final prefs = await SharedPreferences.getInstance();
    // More reliable first launch detection
    final isFirst = !prefs.containsKey(_keyOnboardingComplete);
    debugPrint('First launch check: $isFirst');
    return isFirst;
  }

  static Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingComplete, true);
    debugPrint('Onboarding marked as complete');
  }

  static Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyOnboardingComplete);
    debugPrint('Onboarding state reset');
  }
}
