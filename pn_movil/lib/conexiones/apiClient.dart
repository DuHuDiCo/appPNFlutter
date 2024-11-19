import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;

  ApiClient(this.baseUrl);

  Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    if (includeAuth && token.isEmpty) {
      throw Exception('No se ha iniciado sesión');
    }

    return {
      'Content-Type': 'application/json',
      if (includeAuth) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body,
      {bool includeAuth = true}) async {
    final headers = await _getHeaders(includeAuth: includeAuth);
    final url = Uri.parse('$baseUrl$endpoint');
    return http.post(url, headers: headers, body: json.encode(body));
  }

  Future<http.Response> get(String endpoint, {bool includeAuth = true}) async {
    final headers = await _getHeaders(includeAuth: includeAuth);
    final url = Uri.parse('$baseUrl$endpoint');
    return http.get(url, headers: headers);
  }

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
