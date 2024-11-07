import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({Key? key, required SingleChildScrollView child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
          // children: [const _Caja(), const _HeaderIcon(), child],
          ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 30),
        child: Image.asset(
          'assets/OIP.jfif',
          width: 220,
          height: 220,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
