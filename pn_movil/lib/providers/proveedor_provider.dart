import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';

class ProveedorProvider extends ChangeNotifier {
  final ApiClient _apiClient;

  ProveedorProvider(this._apiClient);

  List<Map<String, dynamic>> _proveedores = [];

  bool _isLoading = false;

  List<Map<String, dynamic>> get proveedores => _proveedores;
  bool get isLoading => _isLoading;

  //Metodo para cargar los proveedores
  Future<void> loadProveedores(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.get('/proveedor/');
      if (response.statusCode == 200) {
        _proveedores =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        print(_proveedores);
      } else {
        throw Exception('Error al cargar proveedores');
      }
    } catch (e) {
      final errorMessage = e.toString().contains('No se ha iniciado sesión')
          ? e.toString()
          : 'Error al cargar proveedores';
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
