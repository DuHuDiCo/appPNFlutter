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

//Metodo para agregar los productos
  Future<void> addProduct(
    BuildContext context,
    FormData productData,
  ) async {
    try {
      final response = await _apiClient.postFormData(
        '/product/',
        productData,
      );

      print(
          'Respuesta del servidor: ${response.body}'); // Imprime la respuesta del servidor

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

//Metodo para eliminar un producto
  Future<void> deleteProduct(BuildContext context, int productId) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.delete('/product/$productId');

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Eliminar producto de la lista localmente
        _products.removeWhere((product) => product['idProducto'] == productId);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Producto eliminado exitosamente')),
        );
      } else {
        throw Exception('Error al eliminar producto: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el producto: $e')),
      );
      if (kDebugMode) print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

//Metodo para obtener el token
  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  //Metodo para editar un producto
// Future<void> editProduct(
//   BuildContext context,
//   String productId,
//   FormData updatedData,
// ) async {
//   try {
//     _isLoading = true;
//     notifyListeners();

//     final response = await _apiClient.put(
//       '/product/$productId/', postForm,
//     );

//     if (response.statusCode == 200 || response.statusCode == 204) {
//       // Actualizar producto localmente
//       final index = _products.indexWhere((product) => product['id'] == productId);
//       if (index != -1) {
//         final updatedProduct = json.decode(response.body) as Map<String, dynamic>;
//         _products[index] = updatedProduct;
//       }

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Producto actualizado exitosamente')),
//       );
//     } else {
//       throw Exception('Error al actualizar producto: ${response.body}');
//     }
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error al actualizar el producto: $e')),
//     );
//     if (kDebugMode) print(e);
//   } finally {
//     _isLoading = false;
//     notifyListeners();
//   }
// }
}
