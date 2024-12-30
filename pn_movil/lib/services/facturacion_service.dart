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

  // Función para agregar un producto seleccionado
  void addProducts(Map<String, String> producto) {
    _selectedProducts.add(producto);
    notifyListeners();
    print('Productos seleccionados actualizados: $_selectedProducts');
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

    try {
      await FacturacionProvider(apiClient).crearFactura(context, factura);
      print('Factura creada exitosamente');
      print(factura);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      if (kDebugMode) print(e);
    }
  }

  //Funcion para crear un plan de pago
  Future<void> crearPlanPago(BuildContext context,
      Map<String, dynamic> planPago, int idCliente, int idFacturacion) async {
    final Map<String, dynamic> planPagoMap = {
      'fechaCorte': planPago['fechaCorte'],
      'perodicidad': planPago['perodicidad'],
      'cuotas': planPago['cuotas'],
      'valorCuota': planPago['valorCuota'],
    };

    try {
      await FacturacionProvider(apiClient)
          .crearPlanPago(context, planPagoMap, idCliente, idFacturacion);
      print(planPagoMap);
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
