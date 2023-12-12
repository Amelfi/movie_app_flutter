import 'package:flutter/material.dart';

class CustomTheme {
  
  static const Color primary = Colors.indigo;

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    appBarTheme:  const AppBarTheme(
      backgroundColor: primary,
      titleTextStyle:  TextStyle(color: Colors.white)
    )
  );
  
}
