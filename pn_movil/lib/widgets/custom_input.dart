import 'package:flutter/material.dart';

class Custominput {
  static InputDecoration authInputDecoracion(
      {required String hintText,
      required String labelText,
      IconData? prefixIcon}) {
    return InputDecoration(
      enabledBorder: const UnderlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromARGB(255, 149, 10, 0), width: 2)),
      focusedBorder: const UnderlineInputBorder(
          borderSide:
              BorderSide(color: Color.fromARGB(255, 149, 10, 0), width: 2)),
      hintText: hintText,
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.grey),
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              color: const Color.fromARGB(255, 149, 10, 0),
            )
          : null,
    );
  }
}
