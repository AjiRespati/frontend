import 'dart:convert';

import 'package:frontend/application_info.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = ApplicationInfo.baseUrl;
  static Future<http.Response> login(String username, String password) {
    return http.post(
      Uri.parse('http://localhost:3000/api/auth/login'),
      body: {'username': username, 'password': password},
    );
  }

  static Future<http.Response> register(Map<String, String> data) {
    return http.post(
      Uri.parse('http://localhost:3000/api/auth/register'),
      body: data,
    );
  }

  static Future<http.Response> logout(String token) {
    return http.post(
      Uri.parse('http://localhost:3000/api/auth/logout'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<String?> refreshAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString('refreshToken');

    final response = await http.post(
      Uri.parse('$baseUrl/auth/refresh'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"refreshToken": refreshToken}),
    );

    if (response.statusCode < 400) {
      String newAccessToken = jsonDecode(response.body)['accessToken'];
      await prefs.setString('accessToken', newAccessToken);
      return newAccessToken;
    } else {
      return null;
    }
  }
}
