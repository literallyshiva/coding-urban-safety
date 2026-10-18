import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences extends ChangeNotifier {
  AppPreferences._();
  static final instance = AppPreferences._();
  // One choice controls both palette and brightness. Beige is the default.
  String selectedTheme = 'beige';
  String language = 'en';
  static const themeColors = <String, Color>{
    'beige': Color(0xFF9B7553),
    'sage': Color(0xFF647C77),
    'ocean': Color(0xFF167C9C),
    'sunset': Color(0xFFB85D48),
    'lavender': Color(0xFF7656A8),
    'forest': Color(0xFF38765B),
    'dark-beige': Color(0xFFD6B28B),
    'dark-sage': Color(0xFF9BBEB0),
    'dark-ocean': Color(0xFF78C5DF),
    'dark-sunset': Color(0xFFF2A58C),
    'dark-lavender': Color(0xFFBEA4ED),
    'dark-forest': Color(0xFF8FCBA7),
  };
  Color get accent => themeColors[selectedTheme] ?? themeColors['beige']!;
  bool get isDark => selectedTheme.startsWith('dark-');
  ThemeMode get themeMode => isDark ? ThemeMode.dark : ThemeMode.light;

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    instance.language = prefs.getString('language') == 'ml' ? 'ml' : 'en';
    final stored = prefs.getString('selected_theme');
    if (stored != null && themeColors.containsKey(stored)) {
      instance.selectedTheme = stored;
    } else {
      // Migrate older palette/brightness choices without losing user preferences.
      final oldPalette = prefs.getString('color_palette');
      final oldMode = prefs.getString('theme_mode');
      if (oldPalette != null && themeColors.containsKey(oldPalette)) {
        final candidate = oldMode == 'dark' ? 'dark-$oldPalette' : oldPalette;
        instance.selectedTheme = themeColors.containsKey(candidate) ? candidate : 'beige';
      } else {
        instance.selectedTheme = 'beige';
      }
    }
  }
  Future<void> setSelectedTheme(String value) async {
    if (!themeColors.containsKey(value)) return;
    selectedTheme = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_theme', value);
  }
  Future<void> setLanguage(String value) async {
    language = value; notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', value);
  }
  String tr(String en, String ml) => language == 'ml' ? ml : en;
}
