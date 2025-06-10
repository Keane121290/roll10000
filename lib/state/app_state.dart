import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  Locale _locale = const Locale('en');
  ThemeMode _themeMode = ThemeMode.dark; // default to dark only

  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;

  AppState() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('locale') ?? 'en';
    _locale = Locale(langCode);
    _themeMode = ThemeMode.dark; // force dark theme for now
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = ThemeMode.dark; // lock to dark mode
    notifyListeners();
  }

  void toggleTheme() {
    // disabled
  }

  void setSystemDefault() {
    // disabled
  }

  void useSystemBrightness() {
    // disabled
  }
}
