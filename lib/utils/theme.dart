import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
      primarySwatch: Colors.indigo,
      fontFamily: 'AppFonts',
      splashColor: Colors.transparent,
      textTheme: textTheme);

  static TextTheme textTheme = const TextTheme(
    bodyLarge: TextStyle(fontSize: 22.0),
    bodyMedium: TextStyle(fontSize: 18.0),
    bodySmall: TextStyle(fontSize: 16.0),
    labelLarge: TextStyle(fontSize: 22.0),
    labelMedium: TextStyle(fontSize: 18.0),
    labelSmall: TextStyle(fontSize: 16.0),
  );
}
