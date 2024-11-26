import 'package:flutter/material.dart';

class CustomToggleButton extends StatefulWidget {
  const CustomToggleButton({super.key});

  @override
  _CustomToggleButtonState createState() => _CustomToggleButtonState();
}

class _CustomToggleButtonState extends State<CustomToggleButton> {
  @override
  Widget build(BuildContext context) {
    // Obtén la ruta actual
    final String? currentRoute = ModalRoute.of(context)?.settings.name;

    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(
                    context, 'compras-solicitar-crear-v1');
              },
              child: Container(
                decoration: BoxDecoration(
                  color: currentRoute == 'compras-solicitar-crear-v1'
                      ? Colors.blue
                      : Colors.black,
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(30),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  "Info compra",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Navegar a la ruta 'compras-solicitar-crear-v2'
                Navigator.pushReplacementNamed(
                    context, 'compras-solicitar-crear-v2');
              },
              child: Container(
                decoration: BoxDecoration(
                  color: currentRoute == 'compras-solicitar-crear-v2'
                      ? Colors.blue
                      : Colors.black,
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(30),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(
                  "Productos",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
