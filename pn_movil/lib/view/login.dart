import 'package:flutter/material.dart';
import 'package:pn_movil/provider/login_provider.dart';
import 'package:pn_movil/widgets/card_container.dart';
import 'package:pn_movil/widgets/background.dart';
import 'package:pn_movil/widgets/custom_input.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 250,
            ),
            CardContainer(
                child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text('Iniciar Sesión',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 30,
                ),
                ChangeNotifierProvider(
                  create: (context) => LoginProvider(),
                  child: const _LoginForm(),
                ),
              ],
            )),
            const SizedBox(
              height: 50,
            ),
            const SizedBox(
              height: 50,
            )
          ],
        ),
      )),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    return Container(
      child: Form(
        key: loginProvider.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            // Campo de Email o Usuario
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: Custominput.authInputDecoracion(
                hintText: 'Escribe tu correo',
                labelText: 'Correo electrónic',
                prefixIcon: Icons.email,
              ),
              onChanged: (value) {
                loginProvider.email = value;
              },
              validator: (value) {
                String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
                RegExp regExp = RegExp(pattern);
                return regExp.hasMatch(value ?? '')
                    ? null
                    : 'Introduce un correo válido';
              },
            ),
            const SizedBox(
              height: 30,
            ),
            // Campo de Contraseña
            TextFormField(
              autocorrect: false,
              obscureText: true,
              decoration: Custominput.authInputDecoracion(
                hintText: 'Escribe tu contraseña',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock,
              ),
              onChanged: (value) {
                loginProvider.password = value;
              },
              validator: (value) {
                return (value != null && value.length >= 6)
                    ? null
                    : 'La contraseña debe tener al menos 6 caracteres';
              },
            ),
            const SizedBox(
              height: 30,
            ),
            // Botón de Login
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              disabledColor: Colors.grey,
              elevation: 0,
              color: const Color.fromARGB(255, 149, 10, 0),
              onPressed: loginProvider.isLoading
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      // if (!loginProvider.isValidForm()) return;

                      loginProvider.isLoading = true;

                      // Lógica de autenticación
                      final loginSuccessful = await loginProvider.login();

                      if (loginSuccessful) {
                        // Navegar a otra pantalla después del inicio de sesión
                        Navigator.pushReplacementNamed(context, 'homeScreen');
                      } else {
                        // Mostrar un mensaje de error en caso de fallo
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error al iniciar sesión'),
                          ),
                        );
                      }

                      loginProvider.isLoading = false;
                    },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                child: Text(
                  loginProvider.isLoading ? 'Cargando...' : 'Iniciar sesión',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
