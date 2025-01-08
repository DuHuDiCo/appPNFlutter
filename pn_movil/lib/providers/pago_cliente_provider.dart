import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/views/Pagos-Clientes/pagos_clientes.dart';
import 'package:pn_movil/views/Pagos-Clientes/pagos_clientes_sinaplicar.dart';

class PagoClienteProvider extends ChangeNotifier {
  final ApiClient _apiClient;
  PagoClienteProvider(this._apiClient);

  List<Map<String, dynamic>> _pagosClientes = [];
  List<Map<String, dynamic>> _filteredPagosClientes = [];

  bool _isLoading = false;

  List<Map<String, dynamic>> get pagosClientes =>
      _filteredPagosClientes.isEmpty ? _pagosClientes : _filteredPagosClientes;
  bool get isLoading => _isLoading;

  //Metodo para cargar los pagos clientes
  Future<void> loadPagosClientes(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.get('/pagosClientes/');
      if (response.statusCode == 200) {
        _pagosClientes =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        _filteredPagosClientes =
            []; // Limpia los filtros al cargar todos los pagos
      } else {
        throw Exception('Error al cargar pagos clientes');
      }
    } catch (e) {
      final errorMessage = e.toString().contains('No se ha iniciado sesión')
          ? e.toString()
          : 'Error al cargar pagos clientes';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //Metodo para obtener un pago cliente por ID
  Future<void> obtenerPagoPorId(BuildContext context, int idCliente) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.get('/pagosClientes/$idCliente');

      if (response.statusCode == 200) {
        final pagos =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        if (pagos.isNotEmpty) {
          _filteredPagosClientes = pagos;
        } else {
          _filteredPagosClientes = [];
          throw Exception('No hay pagos para este cliente');
        }
      } else if (response.statusCode == 404) {
        throw Exception('Pago cliente no encontrado');
      }
    } catch (e) {
      _filteredPagosClientes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para resetear los filtros de pagos
  void resetPagosFiltrados() {
    _filteredPagosClientes = [];
    notifyListeners();
  }

  //Metodo para convertir una imagen a Base64
  Future<String> convertImageToBase64(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return base64Encode(bytes);
  }

  // Método para crear un pago cliente sin aplicar pago y aplicar el pago de una vez
  Future<void> crearPagoCliente(
      BuildContext context,
      double valor,
      String numeroRecibo,
      String tipoPago,
      List<Map<String, dynamic>>? aplicarPagoDTO,
      File? imagen) async {
    final dio = Dio();

    final token = await _apiClient.getAuthToken();
    dio.options.headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      _isLoading = true;
      notifyListeners();

      // Crear el cuerpo de la solicitud
      Map<String, dynamic> data = {
        'valor': valor.toString(),
        'numeroRecibo': numeroRecibo,
        'tipoPago': tipoPago,
      };

      // Serializar aplicarPagoDTO si no es nulo
      if (aplicarPagoDTO != null) {
        data['aplicarPagoDTO'] = aplicarPagoDTO;
      }

      // Convertir la imagen a base64 y agregarla si existe
      if (imagen != null) {
        final base64Image = await convertImageToBase64(imagen);
        data['comprobante'] = base64Image;
      }

      print('Datos a enviar: $data');

      final response = await dio.post(
        'https://apppn.duckdns.org/api/v1/pagosClientes/',
        data: jsonEncode(data),
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
      print('Error');
      if (e is DioException && e.response != null) {
        if (e.response!.statusCode == 400) {
          print('Error 400: ${e.response!.data}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${e.response!.data}')),
          );
        }
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> aplicarPagoAutomatico(BuildContext context, int idPagoCliente,
      {List<Map<String, dynamic>>? aplicarPagoDTO}) async {
    final dio = Dio();
    final token = await _apiClient.getAuthToken();

    dio.options.headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      _isLoading = true;
      notifyListeners();

      final data = {
        if (aplicarPagoDTO != null) 'aplicarPagoDTO': aplicarPagoDTO,
      };

      final response = await dio.post(
        'https://apppn.duckdns.org/api/v1/pagosClientes/aplicarPagoAutomatico?idPagoCliente=$idPagoCliente',
        data: jsonEncode(data),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final pagoClienteCreado = response.data as Map<String, dynamic>;
        _pagosClientes.add(pagoClienteCreado);

        print('Pago cliente creado exitosamente');
      } else {
        print('Error en la respuesta: ${response.data}');
      }
    } catch (e) {
      print('Error: $e');
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
