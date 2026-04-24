import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DesignSystem {
  // Colors
  static const Color backgroundDark = Color(0xFF121212);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color primaryGold = Color(0xFFC5A059);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA0A0A0);

  // Status Colors
  static const Color statusGreen = Color(0xFF4CAF50);
  static const Color statusPurple = Color(0xFF9C27B0);
  static const Color statusRed = Color(0xFFF44336);
  static const Color statusBlue = Color(0xFF2196F3);

  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      primaryColor: primaryGold,
      colorScheme: const ColorScheme.dark(
        primary: primaryGold,
        onPrimary: textPrimary,
        secondary: primaryGold,
        surface: cardDark,
        onSurface: textPrimary,

      ),
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.montserrat(color: textPrimary, fontSize: 16),
        bodyMedium: GoogleFonts.montserrat(color: textPrimary, fontSize: 14),
        bodySmall: GoogleFonts.montserrat(color: textSecondary, fontSize: 12),
        labelLarge: GoogleFonts.montserrat(color: textPrimary, fontWeight: FontWeight.bold),
        
        // App Bar titles, large numbers, Campaign names
        titleLarge: GoogleFonts.playfairDisplay(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 22),
        titleMedium: GoogleFonts.playfairDisplay(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 18),
        headlineLarge: GoogleFonts.playfairDisplay(color: primaryGold, fontWeight: FontWeight.w600, fontSize: 32),
        headlineMedium: GoogleFonts.playfairDisplay(color: primaryGold, fontWeight: FontWeight.w600, fontSize: 24),
        headlineSmall: GoogleFonts.playfairDisplay(color: primaryGold, fontWeight: FontWeight.w600, fontSize: 20),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 22),
        iconTheme: const IconThemeData(color: primaryGold),
      ),
      cardTheme: CardThemeData(
        color: cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        labelStyle: GoogleFonts.montserrat(color: textSecondary),
        hintStyle: GoogleFonts.montserrat(color: textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryGold, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: statusRed),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGold,
          foregroundColor: textPrimary,
          textStyle: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryGold,
        foregroundColor: textPrimary,
        elevation: 4,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: backgroundDark,
        selectedItemColor: primaryGold,
        unselectedItemColor: textSecondary,
        selectedLabelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.normal, fontSize: 12),
        type: BottomNavigationBarType.fixed,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: primaryGold,
        unselectedLabelColor: textSecondary,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: primaryGold, width: 3),
        ),
        labelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryGold;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(backgroundDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: const BorderSide(color: textSecondary),
      ),
    );
  }
}
