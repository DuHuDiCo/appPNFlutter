import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';

class PagoProvider extends ChangeNotifier {
  final ApiClient _apiClient;
  PagoProvider(this._apiClient);

  List<Map<String, dynamic>> _pago = [];

  bool _isLoading = false;

  List<Map<String, dynamic>> get pagos => _pago;
  bool get isLoading => _isLoading;

//Metodo para cargar las pagos
  Future<void> loadPagos(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.get('/pago');
      if (response.statusCode == 200) {
        _pago = List<Map<String, dynamic>>.from(json.decode(response.body));
        print("Pagos cargados: $_pago"); // Debuggin
      } else {
        throw Exception('Error al cargar pagos');
      }
    } catch (e) {
      final errorMessage = e.toString().contains('No se ha iniciado sesión')
          ? e.toString()
          : 'Error al cargar pagos';
      print(_pago);
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
