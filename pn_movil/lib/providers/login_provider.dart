import 'package:flutter/material.dart';
import 'package:pn_movil/services/AuthService.dart';
import 'package:pn_movil/models/Roles.dart';
import 'package:provider/provider.dart';
import 'package:pn_movil/conexiones/ApiClient.dart';

class LoginProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  bool isLoading = false;

  Role? userRole;

  bool get isValidForm => formKey.currentState!.validate();

  Future<bool> login(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    try {
      final apiClient = Provider.of<ApiClient>(context, listen: false);
      final authService = AuthService(apiClient);

      Role role = await authService.login(email, password);
      userRole = role;

      isLoading = false;
      notifyListeners();

      if (isValidForm) {
        if (Permisos.modulosAcceso[userRole!]?.contains('home') ?? false) {
          Navigator.pushReplacementNamed(context, 'home');
          return true;
        } else {
          throw Exception('No tiene permisos para acceder a la aplicación.');
        }
      } else {
        return false;
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de autenticación: $e')),
      );
      return false;
    }
  }
}
