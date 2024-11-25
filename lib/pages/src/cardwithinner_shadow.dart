import 'package:flutter/material.dart';

class InnerShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    // Right side shadow
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.92, 8, size.width * 0.04, size.height*0.8),
      paint,
    );

    // Bottom side shadow
    canvas.drawRect(
      Rect.fromLTWH(9, size.height * 0.92, size.width*0.75, size.height * 0.04),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
