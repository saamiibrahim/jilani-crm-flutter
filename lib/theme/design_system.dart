import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DesignSystem {
  // Colors (from Professional Slate design system)
  static const Color primary = Color(0xFFE9C176);
  static const Color onPrimary = Color(0xFF412D00);
  static const Color primaryContainer = Color(0xFFC5A059);
  static const Color onPrimaryContainer = Color(0xFF4E3700);
  
  static const Color secondary = Color(0xFFC4C6CB);
  static const Color onSecondary = Color(0xFF2E3135);
  
  static const Color surface = Color(0xFF0C141D); // Base background
  static const Color surfaceContainerLow = Color(0xFF141C25); // App Bars / Nav
  static const Color surfaceContainer = Color(0xFF182029); // Cards / Inputs
  static const Color surfaceContainerHigh = Color(0xFF232B34); // Modals / Overlays
  
  static const Color onSurface = Color(0xFFDBE3F0);
  static const Color onSurfaceVariant = Color(0xFFD1C5B4);
  static const Color background = Color(0xFF0C141D);
  static const Color onBackground = Color(0xFFDBE3F0);
  
  static const Color outline = Color(0xFF9A8F80);
  static const Color outlineVariant = Color(0xFF4E4639);

  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
  
  static const Color textNeutral = Color(0xFFFFFFFF);

  // Status Colors
  static const Color statusGreen = Color(0xFF4CAF50);
  static const Color statusRed = Color(0xFFF44336);

  static ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: surface,
      primaryColor: primaryContainer,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: surfaceContainer,
        onSecondary: onSurface,
        surface: surface,
        onSurface: onSurface,
        error: error,
        onError: onError,
      ),
      textTheme: TextTheme(
        // Body (Inter)
        bodyLarge: GoogleFonts.inter(color: onSurface, fontSize: 16, fontWeight: FontWeight.w400, height: 1.5),
        bodyMedium: GoogleFonts.inter(color: onSurface, fontSize: 14, fontWeight: FontWeight.w400, height: 1.5),
        bodySmall: GoogleFonts.inter(color: onSurface, fontSize: 13, fontWeight: FontWeight.w500, height: 1.2), // Data Tabular
        labelLarge: GoogleFonts.inter(color: onSurface, fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.05, height: 1.14),
        labelMedium: GoogleFonts.inter(color: onSurface, fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.02, height: 1.33),
        labelSmall: GoogleFonts.inter(color: onSurface, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.55, height: 1.0), // Label Caps
        
        // Headlines (Manrope)
        headlineLarge: GoogleFonts.manrope(color: onSurface, fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.64, height: 1.2),
        headlineMedium: GoogleFonts.manrope(color: onSurface, fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: -0.24, height: 1.2),
        headlineSmall: GoogleFonts.manrope(color: onSurface, fontSize: 18, fontWeight: FontWeight.w600, height: 1.4),
        
        // Aliases for typical material uses
        titleLarge: GoogleFonts.manrope(color: onSurface, fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: -0.24),
        titleMedium: GoogleFonts.manrope(color: onSurface, fontSize: 18, fontWeight: FontWeight.w600),
        titleSmall: GoogleFonts.inter(color: onSurface, fontSize: 14, fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceContainerLow,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.manrope(color: onSurface, fontSize: 18, fontWeight: FontWeight.w600),
        iconTheme: const IconThemeData(color: primaryContainer),
      ),
      cardTheme: CardThemeData(
        color: surfaceContainer, // Level 1 (Cards/Inputs)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4), // Strict 4px
          side: const BorderSide(color: outlineVariant, width: 1), // Low-contrast outline
        ),
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainer, // Level 1
        labelStyle: GoogleFonts.inter(color: onSurfaceVariant, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.55), // label-caps
        hintStyle: GoogleFonts.inter(color: onSurfaceVariant.withValues(alpha: 0.5)),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: outlineVariant, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: outlineVariant, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: primaryContainer, width: 1), // Gold on focus
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryContainer, // Matte Gold
          foregroundColor: onPrimaryContainer, // Dark text
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4), // 4px base radius
          ),
          elevation: 0, // No shadows
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textNeutral,
          side: const BorderSide(color: outlineVariant, width: 1), // Ghost style
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: textNeutral.withValues(alpha: 0.7), // Text-only
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryContainer,
        foregroundColor: onPrimaryContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4), // 4px for everything
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceContainerLow,
        selectedItemColor: primaryContainer,
        unselectedItemColor: onSurfaceVariant,
        selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 11, letterSpacing: 0.55),
        unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 11, letterSpacing: 0.55),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: primaryContainer,
        unselectedLabelColor: onSurfaceVariant,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: primaryContainer, width: 3),
        ),
        labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryContainer;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(onPrimaryContainer),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: const BorderSide(color: onSurfaceVariant),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceContainerHigh, // Level 2
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4), // 4px border radius
          side: const BorderSide(color: outlineVariant, width: 1), // 1px solid border
        ),
        elevation: 0, // No elevation shadow
      ),
    );
  }
}
