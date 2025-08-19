import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  // v1 (gammel): bool
  static const _themeKeyV1 = 'isDarkMode';
  // v2 (ny): string 'dark' | 'light'
  static const _themeKeyV2 = 'themeModeV2';
  static const _localeKey = 'locale';

  // ✅ default: dark (første oppstart)
  ThemeMode _themeMode = ThemeMode.dark;
  Locale _locale = const Locale('en');

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // --- Tema (v2 foretrukket) ---
    final modeStr = prefs.getString(_themeKeyV2);
    if (modeStr != null) {
      _themeMode = _parseThemeMode(modeStr);
    } else {
      // Bakoverkompatibilitet (v1)
      final v1 = prefs.getBool(_themeKeyV1);
      if (v1 != null) {
        _themeMode = v1 ? ThemeMode.dark : ThemeMode.light;
        // migrer til v2
        await prefs.setString(_themeKeyV2, _themeMode == ThemeMode.dark ? 'dark' : 'light');
      } else {
        // Første gang -> default mørk, skriv v2
        _themeMode = ThemeMode.dark;
        await prefs.setString(_themeKeyV2, 'dark');
      }
    }

    // --- Språk ---
    final localeCode = prefs.getString(_localeKey) ?? 'en';
    _locale = Locale(localeCode);

    notifyListeners();
  }

  ThemeMode _parseThemeMode(String s) {
    switch (s) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
      default:
        return ThemeMode.dark;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKeyV2, mode == ThemeMode.dark ? 'dark' : 'light');
    // (valgfritt) rydde v1-nøkkelen: await prefs.remove(_themeKeyV1);
    notifyListeners();
  }

  // Praktisk hvis du har en switch et sted
  Future<void> toggleTheme() async {
    await setThemeMode(_themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
    notifyListeners();
  }
}
