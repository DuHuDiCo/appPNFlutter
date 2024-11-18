import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../conexiones/products.dart';
import '../conexiones/autentificacion.dart';

class ProductsProvider extends ChangeNotifier {
  final ProductsController _productsService = ProductsController();
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = false;
  String authToken = ''; // Inicializamos el token vacío

  List<Map<String, dynamic>> get products => _products;
  bool get isLoading => _isLoading;

  // Método para hacer login y obtener el token
  Future<void> loginAndGetToken(String username, String password) async {
    try {
      // authToken = await GoogleAuthController().LoginBackend(username, password);
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
      // Mostrar un mensaje de error al usuario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar productos: $e')),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
