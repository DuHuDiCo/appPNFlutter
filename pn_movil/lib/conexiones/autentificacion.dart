import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleAuthController {
  final String _baseUrl = 'https://apppn.duckdns.org';

//Envio del token a la api con el que se loguea el usuario pero con google
  Future<void> sendTokenToBackend(String idToken) async {
    final url = Uri.parse('$_baseUrl/api/v1/google/movil');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'access_token': idToken,
        }),
      );
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Token enviado correctamente al backend');
        }
        final responseBody = json.decode(response.body);
        if (kDebugMode) {
          print('Respuesta del backend: $responseBody');
        }
      } else {
        if (kDebugMode) {
          print('Error al enviar el token al backend: ${response.statusCode}');
        }
        if (kDebugMode) {
          print('Mensaje de error: ${response.body}');
        }
        if (kDebugMode) {
          print('idToken: $idToken');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error de red o de conexión: $e');
      }
    }
  }

  Future<Map<String, dynamic>> LoginBackend(
      String username, String password) async {
    final url = Uri.parse('https://apppn.duckdns.org/api/v1/google/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        final token = responseBody['token'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        print('Token: $token');

        return responseBody;
      } else {
        throw Exception('Error en la autenticación: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al comunicarse con el servidor: $e');
    }
  }
}
