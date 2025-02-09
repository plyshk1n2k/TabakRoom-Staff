import 'package:flutter/material.dart';
import 'package:tabakroom_staff/services/app_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false; // Переменная для хранения текущей темы

  bool get isDarkMode => _isDarkMode;

  // Конструктор, который загружает предпочтение пользователя по теме из SharedPreferences
  ThemeProvider() {
    _loadThemePreference();
  }

  // Метод для загрузки предпочтений о теме (светлая/тёмная) из SharedPreferences
  Future<void> _loadThemePreference() async {
    _isDarkMode = await AppPreferences.getValue<bool>('isDarkMode') ??
        true; // Если нет предпочтений, по умолчанию светлая тема
    notifyListeners(); // Уведомление слушателей о том, что тема изменилась
  }

  // Метод для переключения темы и сохранения в SharedPreferences
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await AppPreferences.setValue<bool>(
        'isDarkMode', _isDarkMode); // Сохраняем новый выбор темы
    notifyListeners(); // Уведомление слушателей о том, что тема изменилась
  }
}
