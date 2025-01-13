import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false; // Переменная для хранения текущей темы

  bool get isDarkMode => _isDarkMode;

  // Конструктор, который загружает предпочтение пользователя по теме из SharedPreferences
  ThemeProvider() {
    _loadThemePreference();
  }

  // Метод для загрузки предпочтений о теме (светлая/тёмная) из SharedPreferences
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ??
        true; // Если нет предпочтений, по умолчанию светлая тема
    notifyListeners(); // Уведомление слушателей о том, что тема изменилась
  }

  // Метод для переключения темы и сохранения в SharedPreferences
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode); // Сохраняем новый выбор темы
    notifyListeners(); // Уведомление слушателей о том, что тема изменилась
  }
}
