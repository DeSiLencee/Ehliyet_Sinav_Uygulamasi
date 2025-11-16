import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final Color _lightBackground = Color(0xFFF8FAFC);
  static final Color _lightPrimary = Color(0xFF2563EB); // Mavi
  static final Color _lightSecondary = Color(0xFF22C55E); // Doğru
  static final Color _lightAccent = Color(0xFFEF4444); // Yanlış
  static final Color _lightText = Color(0xFF0F172A);

  static final Color _darkBackground = Color(0xFF0B1320);
  static final Color _darkPrimary = Color(0xFF60A5FA);
  static final Color _darkSecondary = Color(0xFF34D399); // Doğru
  static final Color _darkAccent = Color(0xFFF87171); // Yanlış
  static final Color _darkText = Color(0xFFE5E7EB);

  static final ButtonStyle _buttonStyle = ElevatedButton.styleFrom(
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0), // 12-16px radius
    ),
    minimumSize: Size(44, 44), // Minimum touch target
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: _lightBackground,
    primaryColor: _lightPrimary,
    colorScheme: ColorScheme.light(
      primary: _lightPrimary,
      secondary: _lightSecondary,
      error: _lightAccent,
      surface: _lightBackground,
      onSurface: _lightText,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onError: Colors.white,
    ),
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.light().textTheme.apply(
            bodyColor: _lightText,
            displayColor: _lightText,
          ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: _buttonStyle),
    appBarTheme: AppBarTheme(
      backgroundColor: _lightBackground,
      foregroundColor: _lightText,
      elevation: 0,
    ),
    // Add other theme properties as needed
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _darkBackground,
    primaryColor: _darkPrimary,
    colorScheme: ColorScheme.dark(
      primary: _darkPrimary,
      secondary: _darkSecondary,
      error: _darkAccent,
      surface: _darkBackground,
      onSurface: _darkText,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      onError: Colors.black,
    ),
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme.apply(
            bodyColor: _darkText,
            displayColor: _darkText,
          ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: _buttonStyle),
    appBarTheme: AppBarTheme(
      backgroundColor: _darkBackground,
      foregroundColor: _darkText,
      elevation: 0,
    ),
    // Add other theme properties as needed
  );
}