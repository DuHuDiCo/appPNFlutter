import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: child,
    );
  }
}

class HeaderIcon extends StatelessWidget {
  const HeaderIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.blue, width: 5),
        ),
        child: ClipOval(
          child: Image.asset(
            'assets/algo.jpg',
            fit: BoxFit.cover,
            width: 90,
            height: 90,
          ),
        ),
      ),
    );
  }
}
