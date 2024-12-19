import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';

class ClientesProvider with ChangeNotifier {
  final ApiClient _apiClient;

  ClientesProvider(this._apiClient);

  List<Map<String, dynamic>> _clientes = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get clientes => _clientes;
  bool get isLoading => _isLoading;

  Future<void> loadClientes(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.get('/client/');
      if (response.statusCode == 200) {
        _clientes = List<Map<String, dynamic>>.from(json.decode(response.body));
        print("Clientes cargados: $_clientes"); // Debugging
      } else {
        throw Exception('Error al cargar compras');
      }
    } catch (e) {
      final errorMessage = e.toString().contains('No se ha iniciado sesión')
          ? e.toString()
          : 'Error al cargar clientes';
      print(_clientes);
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
