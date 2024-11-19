import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/autentificacion.dart';
import '../conexiones/products.dart';

class ProductsProvider extends ChangeNotifier {
  final ProductsController _productsService = ProductsController();
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = false;
  String authToken = '';

  List<Map<String, dynamic>> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> loginAndGetToken(String username, String password) async {
    try {
      final response =
          await GoogleAuthController().LoginBackend(username, password);
      authToken = response['token'] ?? '';

      // Notifica los cambios
      notifyListeners();
    } catch (e) {
      print("Error al obtener el token: $e");
    }
  }

  // Método para cargar los productos
  Future<void> loadProducts(BuildContext context) async {
    if (authToken.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se ha iniciado sesión')),
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      _products = await _productsService.getProducts(authToken);
    } catch (e) {
      if (kDebugMode) {
        print('Error al cargar productos: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar productos: $e')),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
