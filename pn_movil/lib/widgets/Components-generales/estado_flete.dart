import 'package:flutter/material.dart';

Widget estadoFleteWidget(dynamic flete) {
  Color backgroundColor;
  Color textColor;
  String fleteTexto;
  IconData icon;

  if (flete > 0) {
    backgroundColor = const Color.fromARGB(255, 95, 152, 232);
    textColor = Colors.white;
    fleteTexto = 'Con flete';
    icon = Icons.check_circle;
  } else {
    backgroundColor = const Color.fromARGB(255, 236, 209, 110);
    textColor = Colors.white;
    fleteTexto = 'Sin flete';
    icon = Icons.access_time;
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
          fleteTexto,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
          ),
        ),
      ],
    ),
  );
}
