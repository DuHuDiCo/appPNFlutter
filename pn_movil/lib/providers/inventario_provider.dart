import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';

class InventarioProvider extends ChangeNotifier {
  final ApiClient _apiClient;
  InventarioProvider(this._apiClient);

  List<Map<String, dynamic>> _inventario = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get inventarios => _inventario;
  bool get isLoading => _isLoading;

  // Método para cargar inventarios con isNull
  Future<void> loadInventarios(BuildContext context,
      {required bool isNull}) async {
    try {
      _isLoading = true;
      notifyListeners();
      final userId = 1;
      print("Id del usuario: $userId");
      print("isNull: $isNull");
      final response = await _apiClient
          .get('/inventory/byUser?idUser=$userId&isNull=$isNull');

      print("Response: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        _inventario =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        print("Inventarios cargados: $_inventario");
      } else {
        throw Exception('Error al cargar inventarios ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar inventarios: $e')),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para calcular el total por inventario por ese inventario
  double calcularTotalPorInventario(Map<String, dynamic> inventario) {
    double total = 0.0;

    if (inventario['productoCompras'] != null) {
      for (var productoCompra in inventario['productoCompras']) {
        var cantidad = productoCompra['productoCompra']['cantidad'];
        var costo = productoCompra['productoCompra']['costo'];
        total += cantidad * costo;
      }
    }
    return total;
  }
}
