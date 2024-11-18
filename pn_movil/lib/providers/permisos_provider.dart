import 'package:flutter/material.dart';
import '../models/Roles.dart';
import '../services/AuthService.dart';

class PermisosProvider with ChangeNotifier {
  Role _role = Role.guest;
  Role get role => _role;

  void setRole(Role role) {
    _role = role;
    notifyListeners();
  }

  final AuthService _authService = AuthService();

  Future<void> login(String username, String password) async {
    _role = await _authService.login(username, password);
    notifyListeners();
  }

  bool canAccessModule(String module) {
    return Permisos.modulosAcceso[_role]?.contains(module) ?? false;
  }

  bool canPerformAction(String action) {
    return Permisos.AccionesPermisos[_role]?.contains(action) ?? false;
  }
}
