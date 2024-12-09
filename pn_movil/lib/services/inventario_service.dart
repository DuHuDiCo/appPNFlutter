import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pn_movil/conexiones/apiClient.dart';

class InventarioService {
  final ApiClient apiClient;

  InventarioService(this.apiClient);

  // Método para formatear una cantidad de moneda a pesos colombianos
  String formatCurrencyToCOP(dynamic value) {
    final formatCurrency = NumberFormat.currency(
      locale: 'es_CO',
      symbol: '',
    );
    return '\$${formatCurrency.format(value).split(',')[0]}';
  }
}
