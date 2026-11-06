import 'package:flutter/material.dart';

class TabularText extends StatelessWidget {
  const TabularText(this.text, {required this.style, super.key});

  final String text;
  final TextStyle style;

  static const _digits = '0123456789';

  @override
  Widget build(BuildContext context) {
    final resolved = DefaultTextStyle.of(context).style.merge(style);
    final scaler = MediaQuery.textScalerOf(context);
    final direction = Directionality.of(context);

    var cell = 0.0;
    for (final digit in _digits.characters) {
      final painter = TextPainter(
        text: TextSpan(text: digit, style: resolved),
        textDirection: direction,
        textScaler: scaler,
      )..layout();
      if (painter.width > cell) cell = painter.width;
      painter.dispose();
    }

    return Semantics(
      label: text,
      excludeSemantics: true,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.ltr,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            for (final char in text.characters)
              if (_digits.contains(char))
                SizedBox(
                  width: cell,
                  child: Text(
                    char,
                    style: resolved,
                    textAlign: TextAlign.center,
                    textScaler: scaler,
                  ),
                )
              else
                Text(char, style: resolved, textScaler: scaler),
          ],
        ),
      ),
    );
  }
}
