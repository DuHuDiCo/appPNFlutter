import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/autentificacion.dart';
import 'package:pn_movil/services/AuthService.dart'; // Asegúrate de importar tu servicio.

class GoogleSignInProvider with ChangeNotifier {
  final AuthService _authService;
  final GoogleAuthController _database;

  GoogleSignInProvider(this._authService, this._database);

  Future<void> handleSignIn() async {
    // Autenticación de Google para obtener el ID token
    final String? idToken = await _authService.signInWithGoogle();

    if (idToken != null) {
      // Enviamos el ID token al backend
      await _database.sendTokenToBackend(idToken);
    } else {
      print('Inicio de sesión cancelado o fallido');
    }
  }
}
