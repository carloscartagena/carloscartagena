import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String initials;
  final String colorHex;
  final double radius;

  const Avatar({
    super.key,
    required this.initials,
    required this.colorHex,
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    try {
      color = Color(int.parse(colorHex, radix: 16));
    } catch (_) {
      color = Colors.deepPurple;
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: color,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: radius * 0.7,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
