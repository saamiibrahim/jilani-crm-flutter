import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DesignSystem {
  // Colors
  static const Color primary = Color(0xFFFFD796);
  static const Color onPrimary = Color(0xFF422C00);
  static const Color primaryContainer = Color(0xFFE8BA6A); // Used as Primary brand color
  static const Color onPrimaryContainer = Color(0xFF694900);
  
  static const Color secondary = Color(0xFFC8C6C5);
  static const Color onSecondary = Color(0xFF303030);
  
  // Updated Colors based on Jillani Executive CRM Design System
  static const Color surface = Color(0xFF121414); // Base background
  static const Color surfaceContainerLow = Color(0xFF1A1A1A); // Tertiary (App Bars / Nav)
  static const Color surfaceContainer = Color(0xFF262626); // Secondary (Cards/Inputs)
  static const Color surfaceContainerHigh = Color(0xFF333333); // Level 2 (Modals/Overlays)
  
  static const Color onSurface = Color(0xFFE2E2E2);
  static const Color onSurfaceVariant = Color(0xFFD2C5B3);
  static const Color background = Color(0xFF121414);
  static const Color onBackground = Color(0xFFE2E2E2);
  
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
        primary: primaryContainer,
        onPrimary: onPrimaryContainer,
        secondary: surfaceContainer,
        onSecondary: onSurface,
        surface: surface,
        onSurface: onSurface,
        error: error,
        onError: onError,
      ),
      textTheme: TextTheme(
        // Body (Inter)
        bodyLarge: GoogleFonts.inter(color: onSurface, fontSize: 18, fontWeight: FontWeight.w400, height: 1.55),
        bodyMedium: GoogleFonts.inter(color: onSurface, fontSize: 16, fontWeight: FontWeight.w400, height: 1.5),
        bodySmall: GoogleFonts.inter(color: onSurface, fontSize: 14, fontWeight: FontWeight.w400, height: 1.42),
        labelLarge: GoogleFonts.inter(color: onSurface, fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.05, height: 1.14),
        labelMedium: GoogleFonts.inter(color: onSurface, fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.02, height: 1.33),
        labelSmall: GoogleFonts.inter(color: onSurface, fontSize: 10, fontWeight: FontWeight.w700, height: 1.2),
        
        // Headlines (Manrope)
        headlineLarge: GoogleFonts.manrope(color: onSurface, fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.02, height: 1.25),
        headlineMedium: GoogleFonts.manrope(color: onSurface, fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: -0.01, height: 1.33),
        headlineSmall: GoogleFonts.manrope(color: onSurface, fontSize: 20, fontWeight: FontWeight.w600, height: 1.4),
        
        // Aliases for typical material uses
        titleLarge: GoogleFonts.manrope(color: onSurface, fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: -0.01),
        titleMedium: GoogleFonts.manrope(color: onSurface, fontSize: 20, fontWeight: FontWeight.w600),
        titleSmall: GoogleFonts.manrope(color: onSurface, fontSize: 16, fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceContainerLow,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.manrope(color: onSurface, fontSize: 20, fontWeight: FontWeight.w600),
        iconTheme: const IconThemeData(color: primaryContainer),
      ),
      cardTheme: CardThemeData(
        color: surfaceContainer, // Level 1 (Cards/Inputs)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // 0.5rem (8px) for cards
          side: BorderSide(color: Colors.white.withValues(alpha: 0.05)), // Thin border for luxury
        ),
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20), // 20px mobile safe margin
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainer, // Level 1
        labelStyle: GoogleFonts.inter(color: onSurfaceVariant),
        hintStyle: GoogleFonts.inter(color: onSurfaceVariant.withValues(alpha: 0.5)),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white24, width: 1),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white24, width: 1), // #FFFFFF (20% opacity)
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: primaryContainer, width: 2), // #E8BA6A active
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryContainer,
          foregroundColor: surfaceContainerLow,
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4), // 4px base radius for small buttons
          ),
          elevation: 0,
          shadowColor: primaryContainer.withValues(alpha: 0.15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryContainer,
          side: const BorderSide(color: primaryContainer, width: 1), // Ghost style
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: textNeutral.withValues(alpha: 0.7), // Text-only with #FFFFFF at 70% opacity
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryContainer,
        foregroundColor: surfaceContainerLow,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28), // Fully rounded for FAB
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceContainerLow,
        selectedItemColor: primaryContainer,
        unselectedItemColor: onSurfaceVariant,
        selectedLabelStyle: GoogleFonts.manrope(fontWeight: FontWeight.w600, fontSize: 10, letterSpacing: 1.0),
        unselectedLabelStyle: GoogleFonts.manrope(fontWeight: FontWeight.w500, fontSize: 10, letterSpacing: 1.0),
        type: BottomNavigationBarType.fixed,
        elevation: 10,
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
        checkColor: WidgetStateProperty.all(surfaceContainerLow),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: const BorderSide(color: onSurfaceVariant),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surfaceContainerHigh, // Level 2
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: primaryContainer.withValues(alpha: 0.15), width: 1), // subtle 1px border
        ),
        elevation: 8,
      ),
    );
  }
}
