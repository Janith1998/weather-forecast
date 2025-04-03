import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const _keyThemeMode = 'theme_mode';

  late ThemeMode _themeMode;
  late SharedPreferences _prefs;

  ThemeMode get themeMode => _themeMode;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final savedMode = _prefs.getString(_keyThemeMode) ?? 'light';
    _themeMode = savedMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> toggleTheme() async {
    _themeMode =
        _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await _prefs.setString(
      _keyThemeMode,
      _themeMode == ThemeMode.dark ? 'dark' : 'light',
    );
  }
}
