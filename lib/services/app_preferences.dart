import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Сохранение любого значения
  static Future<void> setValue<T>(String key, T value) async {
    if (value is String) {
      await _prefs.setString(key, value);
    } else if (value is int) {
      await _prefs.setInt(key, value);
    } else if (value is bool) {
      await _prefs.setBool(key, value);
    } else if (value is double) {
      await _prefs.setDouble(key, value);
    } else if (value is List<String>) {
      await _prefs.setStringList(key, value);
    } else if (value is Map<String, dynamic>) {
      await _prefs.setString(key, jsonEncode(value));
    } else {
      throw ArgumentError('Unsupported type');
    }
  }

  // Загрузка значения
  static Future<T?> getValue<T>(String key) async {
    if (T == String) {
      return _prefs.getString(key) as T?;
    } else if (T == int) {
      return _prefs.getInt(key) as T?;
    } else if (T == bool) {
      return _prefs.getBool(key) as T?;
    } else if (T == double) {
      return _prefs.getDouble(key) as T?;
    } else if (T == List<String>) {
      return _prefs.getStringList(key) as T?;
    } else if (T == Map<String, dynamic>) {
      final jsonString = _prefs.getString(key);
      if (jsonString != null) {
        return jsonDecode(jsonString) as T?;
      }
    }
    return null;
  }

  /// Удаление значения
  static Future<void> remove(String key) async {
    await _prefs.remove(key);
  }

  /// Очистка всех данных
  static Future<void> clear() async {
    await _prefs.clear();
  }
}
