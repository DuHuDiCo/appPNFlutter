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

  Future<Map<String, dynamic>> postProduct(
      String authToken, Map<String, dynamic> productData) async {
    try {
      final url = Uri.parse('$_baseUrl/api/v1/product/');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: json.encode(productData),
      );

      if (response.statusCode == 201) {
        Map<String, dynamic> createdProduct = json.decode(response.body);
        return createdProduct;
      } else {
        throw Exception(
            'Error al guardar el producto. Codigo: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al realizar la solicitud: $e');
      }
      rethrow;
    }
  }
}
