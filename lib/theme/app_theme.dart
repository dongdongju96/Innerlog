import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Innerlog/theme/color_schemes.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      primaryColor: AppColors.accentColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.accentColor,
        primary: AppColors.accentColor,
        secondary: AppColors.accentColor,
        surface: AppColors.backgroundColor,
        onSurface: AppColors.primaryTextColor,
      ),
      textTheme: GoogleFonts.loraTextTheme().apply(
        bodyColor: AppColors.primaryTextColor,
        displayColor: AppColors.primaryTextColor,
      ).copyWith(
        bodyLarge: GoogleFonts.lora(
          color: AppColors.primaryTextColor,
          height: 1.5,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.lora(
          color: AppColors.primaryTextColor,
          height: 1.5,
          fontSize: 14,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.primaryTextColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Lora', // Ensure font consistency
        ),
        iconTheme: IconThemeData(color: AppColors.primaryTextColor),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.accentColor,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accentColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.lora(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
