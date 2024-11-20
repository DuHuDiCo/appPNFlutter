import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductsProvider extends ChangeNotifier {
  final ApiClient _apiClient;

  ProductsProvider(this._apiClient);

  List<Map<String, dynamic>> _products = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get products => _products;
  bool get isLoading => _isLoading;

  // Método para cargar los productos
  Future<void> loadProducts(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.get('/product/');
      if (response.statusCode == 200) {
        _products = List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception('Error al cargar productos');
      }
    } catch (e) {
      final errorMessage = e.toString().contains('No se ha iniciado sesión')
          ? e.toString()
          : 'Error al cargar productos';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      if (kDebugMode) print(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(
    BuildContext context,
    FormData productData,
  ) async {
    try {
      final response = await _apiClient.postFormData(
        '/product/',
        productData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Producto agregado exitosamente")),
        );
      } else {
        throw Exception('Error al agregar producto: ${response.body}');
      }
    } catch (e) {
      print(productData);
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al guardar el producto: $e")),
      );
    }
  }

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
}
