import 'package:flutter/material.dart' as material;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core.dart';

class SettingsCubit extends Cubit<material.ThemeMode> {
  SettingsCubit() : super(material.ThemeMode.light) {
    loadTheme();
  }

  Future<void> loadTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isDarkMode = prefs.getBool(AppConstants.SP_THEME_FLAG) ?? false;
    emit(isDarkMode ? material.ThemeMode.dark : material.ThemeMode.light);
  }

  Future<void> toggleTheme() async {
    if (state == material.ThemeMode.light) {
      emit(material.ThemeMode.dark);
      await _saveTheme(true);
    } else {
      emit(material.ThemeMode.light);
      await _saveTheme(false);
    }
  }

  Future<void> _saveTheme(bool isDarkMode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.SP_THEME_FLAG, isDarkMode);
  }
}
