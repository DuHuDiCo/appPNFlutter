import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';

class AbonoProvider extends ChangeNotifier {
  final ApiClient _apiClient;
  AbonoProvider(this._apiClient);

  List<Map<String, dynamic>> _abonos = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get abonos => _abonos;
  bool get isLoading => _isLoading;

  //Metodo para crear un abono
  // Future<void> crearAbono(BuildContext context, Map<String, dynamic> data) async {
  //   try {
  //     _isLoading = true;
  //     notifyListeners();

  //     final response = await _apiClient.post('/abono/', data: jsonEncode(data));
  //     if (response.statusCode == 201) {
  //       final abono = response.data as Map<String, dynamic>;
  //       _abonos.add(abono);

  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Abono creado exitosamente')),
  //       );
  //     } else {
  //       throw Exception('Error al crear el abono: ${response.data}');
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error al crear el abono: $e')),
  //     );
  //     if (kDebugMode) print(e);
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }
}
