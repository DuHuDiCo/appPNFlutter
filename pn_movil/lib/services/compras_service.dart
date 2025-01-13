import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/providers/compra_provider.dart';

class ComprasService extends ChangeNotifier {
  final ApiClient apiClient;

  ComprasService(this.apiClient);

  final List<int> _selectedProductosFlete = [];

  bool get hasSelectedCuotas => _selectedProductosFlete.isNotEmpty;

  // Función para agregar un producto al array de seleccionados
  void addProductoFlete(int productoId) {
    if (!_selectedProductosFlete.contains(productoId)) {
      _selectedProductosFlete.add(productoId);
    }
    notifyListeners();
    print(
        'Productos flete seleccionados actualizados: $_selectedProductosFlete');
  }

  // Función para remover un producto del array de seleccionados
  void removeProductoFlete(int productoId) {
    _selectedProductosFlete.remove(productoId);
    notifyListeners();
    print(
        "Productos flete seleccionados actualizados: $_selectedProductosFlete");
  }

  // Función para guardar el flete
  Future<void> guardarFlete(
      BuildContext context, int idCompra, double valorFlete) async {
    final Map<String, dynamic> fleteMap = {
      'flete': valorFlete,
      'idProductos': _selectedProductosFlete,
    };

    try {
      await CompraProvider(apiClient).agregarFlete(context, fleteMap, idCompra);
      print(fleteMap);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      if (kDebugMode) print(e);
    }
  }
}
