import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pn_movil/conexiones/apiClient.dart';

class InventarioService {
  final ApiClient apiClient;

  InventarioService(this.apiClient);

  // Método para cargar el inventario
  Future<void> loadInventarios(BuildContext context) async {
    try {
      final response = await apiClient.get('/inventory/byUser?idUser=8');
      if (response.statusCode == 200) {
        print('Inventarios cargados: $response');
      } else {
        throw Exception('Error al cargar inventarios');
      }
    } catch (e) {
      final errorMessage = e.toString().contains('No se ha iniciado sesión')
          ? e.toString()
          : 'Error al cargar inventarios';
      print(errorMessage);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  // Método para formatear una cantidad de moneda a pesos colombianos
  String formatCurrencyToCOP(dynamic value) {
    final formatCurrency = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '',
    );
    return '\$${formatCurrency.format(value).split(',')[0]}';
  }
}
