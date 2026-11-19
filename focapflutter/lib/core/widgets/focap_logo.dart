import 'package:flutter/material.dart';
import 'package:focapflutter/core/theme/app_colors.dart';

class FocapLogo extends StatelessWidget {
  const FocapLogo({super.key});

  static const double size = 52;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: colors.accent,
        borderRadius: const BorderRadius.all(Radius.circular(18)),
      ),
      child: CustomPaint(painter: _LogoMarkPainter(colors.onAccent)),
    );
  }
}

class _LogoMarkPainter extends CustomPainter {
  const _LogoMarkPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / FocapLogo.size;
    final ring = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * scale;
    canvas.drawCircle(Offset(26 * scale, 29 * scale), 9.5 * scale, ring);
    canvas.drawRRect(
      RRect.fromLTRBR(
        18 * scale,
        11 * scale,
        34 * scale,
        14 * scale,
        Radius.circular(2 * scale),
      ),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(_LogoMarkPainter oldDelegate) =>
      oldDelegate.color != color;
}
