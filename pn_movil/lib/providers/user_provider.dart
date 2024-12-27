import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';

class UserProvider extends ChangeNotifier {
  final ApiClient _apiClient;

  UserProvider(this._apiClient);

  List<Map<String, dynamic>> _usuarios = [];
  List<dynamic> vendedores = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get usuarios => _usuarios;
  bool get isLoading => _isLoading;

  //Metodo para cargar los proveedores
  Future<void> loadUsuariosVendedores(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiClient.get('/user/');
      if (response.statusCode == 200) {
        final List<dynamic> usuariosData = json.decode(response.body);

        _usuarios = usuariosData.where((usuario) {
          final userRoles =
              usuario['userRoles'] as List<dynamic>?; // Validar si existe
          if (userRoles == null || userRoles.isEmpty) return false;

          // Buscar un rol Administrador
          return userRoles.any((userRole) {
            final role = userRole['role'];
            return role != null && role['role'] == 'Vendedor';
          });
        }).map((usuario) {
          return {
            'id': usuario['idUser'],
            'nombre': '${usuario['name']} ${usuario['lastname']}',
            'email': usuario['email'],
          };
        }).toList();

        if (kDebugMode) {
          print(_usuarios);
        }
      } else {
        print(_usuarios);
        throw Exception('Error al cargar los usuarios con rol vendedores');
      }
    } catch (e) {
      final errorMessage = e.toString().contains('No se ha iniciado sesión')
          ? e.toString()
          : 'Error al cargar vendedores';
      print(_usuarios);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      if (kDebugMode) print(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadVendedores(BuildContext context) async {
    try {
      // Marcar inicio de carga
      _isLoading = true;
      notifyListeners();

      // Realizar la solicitud al backend
      final response = await _apiClient.get('/user/vendedores');

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        if (decodedResponse is List) {
          vendedores = decodedResponse;
          Logger().i(JsonCodec().encode(vendedores));
          Logger().d('Vendedores cargados correctamente.');
        } else {
          throw Exception('Respuesta inesperada del servidor.');
        }
      } else {
        // Manejo de errores HTTP específicos
        final errorMessage =
            _handleHttpError(response.statusCode, response.body);
        throw Exception(errorMessage);
      }
    } on SocketException {
      // Manejo de errores de red
      _showErrorMessage(context, 'No se pudo conectar con el servidor.');
    } catch (e, stackTrace) {
      // Manejo de cualquier otro error
      Logger().e('Error inesperado: $e');
      _showErrorMessage(context, 'Error inesperado al cargar vendedores.');
    } finally {
      // Finalizar el indicador de carga
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Manejo de errores HTTP según el código de estado
  String _handleHttpError(int statusCode, String responseBody) {
    switch (statusCode) {
      case 401:
        return 'No se ha iniciado sesión.';
      case 403:
        return 'No tienes permiso para realizar esta acción.';
      case 500:
        return 'Error interno del servidor.';
      default:
        return 'Error desconocido: $statusCode - $responseBody';
    }
  }

  /// Mostrar un mensaje de error en un SnackBar
  void _showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
