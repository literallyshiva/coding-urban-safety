import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences extends ChangeNotifier {
  AppPreferences._();
  static final instance = AppPreferences._();
  ThemeMode themeMode = ThemeMode.system;
  String language = 'en';
  String colorPalette = 'sage';
  static const palettes = <String, Color>{
    'sage': Color(0xFF647C77),
    'ocean': Color(0xFF167C9C),
    'sunset': Color(0xFFB85D48),
    'lavender': Color(0xFF7656A8),
    'forest': Color(0xFF38765B),
  };
  Color get accent => palettes[colorPalette] ?? palettes['sage']!;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    instance.themeMode = ThemeMode.values.firstWhere(
      (m) => m.name == prefs.getString('theme_mode'), orElse: () => ThemeMode.system);
    instance.language = prefs.getString('language') == 'ml' ? 'ml' : 'en';
    final palette = prefs.getString('color_palette');
    instance.colorPalette = palettes.containsKey(palette) ? palette! : 'sage';
  }
  Future<void> setTheme(ThemeMode value) async {
    themeMode = value; notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_mode', value.name);
  }
  Future<void> setPalette(String value) async {
    if (!palettes.containsKey(value)) return;
    colorPalette = value; notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('color_palette', value);
  }
  Future<void> setLanguage(String value) async {
    language = value; notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', value);
  }
  String tr(String en, String ml) => language == 'ml' ? ml : en;
}
