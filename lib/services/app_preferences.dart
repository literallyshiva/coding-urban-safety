import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences extends ChangeNotifier {
  AppPreferences._();
  static final instance = AppPreferences._();
  ThemeMode themeMode = ThemeMode.system;
  String language = 'en';
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    instance.themeMode = ThemeMode.values.firstWhere(
      (m) => m.name == prefs.getString('theme_mode'), orElse: () => ThemeMode.system);
    instance.language = prefs.getString('language') == 'ml' ? 'ml' : 'en';
  }
  Future<void> setTheme(ThemeMode value) async {
    themeMode = value; notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', value.name);
  }
  Future<void> setLanguage(String value) async {
    language = value; notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', value);
  }
  String tr(String en, String ml) => language == 'ml' ? ml : en;
}
