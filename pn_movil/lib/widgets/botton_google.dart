import 'package:flutter/material.dart';
import 'package:pn_movil/conexiones/autentificacion.dart';
import 'package:pn_movil/services/AuthService.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  final AuthService _authService = AuthService();
  final GoogleAuthController _database = GoogleAuthController();

  Future<void> _handleSignIn() async {
    // Autenticación de Google para obtener el ID token
    final String? idToken = await _authService.signInWithGoogle();

    if (idToken != null) {
      // Enviamos el ID token al backend
      await _database.sendTokenToBackend(idToken);
    } else {
      print('Inicio de sesión cancelado o fallido');
      print('Token ${idToken}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _handleSignIn,
      icon: Image.asset(
        'assets/google.png',
        height: 24,
        width: 24,
      ),
      label: Text('Iniciar sesión con Google'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        disabledBackgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }
}
