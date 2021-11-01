import 'package:shared_preferences/shared_preferences.dart';

const PREF_KEY = "isDarkOn";

class ThemeChangeRepository {

  static bool isDarkOn = false;

  Future<void> setTheme(bool isDark) async {
    print("setTheme in repo start: $isDark");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(PREF_KEY, isDark);
    isDarkOn = isDark;
    print("setTheme in repo end: $isDarkOn");
  }

  Future<void> getIsDarkOn() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkOn = prefs.getBool(PREF_KEY) ?? true;
  }

}
