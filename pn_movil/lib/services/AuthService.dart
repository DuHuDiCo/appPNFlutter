import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pn_movil/models/Roles.dart';
import '../conexiones/autentificacion.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '496250946970-fkue2t5ofi7ie9bavb1m9i0h5bgi1523.apps.googleusercontent.com',
    scopes: [
      'https://www.googleapis.com/auth/userinfo.profile',
      'https://www.googleapis.com/auth/userinfo.email',
      'openid',
    ],
  );

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      return googleAuth.idToken;
    } catch (error) {
      print('Error en Google Sign-In: $error');
      return null;
    }
  }

  Future<Role> login(String username, String password) async {
    await Future.delayed(Duration(seconds: 2));
    Map<String, dynamic> apiResponse =
        await GoogleAuthController().LoginBackend(username, password);

    var roles = apiResponse['roles'] as List;
    String roleName = roles.isNotEmpty ? roles[0]['role']['role'] : 'guest';

    if (kDebugMode) {
      print('Rol del backend: $roleName');
    }

    switch (roleName) {
      case 'Administrador':
        return Role.admin;
      case 'Vendedor':
        return Role.vendedor;
      case 'Cliente':
        return Role.cliente;
      default:
        return Role.guest;
    }
  }
}
