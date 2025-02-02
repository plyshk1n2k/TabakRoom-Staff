import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:tabakroom_staff/models/api_response.dart';
import 'package:tabakroom_staff/services/app_preferences.dart';

class ApiService {
  static final String? _baseUrl = dotenv.env['MODE'] == 'TEST'
      ? Platform.isAndroid
          ? dotenv.env['TEST_BASE_URL_ANDROID']
          : dotenv.env['TEST_BASE_URL']
      : dotenv.env['PROD_BASE_URL'];
  // 🔹 Добавляем переменную для коллбэка выхода
  static VoidCallback? onLogoutCallback;

  /// Получаем токен доступа
  static Future<String?> _getToken() async =>
      AppPreferences.getValue('access_token');

  /// Получаем refresh-токен
  static Future<String?> _getRefreshToken() async =>
      AppPreferences.getValue('refresh_token');

  /// Автоматически обновляем токен, если истек
  static Future<bool> _refreshToken({int retryCount = 1}) async {
    if (retryCount > 1) return false; // 🔥 Предотвращаем бесконечные попытки

    final refreshToken = await _getRefreshToken();
    if (refreshToken == null) {
      onLogoutCallback?.call();
      return false;
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/token/refresh/'),
      headers: _getHeaders(),
      body: jsonEncode({'refresh': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = _safeJsonDecode(response.body);
      if (data != null && data.containsKey('access')) {
        await AppPreferences.setValue('access_token', data['access']);
        return true;
      }
    }
    return false;
  }

  /// Проверяем статус пользователя (исключаем зацикливание)
  static Future<bool> _checkUserStatus() async {
    final response = await _sendHttpRequest<Map<String, dynamic>>(
      method: 'GET',
      endpoint: '/users/user-is-active/',
      checkToken: false, // ❗ Отключаем проверку токена
    );

    return response.isSuccess && response.data?['is_active'] == true;
  }

  /// Универсальная обертка для запросов
  static Future<ApiResponse<T>> _sendHttpRequest<T>({
    required String method,
    required String endpoint,
    Map<String, dynamic>? body,
    bool checkToken = false,
  }) async {
    try {
      if (checkToken) {
        bool isActive = await _checkUserStatus();
        if (!isActive) {
          onLogoutCallback?.call();
          return ApiResponse.error("Доступ ограничен");
        }
      }

      String? token = await _getToken();
      Uri url = Uri.parse('$_baseUrl$endpoint');
      http.Response response;
      if (method == 'POST') {
        response = await http.post(url,
            headers: _getHeaders(token), body: jsonEncode(body));
      } else {
        response = await http.get(url, headers: _getHeaders(token));
      }

      if (response.statusCode == 401) {
        final refreshToken = await _getRefreshToken();

        if (refreshToken == null) {
          return ApiResponse.error("Неверный логин или пароль");
        } else {
          final refreshed = await _refreshToken();
          if (refreshed) {
            token = await _getToken();
            response = method == 'POST'
                ? await http.post(url,
                    headers: _getHeaders(token), body: jsonEncode(body))
                : await http.get(url, headers: _getHeaders(token));
          } else {
            return ApiResponse.error(
                "Ошибка 401: Токен истёк и не удалось обновить");
          }
        }
      }

      return _handleResponse<T>(response);
    } on SocketException {
      return ApiResponse.error("Нет подключения к интернету");
    } on TimeoutException {
      return ApiResponse.error("Превышено время ожидания запроса");
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Универсальный GET-запрос
  static Future<ApiResponse<T>> get<T>(String endpoint,
          {bool checkToken = true}) async =>
      _sendHttpRequest<T>(
          method: 'GET', endpoint: endpoint, checkToken: checkToken);

  /// Универсальный POST-запрос
  static Future<ApiResponse<T>> post<T>(
          String endpoint, Map<String, dynamic> body,
          {bool checkToken = true}) async =>
      _sendHttpRequest<T>(
          method: 'POST',
          endpoint: endpoint,
          body: body,
          checkToken: checkToken);

  /// Генерация заголовков с токеном
  static Map<String, String> _getHeaders([String? token]) => {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

  /// Обработка ответа от сервера
  static ApiResponse<T> _handleResponse<T>(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decodedData = _safeJsonDecode(response.body);
      if (decodedData != null) {
        return ApiResponse.success(decodedData as T);
      }
    }
    return ApiResponse.error("Ошибка ${response.statusCode}: ${response.body}");
  }

  /// Безопасное декодирование JSON
  static dynamic _safeJsonDecode(String source) {
    try {
      return jsonDecode(utf8.decode(source.runes.toList()));
    } catch (e) {
      return {'error': 'Ошибка обработки данных'};
    }
  }
}
