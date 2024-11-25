import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UnicornOutlineButtonGlow extends StatelessWidget {
  final _GradientPainter _painter;
  final Widget _child;
  UnicornOutlineButtonGlow({
    super.key,
    required double strokeWidth,
    required double radius,
    required Gradient gradient,
    required Widget child,
  })  : _painter = _GradientPainter(
      strokeWidth: strokeWidth, radius: radius, gradient: gradient),
        _child = child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _painter,
      child: Container(
        decoration: BoxDecoration(
          borderRadius:  BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurStyle: BlurStyle.outer,
              color: const Color.fromRGBO(24, 184, 196, 1).withOpacity(1),
              blurRadius: 15,
              spreadRadius: -3,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _child,
          ],
        ),
      ),
    );
  }
}

class _GradientPainter extends CustomPainter {
  final Paint _paint = Paint();
  final double radius;
  final double strokeWidth;
  final Gradient gradient;

  _GradientPainter(
      {required double strokeWidth,
        required double radius,
        required Gradient gradient})
      : this.strokeWidth = strokeWidth,
        this.radius = radius,
        this.gradient = gradient;

  @override
  void paint(Canvas canvas, Size size) {
    // create outer rectangle equals size
    Rect outerRect = Offset.zero & size;
    var outerRRect =
    RRect.fromRectAndRadius(outerRect, Radius.circular(radius));

    // create inner rectangle smaller by strokeWidth
    Rect innerRect = Rect.fromLTWH(strokeWidth, strokeWidth,
        size.width - strokeWidth * 2, size.height - strokeWidth * 2);
    var innerRRect = RRect.fromRectAndRadius(
        innerRect, Radius.circular(radius - strokeWidth));

    // apply gradient shader
    _paint.shader = gradient.createShader(outerRect);

    // create difference between outer and inner paths and draw it
    Path path1 = Path()..addRRect(outerRRect);
    Path path2 = Path()..addRRect(innerRRect);
    var path = Path.combine(PathOperation.difference, path1, path2);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}