import 'package:flutter/material.dart';
import 'package:pn_movil/providers/google_provider.dart';
import 'package:provider/provider.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        await context.read<GoogleSignInProvider>().handleSignIn();
      },
      icon: Image.asset(
        'assets/google.png',
        height: 24,
        width: 24,
      ),
      label: const Text('Iniciar sesión con Google'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        disabledBackgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }
}
