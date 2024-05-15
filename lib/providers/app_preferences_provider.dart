import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferencesProvider extends ChangeNotifier {
  var _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  Future<void> loadAsync() async {
    final sharedPref = await SharedPreferences.getInstance();

    _themeMode = ThemeMode.values.byName(
        sharedPref.getString("APP_THEME_MODE") ?? ThemeMode.system.name);

    notifyListeners();
  }

  Future<void> setThemeModeAsync({
    required ThemeMode themeMode,
    bool save = true,
  }) async {
    if (themeMode != _themeMode) {
      _themeMode = themeMode;

      if (save) {
        final sharedPref = await SharedPreferences.getInstance();

        await sharedPref.setString("APP_THEME_MODE", themeMode.name);
      }

      notifyListeners();
    }
  }
}
