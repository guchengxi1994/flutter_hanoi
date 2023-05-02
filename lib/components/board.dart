import 'package:flutter/material.dart';

class HanoiBoard extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3;
    canvas.drawRect(
        Rect.fromLTWH(width * 0.1, height - 5, width * 0.8, 5), paint);
    canvas.save();
    canvas.drawLine(
        Offset(0.25 * width, 5), Offset(0.25 * width, height), paint);
    canvas.drawLine(Offset(0.5 * width, 5), Offset(0.5 * width, height), paint);
    canvas.drawLine(
        Offset(0.75 * width, 5), Offset(0.75 * width, height), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant HanoiBoard oldDelegate) {
    return oldDelegate != this;
  }
}
