import 'package:flutter/material.dart';
import 'ripple_model.dart';

class RipplePainter extends CustomPainter {
  final List<Ripple> ripples;

  RipplePainter(this.ripples)
    : super(repaint: Listenable.merge(ripples.map((r) => r.controller)));

  @override
  void paint(Canvas canvas, Size size) {
    for (final ripple in ripples) {
      final progress = ripple.controller.value;
      final radius = progress * 100;
      final opacity = (1.0 - progress).clamp(0.0, 1.0);

      final paint =
          Paint()
            ..color = Colors.white.withOpacity(opacity)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2;

      canvas.drawCircle(ripple.position, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant RipplePainter oldDelegate) => true;
}

