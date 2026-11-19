import 'package:flutter/material.dart';
import 'package:focapflutter/core/theme/app_colors.dart';
import 'package:focapflutter/core/theme/app_typography.dart';

class FocapErrorRow extends StatelessWidget {
  const FocapErrorRow(this.message, {super.key, this.announce = true});

  final String message;
  final bool announce;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.danger;
    return Semantics(
      liveRegion: announce,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: CustomPaint(
              size: const Size.square(15),
              painter: _AlertIconPainter(color),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              message,
              style: FocapText.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
                height: 20 / 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertIconPainter extends CustomPainter {
  const _AlertIconPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 15;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * scale
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawCircle(Offset(7.5 * scale, 7.5 * scale), 5.625 * scale, paint)
      ..drawLine(
        Offset(7.5 * scale, 5 * scale),
        Offset(7.5 * scale, 8.125 * scale),
        paint,
      )
      ..drawLine(
        Offset(7.5 * scale, 10.3125 * scale),
        Offset(7.5 * scale, 10.625 * scale),
        paint,
      );
  }

  @override
  bool shouldRepaint(_AlertIconPainter oldDelegate) =>
      oldDelegate.color != color;
}
