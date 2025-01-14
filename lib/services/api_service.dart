import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final String? _baseUrl = dotenv.env['BASE_URL']; // Базовый URL

  // Метод для получения токена из SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  // Универсальный GET-запрос
  static Future<dynamic> get(String endpoint) async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      return _handleResponse(response);
    } catch (e) {
      debugPrint('Ошибка GET-запроса: $e');
      rethrow;
    }
  }

  // Универсальный POST-запрос
  static Future<dynamic> post(
      String endpoint, Map<String, dynamic> body) async {
    try {
      final token = await _getToken();
      final response = await http.post(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      debugPrint('Ошибка POST-запроса: $e');
      rethrow;
    }
  }

  // Универсальный PUT-запрос
  static Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    try {
      final token = await _getToken();
      final response = await http.put(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      debugPrint('Ошибка PUT-запроса: $e');
      rethrow;
    }
  }

  // Универсальный DELETE-запрос
  static Future<dynamic> delete(String endpoint) async {
    try {
      final token = await _getToken();
      final response = await http.delete(
        Uri.parse('$_baseUrl$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      return _handleResponse(response);
    } catch (e) {
      debugPrint('Ошибка DELETE-запроса: $e');
      rethrow;
    }
  }

  // Обработчик ответов сервера
  static dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Ошибка ${response.statusCode}: ${response.body}');
    }
  }
}
