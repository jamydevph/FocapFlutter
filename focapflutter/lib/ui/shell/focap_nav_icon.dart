import 'dart:math' as math;

import 'package:flutter/material.dart';

enum FocapNavGlyph { focus, history, settings }

class FocapNavIcon extends StatelessWidget {
  const FocapNavIcon(
    this.glyph, {
    required this.color,
    this.size = 20,
    super.key,
  });

  final FocapNavGlyph glyph;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _NavGlyphPainter(glyph: glyph, color: color),
    );
  }
}

class _NavGlyphPainter extends CustomPainter {
  const _NavGlyphPainter({required this.glyph, required this.color});

  final FocapNavGlyph glyph;
  final Color color;

  static const designSize = 20.0;
  static const strokeWidth = 5 / 3;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / designSize;
    canvas.scale(scale);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;
    switch (glyph) {
      case FocapNavGlyph.focus:
        _paintFocus(canvas, paint);
      case FocapNavGlyph.history:
        _paintHistory(canvas, paint);
      case FocapNavGlyph.settings:
        _paintSettings(canvas, paint);
    }
  }

  void _paintFocus(Canvas canvas, Paint paint) {
    const center = Offset(10, 10);
    canvas.drawCircle(center, 20 / 3, paint);
    canvas.drawCircle(center, 2.5, paint);
  }

  void _paintHistory(Canvas canvas, Paint paint) {
    final dial = Path()
      ..moveTo(2.5, 10)
      ..arcTo(
        Rect.fromCircle(center: const Offset(10, 10), radius: 7.5),
        math.pi,
        -3 * math.pi / 2,
        false,
      )
      ..arcToPoint(
        const Offset(4.38, 4.78),
        radius: const Radius.circular(8.125),
        clockwise: false,
      )
      ..lineTo(2.5, 20 / 3);
    final arrow = Path()
      ..moveTo(2.5, 2.5)
      ..lineTo(2.5, 20 / 3)
      ..lineTo(20 / 3, 20 / 3);
    final hands = Path()
      ..moveTo(10, 35 / 6)
      ..lineTo(10, 10)
      ..lineTo(12.5, 35 / 3);
    canvas.drawPath(dial, paint);
    canvas.drawPath(arrow, paint);
    canvas.drawPath(hands, paint);
  }

  void _paintSettings(Canvas canvas, Paint paint) {
    const top = 35 / 6;
    const bottom = 85 / 6;
    const knobRadius = 25 / 12;
    canvas.drawLine(
      const Offset(10 / 3, top),
      const Offset(35 / 3, top),
      paint,
    );
    canvas.drawLine(const Offset(15, top), const Offset(50 / 3, top), paint);
    canvas.drawCircle(const Offset(40 / 3, top), knobRadius, paint);
    canvas.drawLine(
      const Offset(10 / 3, bottom),
      const Offset(5, bottom),
      paint,
    );
    canvas.drawLine(
      const Offset(25 / 3, bottom),
      const Offset(50 / 3, bottom),
      paint,
    );
    canvas.drawCircle(const Offset(20 / 3, bottom), knobRadius, paint);
  }

  @override
  bool shouldRepaint(_NavGlyphPainter oldDelegate) =>
      oldDelegate.glyph != glyph || oldDelegate.color != color;
}
