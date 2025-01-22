import 'package:flutter/foundation.dart';
import 'package:tabakroom_staff/models/api_response.dart';
import 'package:tabakroom_staff/services/api_service.dart';
import 'package:tabakroom_staff/services/app_preferences.dart';

class AuthService {
  static const _tokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  // Проверка токена
  static Future<bool> isLoggedIn() async {
    String? token = await AppPreferences.getValue(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  // Сохранение токена
  static Future<void> saveToken(String token) async {
    await AppPreferences.setValue(_tokenKey, token);
  }

  // Сохранение refresh токена
  static Future<void> saveRefreshToken(String token) async {
    await AppPreferences.setValue(_refreshTokenKey, token);
  }

  // Удаление токена (выход)
  static Future<void> logout() async {
    await AppPreferences.remove(_tokenKey);
  }

  // Получение токена
  static Future<String?> getToken() async {
    return AppPreferences.getValue(_tokenKey);
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
