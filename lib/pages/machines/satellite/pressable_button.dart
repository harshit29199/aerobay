import 'package:flutter/material.dart';

class ConcentricCirclesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    double radius1 = size.width * 0.25;
    double radius2 = size.width * 0.5;

    // Draw inner circle
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius1, paint);

    // Draw outer circle
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}