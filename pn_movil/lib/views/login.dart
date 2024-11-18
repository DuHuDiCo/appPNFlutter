import 'package:flutter/material.dart';
import 'package:pn_movil/providers/login_provider.dart';
import 'package:pn_movil/widgets/botton_google.dart';
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
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CardContainer(
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          Text(
                            'Iniciar Sesión',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 10),
                          ChangeNotifierProvider(
                            create: (context) => LoginProvider(),
                            child: const _LoginForm(),
                          ),
                        ],
                      ),
                    ),
                    const Positioned(
                      top: -50,
                      left: 0,
                      right: 0,
                      child: HeaderIcon(),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    return Form(
      key: loginProvider.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: Custominput.authInputDecoracion(
              hintText: 'Escribe tu correo',
              labelText: 'Correo electrónico',
              prefixIcon: Icons.email,
            ),
            onChanged: (value) {
              loginProvider.email = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Este campo no puede estar vacío';
              }
              String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
              RegExp regExp = RegExp(pattern);
              return regExp.hasMatch(value)
                  ? null
                  : 'Introduce un correo válido';
            },
          ),
          const SizedBox(height: 30),
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
              if (value == null || value.isEmpty) {
                return 'Este campo no puede estar vacío';
              }
              return value.length >= 6
                  ? null
                  : 'La contraseña debe tener al menos 6 caracteres';
            },
          ),
          const SizedBox(height: 30),
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            disabledColor: Colors.grey,
            elevation: 0,
            color: const Color.fromARGB(255, 40, 89, 135),
            onPressed: loginProvider.isLoading
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    if (!loginProvider.isValidForm) return;

                    final loginSuccessful = await loginProvider.login(context);

                    if (!loginSuccessful) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Error al iniciar sesión')),
                      );
                    }
                  },
            child: loginProvider.isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 15),
                    child: const Text('Iniciar sesión',
                        style: TextStyle(color: Colors.white)),
                  ),
          ),
          const SizedBox(height: 30),
          // Aquí agregamos el Google SignIn Button
          GoogleSignInButton(),
        ],
      ),
    );
  }
}
