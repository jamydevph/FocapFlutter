import 'package:flutter/material.dart';

abstract final class FocapText {
  static const fontFamily = 'Poppins';

  static const timer = TextStyle(
    fontFamily: fontFamily,
    fontSize: 62,
    fontWeight: FontWeight.w700,
    letterSpacing: -2,
    height: 1.1,
  );

  static const title = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
    height: 1.2,
  );

  static const titleSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
    height: 1.25,
  );

  static const row = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
  );

  static const body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.5,
  );

  static const bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.5,
  );

  static const label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.4,
  );

  static const navLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.5,
  );
}
