import 'package:tabakroom_staff/models/api_response.dart';
import 'package:tabakroom_staff/services/api_service.dart';
import 'package:tabakroom_staff/services/app_preferences.dart';

class AuthService {
  static const _tokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static bool isBlocked = false; // Статус блокировки

  /// Проверка, авторизован ли пользователь
  static Future<bool> isLoggedIn() async {
    final String? token = await AppPreferences.getValue<String>(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// Получение access-токена
  static Future<String?> getToken() async =>
      await AppPreferences.getValue<String>(_tokenKey);

  /// Получение refresh-токена
  static Future<String?> getRefreshToken() async =>
      await AppPreferences.getValue<String>(_refreshTokenKey);

  /// Сохранение access-токена
  static Future<void> saveToken(String token) async {
    await AppPreferences.setValue<String>(_tokenKey, token);
  }

  /// Сохранение refresh-токена
  static Future<void> saveRefreshToken(String token) async =>
      await AppPreferences.setValue<String>(_refreshTokenKey, token);

  /// Выход из системы (удаление токенов)
  static Future<void> logout() async {
    await AppPreferences.remove(_tokenKey);
    await AppPreferences.remove(_refreshTokenKey);
  }

  /// Авторизация пользователя
  static Future<ApiResponse<void>> login(
      String username, String password) async {
    final response = await ApiService.post<Map<String, dynamic>>(
        '/token/',
        {
          'username': username,
          'password': password,
        },
        checkToken: false);

    if (response.isSuccess) {
      final data = response.data!;
      final accessToken = data['access'] as String?;
      final refreshToken = data['refresh'] as String?;

      if (accessToken != null && refreshToken != null) {
        await saveToken(accessToken);
        await saveRefreshToken(refreshToken);
        return ApiResponse.success(data); // ✅ Успешный вход
      } else {
        return ApiResponse.error('Некорректные данные в ответе сервера');
      }
    } else {
      return ApiResponse.error(response.error);
    }
  }
}
