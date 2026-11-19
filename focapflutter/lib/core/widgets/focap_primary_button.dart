import 'package:flutter/material.dart';
import 'package:focapflutter/core/theme/app_colors.dart';
import 'package:focapflutter/core/theme/app_shape.dart';
import 'package:focapflutter/core/theme/app_typography.dart';

class FocapPrimaryButton extends StatelessWidget {
  const FocapPrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.showArrow = false,
    this.busy = false,
    this.busyLabel,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool showArrow;
  final bool busy;
  final String? busyLabel;

  static const double height = 56;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final enabled = onPressed != null && !busy;

    return Semantics(
      button: true,
      enabled: enabled,
      label: busy ? busyLabel ?? label : label,
      onTap: enabled ? onPressed : null,
      excludeSemantics: true,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: onPressed == null ? 0.5 : 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: FocapShape.button,
            boxShadow: [
              BoxShadow(
                color: colors.accent.withValues(alpha: dark ? 0.25 : 0.35),
                offset: const Offset(0, 10),
                blurRadius: 24,
              ),
            ],
          ),
          child: Material(
            color: colors.accent,
            borderRadius: FocapShape.button,
            child: InkWell(
              borderRadius: FocapShape.button,
              onTap: enabled ? onPressed : null,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: height),
                child: Center(
                  child: busy
                      ? SizedBox.square(
                          dimension: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: colors.onAccent,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                label,
                                textAlign: TextAlign.center,
                                style: FocapText.row.copyWith(
                                  fontSize: 16,
                                  color: colors.onAccent,
                                ),
                              ),
                            ),
                            if (showArrow) ...[
                              const SizedBox(width: 8),
                              CustomPaint(
                                size: const Size.square(18),
                                painter: _ArrowPainter(colors.onAccent),
                              ),
                            ],
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  const _ArrowPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 18;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.65 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final tip = Offset(14.25 * scale, 9 * scale);
    final path = Path()
      ..moveTo(3.75 * scale, 9 * scale)
      ..lineTo(tip.dx, tip.dy)
      ..moveTo(9.75 * scale, 4.5 * scale)
      ..lineTo(tip.dx, tip.dy)
      ..lineTo(9.75 * scale, 13.5 * scale);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ArrowPainter oldDelegate) => oldDelegate.color != color;
}
