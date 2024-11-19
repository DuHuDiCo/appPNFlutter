import 'dart:convert';
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

  Future<void> addProduct(BuildContext context, String authToken,
      Map<String, dynamic> productData) async {
    try {
      _isLoading = true;
      notifyListeners();

      print(productData);

      final response = await _apiClient.post(
        '/product/',
        productData,
        includeAuth: true,
      );

      print(response.statusCode);

      if (response.statusCode == 201) {
        final newProduct = json.decode(response.body);
        _products.add(newProduct);
        print('Producto agregado con éxito: $newProduct');
      } else {
        throw Exception('Error Backend');
      }
    } catch (e) {
      final errorMessage = e.toString().contains('No se ha iniciado sesión')
          ? e.toString()
          : e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      if (kDebugMode) print(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token'); // Recupera el token almacenado
  }
}
