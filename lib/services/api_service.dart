import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final String? _baseUrl = dotenv.env['BASE_URL'];

  // Получаем access токен
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Получаем refresh токен
  static Future<String?> _getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refresh_token');
  }

  // Обновление access токена
  static Future<bool> _refreshToken() async {
    final refreshToken = await _getRefreshToken();

    if (refreshToken == null) return false;
    print(refreshToken);
    final response = await http.post(
      Uri.parse('$_baseUrl/token/refresh/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', data['access']);
      return true;
    } else {
      return false;
    }
  }

  // Универсальный GET-запрос с автообновлением токена
  static Future<dynamic> get(String endpoint,
      {bool rethrowError = false}) async {
    final stopwatch = Stopwatch()..start();

    try {
      var token = await _getToken();
      var response = await http.get(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 401) {
        final refreshed = await _refreshToken();
        if (refreshed) {
          token = await _getToken();
          response = await http.get(
            Uri.parse('$_baseUrl$endpoint'),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
          );
        } else {
          throw Exception("Ошибка 401: Токен истёк и не удалось обновить.");
        }
      }

      return _handleResponse(response);
    } catch (e) {
      debugPrint('Ошибка GET-запроса: $e');
      if (rethrowError) {
        rethrow;
      } else {
        return {'error': e.toString()};
      }
    } finally {
      stopwatch.stop();
      debugPrint(
          'GET-запрос на $endpoint занял ${stopwatch.elapsedMilliseconds} мс');
    }
  }

  // Универсальный POST-запрос с автообновлением токена
  static Future<dynamic> post(String endpoint, Map<String, dynamic> body,
      {bool rethrowError = false}) async {
    final stopwatch = Stopwatch()..start();

    try {
      var token = await _getToken();
      var response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 401) {
        final refreshed = await _refreshToken();
        if (refreshed) {
          token = await _getToken();
          response = await http.post(
            Uri.parse('$_baseUrl$endpoint'),
            headers: {
              'Content-Type': 'application/json',
              if (token != null) 'Authorization': 'Bearer $token',
            },
            body: jsonEncode(body),
          );
        } else {
          throw Exception("Ошибка 401: Токен истёк и не удалось обновить.");
        }
      }

      return _handleResponse(response);
    } catch (e) {
      debugPrint('Ошибка POST-запроса: $e');
      if (rethrowError) {
        rethrow;
      } else {
        return {'error': e.toString()};
      }
    } finally {
      stopwatch.stop();
      debugPrint(
          'POST-запрос на $endpoint занял ${stopwatch.elapsedMilliseconds} мс');
    }
  }

  // Обработчик ответов сервера
  static dynamic _handleResponse(http.Response response) {
    final stopwatch = Stopwatch()..start();
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final decodedBody = utf8.decode(response.bodyBytes);
      final result = jsonDecode(decodedBody);
      stopwatch.stop();
      debugPrint(
          'Время декодирования ответа: ${stopwatch.elapsedMilliseconds} мс');
      return result;
    } else {
      stopwatch.stop();
      debugPrint(
          'Ошибка обработки ответа заняла: ${stopwatch.elapsedMilliseconds} мс');
      throw Exception('Ошибка ${response.statusCode}: ${response.body}');
    }
  }
}
