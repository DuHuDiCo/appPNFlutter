import 'package:flutter/material.dart';

class CustomToggleButton extends StatelessWidget {
  final bool isFormValid; // Recibe el estado de validación del formulario
  final VoidCallback? onSaveAndRedirect;

  const CustomToggleButton({
    required this.isFormValid,
    this.onSaveAndRedirect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
              onTap: isFormValid ? onSaveAndRedirect : null,
              child: Container(
                decoration: BoxDecoration(
                  color: isFormValid
                      ? (currentRoute == 'compras-solicitar-crear-v2'
                          ? Colors.blue
                          : Colors.black)
                      : Colors.grey, // Color deshabilitado
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
            )
          ],
        ),
      ),
    );
  }
}
