import 'package:flutter/material.dart';

class AppShadows {
  // Light Mode Shadows
  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.05),
      blurRadius: 20,
      offset: Offset(0, 5),
    ),
  ];

  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.08),
      blurRadius: 40,
      offset: Offset(0, 10),
    ),
  ];

  static const List<BoxShadow> large = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.12),
      blurRadius: 50,
      offset: Offset(0, 15),
    ),
  ];

  // Dark Mode Shadows (Stronger Opacity)
  static const List<BoxShadow> softDark = [
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.3),
      blurRadius: 20,
      offset: Offset(0, 5),
    ),
  ];
}
