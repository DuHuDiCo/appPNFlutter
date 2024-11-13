import 'package:flutter/material.dart';
import 'package:pn_movil/view/crear_product.dart';
import 'package:pn_movil/view/login.dart';
import 'package:pn_movil/view/products.dart';
import 'package:pn_movil/view/vista_inicial.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login',
      initialRoute: 'login',
      routes: {
        'login': (_) => const Login(),
        'home': (_) => const VistaInicial(),
        'productos': (_) => const Products(),
        'crearProduct': (_) => const Crearproduct(),
      },
      theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.grey[300],
          appBarTheme: const AppBarTheme(
              elevation: 0,
              centerTitle: true,
              color: Color.fromARGB(255, 149, 10, 0)),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Color.fromARGB(255, 149, 10, 0), elevation: 0)),
    );
  }
}
