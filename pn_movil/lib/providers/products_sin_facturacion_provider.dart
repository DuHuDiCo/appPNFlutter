import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';

class ProductsSinFacturacionProvider extends ChangeNotifier {
  final ApiClient _apiClient;

  ProductsSinFacturacionProvider(this._apiClient);

  List<Map<String, dynamic>> _productosSinFacturacion = [];

  bool _isLoading = false;

  List<Map<String, dynamic>> get productosSinFacturacion =>
      _productosSinFacturacion;
  bool get isLoading => _isLoading;

  //Metodo para cargar los productos sin facturación
  Future<void> loadProductosSinFacturacion(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.get('/facturacion/productsFacturados');
      if (response.statusCode == 200 || response.statusCode == 204) {
        _productosSinFacturacion =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        print("Productos sin facturación cargados: $_productosSinFacturacion");
      } else {
        throw Exception('Error al cargar productos sin facturación');
      }
    } catch (e) {
      print(_productosSinFacturacion);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
