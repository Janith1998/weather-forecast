// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class ThemeService {
//   static const _keyThemeMode = 'theme_mode';

//   late ThemeMode _themeMode;
//   late SharedPreferences _prefs;

//   ThemeMode get themeMode => _themeMode;

//   Future<void> init() async {
//     _prefs = await SharedPreferences.getInstance();
//     final savedMode = _prefs.getString(_keyThemeMode) ?? 'light';
//     _themeMode = savedMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
//   }

//   Future<void> toggleTheme() async {
//     _themeMode =
//         _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
//     await _prefs.setString(
//       _keyThemeMode,
//       _themeMode == ThemeMode.dark ? 'dark' : 'light',
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const _keyThemeMode = 'theme_mode';

  final _themeController = StreamController<ThemeMode>.broadcast();
  ThemeMode _currentTheme = ThemeMode.light;

  Stream<ThemeMode> get themeStream => _themeController.stream;
  ThemeMode get currentTheme => _currentTheme;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getString(_keyThemeMode) ?? 'light';
    _currentTheme = savedMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
    _themeController.add(_currentTheme);
  }

  Future<void> toggleTheme() async {
    _currentTheme =
        _currentTheme == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _keyThemeMode,
      _currentTheme == ThemeMode.dark ? 'dark' : 'light',
    );
    _themeController.add(_currentTheme);
  }

  void dispose() {
    _themeController.close();
  }
}
