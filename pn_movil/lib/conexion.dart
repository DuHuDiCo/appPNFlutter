import 'package:http/http.dart' as http;
import 'dart:convert';

class Database {
  final String _baseUrl = 'https://apppn.duckdns.org';

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
        print('Token enviado correctamente al backend');
        final responseBody = json.decode(response.body);
        print('Respuesta del backend: $responseBody');
      } else {
        print('Error al enviar el token al backend: ${response.statusCode}');
        print('Mensaje de error: ${response.body}');
      }
    } catch (e) {
      print('Error de red o de conexión: $e');
    }
  }
}
