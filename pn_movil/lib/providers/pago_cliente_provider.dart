import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/views/Pagos-Clientes/pagos_clientes.dart';

class PagoClienteProvider extends ChangeNotifier {
  final ApiClient _apiClient;
  PagoClienteProvider(this._apiClient);

  List<Map<String, dynamic>> _pagosClientes = [];

  bool _isLoading = false;

  List<Map<String, dynamic>> get pagosClientes => _pagosClientes;
  bool get isLoading => _isLoading;

  //Metodo para cargar las pagos clientes
  Future<void> loadPagosClientes(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.get('/pagosClientes/');
      if (response.statusCode == 200) {
        _pagosClientes =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        print("Pagos clientes cargados: $_pagosClientes"); // Debuggin
      } else {
        throw Exception('Error al cargar pagos clientes');
      }
    } catch (e) {
      final errorMessage = e.toString().contains('No se ha iniciado sesión')
          ? e.toString()
          : 'Error al cargar pagos clientes';
      print(_pagosClientes);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      if (kDebugMode) print(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

// Método para guardar un pago cliente
  Future<void> crearPagoCliente(
      BuildContext context,
      double valor,
      String numeroRecibo,
      String tipoPago,
      List<Map<String, dynamic>>? aplicarPagoDTO,
      File? imagen) async {
    final dio = Dio();

    // Obtener el token de autenticación
    final token = await _apiClient.getAuthToken();
    dio.options.headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    };

    try {
      _isLoading = true;
      notifyListeners();
      final formData = FormData();

      // Agregar campos obligatorios al FormData
      formData.fields.addAll([
        MapEntry('valor', valor.toString()),
        MapEntry('numeroRecibo', numeroRecibo),
        MapEntry('tipoPago', tipoPago),
      ]);

      // Serializar aplicarPagoDTO si no es nulo
      if (aplicarPagoDTO != null) {
        formData.fields.add(
          MapEntry('aplicarPagoDTO', jsonEncode(aplicarPagoDTO)),
        );
      }

      // Agregar la imagen al FormData, si existe
      if (imagen != null) {
        final fileName = imagen.path.split('/').last;
        formData.files.add(MapEntry(
          'comprobante',
          await MultipartFile.fromFile(
            imagen.path,
            filename: fileName,
          ),
        ));
      }

      // Enviar la solicitud POST al backend
      final response = await dio.post(
        'https://apppn.duckdns.org/api/v1/pagosClientes/',
        data: formData,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final pagoClienteCreado = response.data as Map<String, dynamic>;
        _pagosClientes.add(pagoClienteCreado);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pago cliente creado exitosamente')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PagosClientes()),
        );
      } else {
        throw Exception('Error al crear el pago cliente: ${response.data}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error al crear el pago cliente: ${e.toString()}')),
      );
    }
  }

  //Metodo para obtener un pago cliente por ID
  Future<void> obtenerPagoPorId(BuildContext context, int idPagoCliente) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Realizar la solicitud GET para obtener el pago cliente por ID
      final response = await _apiClient.get('/pagosClientes/$idPagoCliente');

      if (response.statusCode == 200) {
        final pagoCliente = json.decode(response.body) as Map<String, dynamic>;

        print("Pago cliente obtenido: $pagoCliente"); // Debugging
      } else if (response.statusCode == 404) {
        throw Exception('Pago cliente no encontrado');
      } else {
        throw Exception('Error al obtener el pago cliente');
      }
    } catch (e) {
      final errorMessage = e.toString().contains('No se ha iniciado sesión')
          ? e.toString()
          : 'Error al obtener el pago cliente';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      if (kDebugMode) print(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Metodo para eliminar un pago cliente
  Future<void> deletePagoCliente(
      BuildContext context, int idPagoCliente) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response =
          await _apiClient.delete('/api/v1/pagosClientes/$idPagoCliente');

      if (response.statusCode == 200 || response.statusCode == 204) {
        _pagosClientes
            .removeWhere((pago) => pago['idPagoCliente'] == idPagoCliente);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pago cliente eliminado exitosamente')),
        );
      } else {
        throw Exception('Error al eliminar el pago cliente: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      if (kDebugMode) print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Metodo para pbtener todos los pagos de clientes sin aplicar
  Future<void> obtenerPagosSinAplicar(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.get('/pagosClientes/sinAplicar');

      if (response.statusCode == 200) {
        _pagosClientes =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        print("Pagos clientes sin aplicar obtenidos: $_pagosClientes");
      } else {
        throw Exception('Error al obtener pagos clientes sin aplicar');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      if (kDebugMode) print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
