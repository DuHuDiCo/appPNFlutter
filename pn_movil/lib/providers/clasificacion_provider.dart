import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';

class ClasificacionProvider extends ChangeNotifier {
  final ApiClient _apiClient;
  ClasificacionProvider(this._apiClient);

  List<Map<String, dynamic>> _clasificaciones = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get clasificaciones => _clasificaciones;
  bool get isLoading => _isLoading;

//Metodo para cargar las clasificaciones
  Future<void> loadClasificaciones(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.get('/clasificacion/');
      if (response.statusCode == 200) {
        _clasificaciones =
            List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception('Error al cargar clasificaciones');
      }
    } catch (e) {
      final errorMessage = e.toString().contains('No se ha iniciado sesión')
          ? e.toString()
          : 'Error al cargar clasificaciones';
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
