import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Centralized color scheme
class AppColors {
  static const Color primary = Color(0xFFF9A825); // A vibrant amber/gold
  static const Color background = Color(0xFF121212); // A very dark grey
  static const Color surface = Color(
    0xFF1E1E1E,
  ); // A slightly lighter dark grey for cards
  static const Color onSurface = Color(0xFFE0E0E0); // A light grey for text
  static const Color error = Color(0xFFCF6679);
}

final appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.dark().copyWith(
    primary: AppColors.primary,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    error: AppColors.error,
  ),
  scaffoldBackgroundColor: AppColors.background,
  textTheme: GoogleFonts.poppinsTextTheme(
    ThemeData.dark().textTheme,
  ).apply(bodyColor: AppColors.onSurface, displayColor: AppColors.onSurface),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 12.0,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
    ),
    labelStyle: const TextStyle(color: AppColors.onSurface),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.black,
      minimumSize: const Size(double.infinity, 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary.withAlpha(204),
      textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
    ),
  ),
  // **THE ENHANCEMENT IS HERE:**
  // A new theme for all Card widgets in the app.
  cardTheme: CardTheme(
    elevation: 1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
      side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
    ),
  ),
  // A new theme for all Dialog widgets.
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
  ),
);
