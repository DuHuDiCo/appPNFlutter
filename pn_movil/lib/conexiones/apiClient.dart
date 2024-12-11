import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
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

  Future<http.Response> postFormData(
    String endpoint,
    FormData formData, {
    bool includeAuth = true,
  }) async {
    final token = await getAuthToken();
    print('Token enviado: $token');

    final headers = await _getHeaders(includeAuth: includeAuth);

    final url = Uri.parse('$baseUrl$endpoint');

    final request = http.MultipartRequest('POST', url)..headers.addAll(headers);

    formData.fields.forEach((entry) {
      request.fields[entry.key] = entry.value;
    });

    for (final file in formData.files) {
      final filePath = file.value.filename;
      if (filePath == null) {
        throw Exception('El archivo no tiene un nombre de archivo válido');
      }

      final mimeType = file.value.contentType.toString().split('/');
      request.files.add(await http.MultipartFile.fromPath(
        file.key,
        filePath, // Usa filePath aquí
        contentType: MediaType(mimeType[0], mimeType[1]),
      ));
    }

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  Future<http.Response> post(String endpoint, Map<String, dynamic> body,
      {bool includeAuth = true}) async {
    final headers = await _getHeaders(includeAuth: includeAuth);
    final url = Uri.parse('$baseUrl$endpoint');
    print(url);
    print(body);
    return http.post(url, headers: headers, body: json.encode(body));
  }

  Future<http.Response> get(String endpoint, {bool includeAuth = true}) async {
    final headers = await _getHeaders(includeAuth: includeAuth);
    final url = Uri.parse('$baseUrl$endpoint');
    print(url);
    return http.get(url, headers: headers);
  }

  Future<http.Response> put(String endpoint, Map<String, dynamic> body,
      {bool includeAuth = true}) async {
    final headers = await _getHeaders(includeAuth: includeAuth);
    final url = Uri.parse('$baseUrl$endpoint');
    return http.put(url, headers: headers, body: json.encode(body));
  }

  Future<http.Response> delete(String endpoint,
      {bool includeAuth = true}) async {
    final headers = await _getHeaders(includeAuth: includeAuth);
    print(headers);
    final url = Uri.parse('$baseUrl$endpoint');
    print(url);
    return http.delete(url, headers: headers);
  }

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
