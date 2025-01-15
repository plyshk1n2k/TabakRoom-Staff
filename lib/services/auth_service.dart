import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabakroom_staff/models/api_response.dart';
import 'package:tabakroom_staff/services/api_service.dart';

class AuthService {
  static const _tokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  // Проверка токена
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  // Сохранение токена
  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Сохранение refresh токена
  static Future<void> saveRefreshToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, token);
  }

  // Удаление токена (выход)
  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // Получение токена
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

// Вход в систему
  static Future<ApiResponse<void>> login(
      String username, String password) async {
    try {
      final response = await ApiService.post(
          '/token/',
          {
            'username': username,
            'password': password,
          },
          rethrowError: false);

      // Проверка на наличие токена
      if (response.containsKey('access') && response.containsKey('refresh')) {
        await saveToken(response['access']);
        await saveRefreshToken(response['refresh']);
        return ApiResponse.success(response); // Успешный вход
      } else {
        return ApiResponse.error(
            'Ошибка авторизации: неверный логин или пароль');
      }
    } catch (e) {
      debugPrint('Ошибка авторизации: $e');
      return ApiResponse.error('Ошибка сети: $e');
    }
  }
}
