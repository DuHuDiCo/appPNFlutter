import 'package:flutter/material.dart';

Widget pagoWidget(dynamic pago) {
  Color backgroundColor;
  Color textColor;
  String pagoTexto;
  IconData icon;

  if (pago == null) {
    backgroundColor = const Color.fromARGB(255, 226, 85, 70);
    textColor = Colors.white;
    pagoTexto = 'Pendiente';
    icon = Icons.access_time;
  } else {
    backgroundColor = const Color.fromARGB(255, 111, 190, 114);
    textColor = Colors.white;
    pagoTexto = 'Pagado';
    icon = Icons.check_circle;
  }

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12.0),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: textColor, size: 16.0),
        const SizedBox(width: 6.0),
        Text(
          pagoTexto,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 12.0, // Fuente más pequeña
          ),
        ),
      ],
    ),
  );
}
