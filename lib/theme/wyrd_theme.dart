import 'package:flutter/material.dart';

class WyrdTheme {
  static const Color voidBlack = Color(0xFF0A0C0A);
  static const Color darkIron = Color(0xFF1A1F1A);
  static const Color borderIron = Color(0xFF2C382C);
  static const Color boneWhite = Color(0xFFE5DFC9);
  static const Color brassGild = Color(0xFFD4AF37);
  static const Color runeAmber = Color(0xFFFFB000);
  static const Color glowGreen = Color(0xFF33FF33);
  static const Color shadowCrimson = Color(0xFF7A1C1C);

  static TextStyle get titleStyle => const TextStyle(
    fontFamily: 'serif',
    color: brassGild,
    fontSize: 20.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 2.5,
  );

  static TextStyle get subtitleStyle => const TextStyle(
    fontFamily: 'monospace',
    color: runeAmber,
    fontSize: 12.0,
    letterSpacing: 1.5,
  );

  static TextStyle get bodyStyle => const TextStyle(
    fontFamily: 'monospace',
    color: boneWhite,
    fontSize: 13.0,
    height: 1.4,
  );

  static BoxDecoration get ironCardDecoration => BoxDecoration(
    color: darkIron,
    border: Border.all(color: borderIron, width: 1.5),
    borderRadius: BorderRadius.circular(6.0),
  );
}
