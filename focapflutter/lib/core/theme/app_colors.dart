import 'package:flutter/material.dart';

@immutable
class FocapColors extends ThemeExtension<FocapColors> {
  const FocapColors({
    required this.bg,
    required this.surface,
    required this.field,
    required this.ink,
    required this.soft,
    required this.line,
    required this.hairline,
    required this.hero,
    required this.heroDeep,
    required this.accent,
    required this.onAccent,
    required this.accentSoft,
    required this.accentText,
    required this.block,
    required this.blockText,
    required this.ok,
    required this.okText,
    required this.warm,
    required this.warmText,
    required this.danger,
    required this.grey,
    required this.greyText,
    required this.off,
    required this.nav,
    required this.navFg,
    required this.cap,
  });

  final Color bg;

  final Color surface;

  final Color field;

  final Color ink;

  final Color soft;

  final Color line;

  final Color hairline;

  final Color hero;

  final Color heroDeep;

  final Color accent;

  final Color onAccent;

  final Color accentSoft;

  final Color accentText;

  final Color block;

  final Color blockText;

  final Color ok;

  final Color okText;

  final Color warm;

  final Color warmText;

  final Color danger;

  final Color grey;

  final Color greyText;

  final Color off;

  final Color nav;

  final Color navFg;

  final Color cap;

  static const light = FocapColors(
    bg: Color(0xFFF3F4F9),
    surface: Color(0xFFFFFFFF),
    field: Color(0xFFF7F8FC),
    ink: Color(0xFF0E1024),
    soft: Color(0xFF5B5F78),
    line: Color(0xFFE4E6EF),
    hairline: Color(0xFFEEF0F6),
    hero: Color(0xFF14163A),
    heroDeep: Color(0xFF14163A),
    accent: Color(0xFF4F46E5),
    onAccent: Color(0xFFFFFFFF),
    accentSoft: Color(0xFFECEBFF),
    accentText: Color(0xFF4338CA),
    block: Color(0xFFFFE4E8),
    blockText: Color(0xFFB4233A),
    ok: Color(0xFFDDF7EE),
    okText: Color(0xFF0F6E4D),
    warm: Color(0xFFFFF1DC),
    warmText: Color(0xFF9A5B00),
    danger: Color(0xFFC2263C),
    grey: Color(0xFFECEDF3),
    greyText: Color(0xFF5B5F78),
    off: Color(0xFFD5D8E5),
    nav: Color(0xFF14163A),
    navFg: Color(0xFFC9CBE6),
    cap: Color(0xFFD4FF4F),
  );

  static const dark = FocapColors(
    bg: Color(0xFF0B0C14),
    surface: Color(0xFF161827),
    field: Color(0xFF1C1E30),
    ink: Color(0xFFF2F3FA),
    soft: Color(0xFFA2A6BF),
    line: Color(0xFF2C2F48),
    hairline: Color(0xFF23263B),
    hero: Color(0xFF1E1F3D),
    heroDeep: Color(0xFF0B0C14),
    accent: Color(0xFF8B85FF),
    onAccent: Color(0xFF0B0C14),
    accentSoft: Color(0xFF24234A),
    accentText: Color(0xFFB3AEFF),
    block: Color(0xFF3A1A24),
    blockText: Color(0xFFFF9AAA),
    ok: Color(0xFF12342A),
    okText: Color(0xFF6FE0B5),
    warm: Color(0xFF3A2A10),
    warmText: Color(0xFFFFC46B),
    danger: Color(0xFFFF8A99),
    grey: Color(0xFF23263B),
    greyText: Color(0xFFA2A6BF),
    off: Color(0xFF3A3D57),
    nav: Color(0xFF1C1E30),
    navFg: Color(0xFFC9CBE6),
    cap: Color(0xFFD4FF4F),
  );

  List<(String, Color)> get named => [
    ('bg', bg),
    ('surface', surface),
    ('field', field),
    ('ink', ink),
    ('soft', soft),
    ('line', line),
    ('hairline', hairline),
    ('hero', hero),
    ('heroDeep', heroDeep),
    ('accent', accent),
    ('onAccent', onAccent),
    ('accentSoft', accentSoft),
    ('accentText', accentText),
    ('block', block),
    ('blockText', blockText),
    ('ok', ok),
    ('okText', okText),
    ('warm', warm),
    ('warmText', warmText),
    ('danger', danger),
    ('grey', grey),
    ('greyText', greyText),
    ('off', off),
    ('nav', nav),
    ('navFg', navFg),
    ('cap', cap),
  ];

  @override
  FocapColors copyWith() => this;

  @override
  FocapColors lerp(FocapColors? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return FocapColors(
      bg: mix(bg, other.bg),
      surface: mix(surface, other.surface),
      field: mix(field, other.field),
      ink: mix(ink, other.ink),
      soft: mix(soft, other.soft),
      line: mix(line, other.line),
      hairline: mix(hairline, other.hairline),
      hero: mix(hero, other.hero),
      heroDeep: mix(heroDeep, other.heroDeep),
      accent: mix(accent, other.accent),
      onAccent: mix(onAccent, other.onAccent),
      accentSoft: mix(accentSoft, other.accentSoft),
      accentText: mix(accentText, other.accentText),
      block: mix(block, other.block),
      blockText: mix(blockText, other.blockText),
      ok: mix(ok, other.ok),
      okText: mix(okText, other.okText),
      warm: mix(warm, other.warm),
      warmText: mix(warmText, other.warmText),
      danger: mix(danger, other.danger),
      grey: mix(grey, other.grey),
      greyText: mix(greyText, other.greyText),
      off: mix(off, other.off),
      nav: mix(nav, other.nav),
      navFg: mix(navFg, other.navFg),
      cap: mix(cap, other.cap),
    );
  }
}

extension FocapColorsContext on BuildContext {
  FocapColors get colors => Theme.of(this).extension<FocapColors>()!;
}
