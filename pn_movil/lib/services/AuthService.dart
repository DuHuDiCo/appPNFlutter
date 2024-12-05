import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pn_movil/models/Roles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../conexiones/ApiClient.dart';

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

  final ApiClient _apiClient;
  AuthService(this._apiClient);
  get token => null;

  // Método de autenticación con Google
  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // El usuario canceló el inicio de sesión
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      return googleAuth.idToken;
    } catch (error) {
      print('Error en Google Sign-In: $error');
      return null;
    }
  }

  // Método de inicio de sesión tradicional
  Future<Role> login(String username, String password) async {
    try {
      final response = await _apiClient.post(
        '/google/',
        {'username': username, 'password': password},
        includeAuth: false,
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        // Almacenar el token en SharedPreferences
        final token = responseBody['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        // Extraer roles
        final roles = responseBody['roles'] as List;
        final roleName = roles.isNotEmpty ? roles[0]['role']['role'] : 'guest';

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
      } else {
        throw Exception('Error en la autenticación: ${response.statusCode}');
      }
    } catch (error) {
      print('Error al iniciar sesión: $error');
      throw Exception('No se pudo iniciar sesión. Verifica tus credenciales.');
    }
  }
}
