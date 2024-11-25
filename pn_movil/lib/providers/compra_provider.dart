import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';

class CompraProvider extends ChangeNotifier {
  final ApiClient _apiClient;

  CompraProvider(this._apiClient);

  List<Map<String, dynamic>> _compras = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get compras => _compras;
  bool get isLoading => _isLoading;

//Metodo para cargar las compras
  Future<void> loadCompras(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.get('/compra/compras');
      if (response.statusCode == 200) {
        _compras = List<Map<String, dynamic>>.from(json.decode(response.body));
        print("Compras cargadas: $_compras"); // Debugging
      } else {
        throw Exception('Error al cargar compras');
      }
    } catch (e) {
      final errorMessage = e.toString().contains('No se ha iniciado sesión')
          ? e.toString()
          : 'Error al cargar compras';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      if (kDebugMode) print(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
