import 'package:flutter/material.dart';

abstract final class FocapShape {
  static const double chipRadius = 14;
  static const double buttonRadius = 16;
  static const double cardRadius = 20;
  static const double cardRadiusLarge = 28;

  static const chip = BorderRadius.all(Radius.circular(chipRadius));
  static const button = BorderRadius.all(Radius.circular(buttonRadius));
  static const card = BorderRadius.all(Radius.circular(cardRadius));
  static const cardLarge = BorderRadius.all(Radius.circular(cardRadiusLarge));

  static const shadowSoft = [
    BoxShadow(color: Color(0x120E1024), offset: Offset(0, 6), blurRadius: 18),
  ];

  static const shadowRaised = [
    BoxShadow(color: Color(0x1A0E1024), offset: Offset(0, 12), blurRadius: 32),
  ];
}
