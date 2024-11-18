import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductsController {
  final String _baseUrl = 'https://apppn.duckdns.org';

  Future<List<Map<String, dynamic>>> getProducts(String authToken) async {
    try {
      final url = Uri.parse('$_baseUrl/api/v1/product/');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> products =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        return products;
      } else {
        throw Exception(
            'Error al cargar los productos. Código: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al realizar la solicitud: $e');
      }
      rethrow;
    }
  }
}
