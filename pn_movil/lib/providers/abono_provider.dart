import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/views/Pagos-Clientes/pagos_clientes.dart';

class AbonoProvider extends ChangeNotifier {
  final ApiClient _apiClient;
  AbonoProvider(this._apiClient);

  List<Map<String, dynamic>> _abonos = [];

  bool _isLoading = false;

  List<Map<String, dynamic>> get abonos => _abonos;
  bool get isLoading => _isLoading;

  //Metodo para crear un abono
  Future<void> createAbono(
      BuildContext context, Map<String, dynamic> nuevoAbono) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.post(
        '/api/v1/abono/crear',
        nuevoAbono,
      );

      print('Respuesta del backend: ${response.body}');
      print(nuevoAbono);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final abonoCreado = json.decode(response.body) as Map<String, dynamic>;
        _abonos.add(abonoCreado);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Aplicacion de abono normal creada exitosamente AAA')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PagosClientes()),
        );
      } else {
        throw Exception(
            'Error al crear la aplicacion de abono normal: ${response.body}');
      }
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
