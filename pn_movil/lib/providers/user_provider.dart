import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';

class UserProvider extends ChangeNotifier {
  final ApiClient _apiClient;

  UserProvider(this._apiClient);

  List<Map<String, dynamic>> _usuarios = [];
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
}
