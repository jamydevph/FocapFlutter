import 'package:flutter/material.dart';
import 'package:focapflutter/core/theme/app_colors.dart';
import 'package:focapflutter/core/theme/app_shape.dart';
import 'package:focapflutter/core/theme/app_typography.dart';

abstract final class FocapTheme {
  static final light = _build(FocapColors.light, Brightness.light);
  static final dark = _build(FocapColors.dark, Brightness.dark);

  static ThemeData _build(FocapColors c, Brightness brightness) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: c.accent,
      onPrimary: c.onAccent,
      primaryContainer: c.accentSoft,
      onPrimaryContainer: c.accentText,
      secondary: c.hero,
      onSecondary: Colors.white,
      secondaryContainer: c.accentSoft,
      onSecondaryContainer: c.accentText,
      error: c.danger,
      onError: c.onAccent,
      surface: c.surface,
      onSurface: c.ink,
      onSurfaceVariant: c.soft,
      outline: c.line,
      outlineVariant: c.hairline,
    );

    final textTheme = const TextTheme(
      displayLarge: FocapText.timer,
      headlineLarge: FocapText.title,
      headlineSmall: FocapText.titleSmall,
      titleMedium: FocapText.row,
      labelLarge: FocapText.row,
      bodyLarge: FocapText.body,
      bodyMedium: FocapText.body,
      bodySmall: FocapText.bodySmall,
      labelMedium: FocapText.label,
      labelSmall: FocapText.label,
    ).apply(bodyColor: c.ink, displayColor: c.ink);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: FocapText.fontFamily,
      textTheme: textTheme,
      scaffoldBackgroundColor: c.bg,
      dividerTheme: DividerThemeData(color: c.line, thickness: 1, space: 1),
      extensions: [c],
      appBarTheme: AppBarTheme(
        backgroundColor: c.bg,
        foregroundColor: c.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: FocapText.row.copyWith(color: c.ink),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.accent,
          foregroundColor: c.onAccent,
          minimumSize: const Size(64, 54),
          textStyle: FocapText.row,
          shape: const RoundedRectangleBorder(borderRadius: FocapShape.button),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.accentText,
          textStyle: FocapText.row,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.field,
        hintStyle: FocapText.body.copyWith(color: c.soft),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: FocapShape.button,
          borderSide: BorderSide(color: c.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: FocapShape.button,
          borderSide: BorderSide(color: c.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: FocapShape.button,
          borderSide: BorderSide(color: c.accent, width: 1.5),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? c.accent : c.off,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
    );
  }
}
