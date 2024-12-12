import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/providers/facturacion_provider.dart';

class FacturacionService extends ChangeNotifier {
  final ApiClient apiClient;

  final List<Map<String, String>> _selectedProducts = [];

  bool get hasSelectedProducts => _selectedProducts.isNotEmpty;

  FacturacionService(this.apiClient);

  void addProducts(Map<String, String> producto) {
    _selectedProducts.add(producto);
    notifyListeners();
    print(_selectedProducts);
  }

  //Funcion para verificar si el producto seleccionado ya existe
  bool isProductSelected(int idProductoCompra) {
    return _selectedProducts.any((product) {
      var productId = product['idProductoCompra'];
      print(productId);

      return productId == idProductoCompra.toString();
    });
  }

  // Función para eliminar un producto seleccionado
  void removeProduct(int idProductoCompra) {
    _selectedProducts.removeWhere((product) =>
        product['idProductoCompra'] == idProductoCompra.toString());
    notifyListeners();
    print("Productos seleccionados actualizados: $_selectedProducts");
  }

  // Función para guardar la facturación
  Future<void> guardarFacturacion(
      BuildContext context, int idInventario) async {
    final Map<String, dynamic> factura = {
      'idInventario': idInventario,
      'productos': _selectedProducts,
    };

    print(factura);

    try {
      await FacturacionProvider(apiClient).crearFactura(context, factura);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      if (kDebugMode) print(e);
    }
  }

  //Funcion para formatear una cantidad de moneda a pesos colombianos
  String formatCurrencyToCOP(dynamic value) {
    final formatCurrency = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '',
    );
    return '\$${formatCurrency.format(value).split(',')[0]}';
  }
}
