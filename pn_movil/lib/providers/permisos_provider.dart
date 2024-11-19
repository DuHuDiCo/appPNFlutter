import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';
import 'package:pn_movil/models/Roles.dart';
import 'package:pn_movil/services/AuthService.dart';
import 'package:provider/provider.dart';

class PermisosProvider with ChangeNotifier {
  Role _role = Role.guest;
  Role get role => _role;

  Future<void> login(
      BuildContext context, String username, String password) async {
    final apiClient = Provider.of<ApiClient>(context, listen: false);
    final authService = AuthService(apiClient);

    _role = await authService.login(username, password);
    notifyListeners();
  }

  bool canAccessModule(String module) {
    return Permisos.modulosAcceso[_role]?.contains(module) ?? false;
  }

  bool canPerformAction(String action) {
    return Permisos.AccionesPermisos[_role]?.contains(action) ?? false;
  }
}
