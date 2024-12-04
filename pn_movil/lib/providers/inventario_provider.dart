import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/apiClient.dart';

class InventarioProvider extends ChangeNotifier {
  final ApiClient _apiClient;
  InventarioProvider(this._apiClient);

  List<Map<String, dynamic>> _inventario = [];

  bool _isLoading = false;

  List<Map<String, dynamic>> get inventarios => _inventario;
  bool get isLoading => _isLoading;

  //Metodo para cargar los inventarios
  Future<void> loadInventarios(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.get('/inventory/byUser');
      if (response.statusCode == 200) {
        _inventario =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        print("Inventarios cargados: $_inventario"); // Debuggin
      } else {
        throw Exception('Error al cargar inventarios');
      }
    } catch (e) {
      final errorMessage = e.toString().contains('No se ha iniciado sesión')
          ? e.toString()
          : 'Error al cargar inventarios';
      print(_inventario);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      if (kDebugMode) print(errorMessage);
    }
  }
}
