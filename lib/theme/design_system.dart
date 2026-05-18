// Jillani Properties theme.
//
// Typography: Source Serif 4 (display / headlines / titles) + Inter (body / UI).
// Two palettes share the same type, radii and motion — only colour differs:
//   - Dark  = brand "Professional Slate" (the mobile spec; primary look).
//   - Light = official brand cream / navy / gold (colors_and_type.css).
//
// Colour tokens are exposed two ways:
//   - DesignSystem.<name>  : const dark-Slate values. Kept for `const` call
//                            sites and as the dark palette source. Do not remove.
//   - context.palette.<name>: theme-aware values (light or dark). New code and
//                            migrated widgets should read colours from here so
//                            the Light / Dark / System switch actually recolours.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DesignSystem {
  // ----- Dark "Professional Slate" tokens (also the dark palette) ---------
  static const Color primary = Color(0xFFE9C176);
  static const Color onPrimary = Color(0xFF412D00);
  static const Color primaryContainer = Color(0xFFC5A059);
  static const Color onPrimaryContainer = Color(0xFF4E3700);

  static const Color secondary = Color(0xFFC4C6CB);
  static const Color onSecondary = Color(0xFF2E3135);

  static const Color surface = Color(0xFF0C141D); // Base background
  static const Color surfaceContainerLow = Color(0xFF141C25); // App Bars / Nav
  static const Color surfaceContainer = Color(0xFF182029); // Cards / Inputs
  static const Color surfaceContainerHigh = Color(0xFF232B34); // Modals

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

  // ----- Light brand tokens (cream / navy / gold) ------------------------
  static const Color creamBg = Color(0xFFFBF9F4); // canvas
  static const Color surfaceLight = Color(0xFFFFFFFF); // cards / app bar
  static const Color surfaceAltLight = Color(0xFFF7F8FA); // raised / modals
  static const Color inkNavy = Color(0xFF08111F); // primary text
  static const Color fgMutedLight = Color(0xFF6B7488); // secondary text
  static const Color borderLight = Color(0xFFE2E6ED); // 1px borders
  static const Color dividerLight = Color(0xFFEFF1F5);
  static const Color goldBrand = Color(0xFFC9A24A); // gold-400
  static const Color onGold = Color(0xFF08111F); // ink on gold
  static const Color errorLight = Color(0xFFC0392B); // danger-500

  // ----- Type helpers ----------------------------------------------------
  static TextStyle serif({
    Color color = onSurface,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.w500,
    double height = 1.2,
    double letterSpacing = -0.01,
    FontStyle? fontStyle,
  }) {
    return GoogleFonts.sourceSerif4(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
      fontStyle: fontStyle,
    );
  }

  static TextStyle sans({
    Color color = onSurface,
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    double height = 1.45,
    double letterSpacing = 0,
  }) {
    return GoogleFonts.inter(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  // ----- Text theme (parameterised by ink colour) ------------------------
  static TextTheme _textTheme({required Color ink, required Color muted}) {
    return TextTheme(
      bodyLarge: sans(color: ink, fontSize: 16, height: 1.5),
      bodyMedium: sans(color: ink, fontSize: 14, height: 1.5),
      bodySmall: sans(
        color: muted,
        fontSize: 12.5,
        fontWeight: FontWeight.w500,
        height: 1.4,
      ),
      labelLarge: sans(
        color: ink,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.2,
      ),
      labelMedium: sans(
        color: ink,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.3,
      ),
      labelSmall: sans(
        color: ink,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.25,
        height: 1,
      ),
      headlineLarge: serif(color: ink, fontSize: 30, fontWeight: FontWeight.w600, height: 1.1),
      headlineMedium: serif(color: ink, fontSize: 24, fontWeight: FontWeight.w600, height: 1.15),
      headlineSmall: serif(
        color: ink,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: -0.005,
      ),
      titleLarge: serif(color: ink, fontSize: 22, fontWeight: FontWeight.w600, height: 1.2),
      titleMedium: serif(
        color: ink,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: -0.005,
      ),
      titleSmall: sans(
        color: ink,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.25,
      ),
    );
  }

  // ----- Shared component theming ----------------------------------------
  static ThemeData _build({
    required Brightness brightness,
    required JillaniPalette palette,
    required ColorScheme scheme,
  }) {
    final ink = palette.onSurface;
    final muted = palette.onSurfaceVariant;
    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: palette.surface,
      primaryColor: palette.primaryContainer,
      colorScheme: scheme,
      extensions: [palette],
      textTheme: _textTheme(ink: ink, muted: muted),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.surfaceContainerLow,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: serif(
          color: ink,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          height: 1.2,
        ),
        iconTheme: IconThemeData(color: palette.primaryContainer),
      ),
      cardTheme: CardThemeData(
        color: palette.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
          side: BorderSide(color: palette.outlineVariant, width: 1),
        ),
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: palette.surfaceContainer,
        labelStyle: sans(
          color: muted,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.35,
        ),
        hintStyle: sans(color: muted.withValues(alpha: 0.5)),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
          borderSide: BorderSide(color: palette.outlineVariant, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
          borderSide: BorderSide(color: palette.outlineVariant, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
          borderSide: BorderSide(color: palette.primaryContainer, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
          borderSide: BorderSide(color: scheme.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.primaryContainer,
          foregroundColor: palette.onPrimaryContainer,
          disabledBackgroundColor: palette.surfaceContainerHigh,
          disabledForegroundColor: muted.withValues(alpha: 0.5),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            letterSpacing: 0.16,
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.sm),
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ink,
          side: BorderSide(color: palette.outlineVariant, width: 1),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            letterSpacing: 0.12,
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.sm),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ink.withValues(alpha: 0.7),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 18),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.primaryContainer,
        foregroundColor: palette.onPrimaryContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: palette.surfaceContainerLow,
        selectedItemColor: palette.primaryContainer,
        unselectedItemColor: muted,
        selectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          fontSize: 10,
          letterSpacing: 0.4,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 10,
          letterSpacing: 0.2,
        ),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: palette.primaryContainer,
        unselectedLabelColor: muted,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: palette.primaryContainer, width: 3),
        ),
        labelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w700,
          fontSize: 12,
          letterSpacing: 1.0,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 12,
          letterSpacing: 1.0,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return palette.primaryContainer;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(palette.onPrimaryContainer),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
        ),
        side: BorderSide(color: muted),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.sm),
          side: BorderSide(color: palette.outlineVariant, width: 1),
        ),
        elevation: 0,
      ),
    );
  }

  static ThemeData get darkTheme => _build(
        brightness: Brightness.dark,
        palette: JillaniPalette.dark,
        scheme: const ColorScheme.dark(
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
      );

  static ThemeData get lightTheme => _build(
        brightness: Brightness.light,
        palette: JillaniPalette.light,
        scheme: const ColorScheme.light(
          primary: goldBrand,
          onPrimary: onGold,
          primaryContainer: goldBrand,
          onPrimaryContainer: onGold,
          secondary: surfaceLight,
          onSecondary: inkNavy,
          surface: surfaceLight,
          onSurface: inkNavy,
          error: errorLight,
          onError: Color(0xFFFFFFFF),
        ),
      );

  /// Backwards-compatible alias (used by widget tests). Dark = canonical.
  static ThemeData get themeData => darkTheme;

  // ----- Motion-aware navigation + sheets ---------------------------------
  static Route<T> route<T>(Widget page, {bool fullscreenDialog = false}) {
    return PageRouteBuilder<T>(
      fullscreenDialog: fullscreenDialog,
      transitionDuration: Motion.base,
      reverseTransitionDuration: Motion.fast,
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        final curved = CurvedAnimation(parent: animation, curve: Motion.ease);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.98, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  static Future<T?> luxeSheet<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isScrollControlled = false,
  }) {
    final palette = context.palette;
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: palette.surfaceContainerLow,
      barrierColor: const Color(0xFF08111F).withValues(alpha: 0.6),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      builder: (sheetContext) => _SheetGrabber(child: builder(sheetContext)),
    );
  }
}

class _SheetGrabber extends StatelessWidget {
  final Widget child;
  const _SheetGrabber({required this.child});

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 4,
          margin: const EdgeInsets.only(top: 10, bottom: 2),
          decoration: BoxDecoration(
            color: palette.outlineVariant,
            borderRadius: BorderRadius.circular(Radii.pill),
          ),
        ),
        Flexible(child: child),
      ],
    );
  }
}

// ----- Spacing / radius / motion tokens ----------------------------------
class Insets {
  static const double s4 = 4;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s32 = 32;
}

class Radii {
  static const double sm = 4; // inputs / buttons / small controls
  static const double md = 8; // cards
  static const double pill = 999; // chips / avatars
}

class Motion {
  static const Cubic ease = Cubic(0.16, 1, 0.3, 1); // --ease-luxe
  static const Duration fast = Duration(milliseconds: 120);
  static const Duration base = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 360);
}

// ----- Theme-aware palette -----------------------------------------------
@immutable
class JillaniPalette extends ThemeExtension<JillaniPalette> {
  final Color surface;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color onSurface;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color primary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color error;
  final Color divider;
  final Color hairline; // very subtle separators / card borders

  const JillaniPalette({
    required this.surface,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.onSurface,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.primary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.error,
    required this.divider,
    required this.hairline,
  });

  static const JillaniPalette dark = JillaniPalette(
    surface: DesignSystem.surface,
    surfaceContainerLow: DesignSystem.surfaceContainerLow,
    surfaceContainer: DesignSystem.surfaceContainer,
    surfaceContainerHigh: DesignSystem.surfaceContainerHigh,
    onSurface: DesignSystem.onSurface,
    onSurfaceVariant: DesignSystem.onSurfaceVariant,
    outline: DesignSystem.outline,
    outlineVariant: DesignSystem.outlineVariant,
    primary: DesignSystem.primary,
    primaryContainer: DesignSystem.primaryContainer,
    onPrimaryContainer: DesignSystem.onPrimaryContainer,
    error: DesignSystem.error,
    divider: Color(0x14FFFFFF), // white @ ~8%
    hairline: Color(0x0DFFFFFF), // white @ ~5%
  );

  static const JillaniPalette light = JillaniPalette(
    surface: DesignSystem.creamBg,
    surfaceContainerLow: DesignSystem.surfaceLight,
    surfaceContainer: DesignSystem.surfaceLight,
    surfaceContainerHigh: DesignSystem.surfaceAltLight,
    onSurface: DesignSystem.inkNavy,
    onSurfaceVariant: DesignSystem.fgMutedLight,
    outline: Color(0xFFC9CFDB),
    outlineVariant: DesignSystem.borderLight,
    primary: DesignSystem.goldBrand,
    primaryContainer: DesignSystem.goldBrand,
    onPrimaryContainer: DesignSystem.onGold,
    error: DesignSystem.errorLight,
    divider: DesignSystem.dividerLight,
    hairline: DesignSystem.borderLight,
  );

  @override
  JillaniPalette copyWith({
    Color? surface,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? onSurface,
    Color? onSurfaceVariant,
    Color? outline,
    Color? outlineVariant,
    Color? primary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? error,
    Color? divider,
    Color? hairline,
  }) {
    return JillaniPalette(
      surface: surface ?? this.surface,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      onSurface: onSurface ?? this.onSurface,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      primary: primary ?? this.primary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      error: error ?? this.error,
      divider: divider ?? this.divider,
      hairline: hairline ?? this.hairline,
    );
  }

  @override
  JillaniPalette lerp(ThemeExtension<JillaniPalette>? other, double t) {
    if (other is! JillaniPalette) return this;
    return JillaniPalette(
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceContainerLow:
          Color.lerp(surfaceContainerLow, other.surfaceContainerLow, t)!,
      surfaceContainer:
          Color.lerp(surfaceContainer, other.surfaceContainer, t)!,
      surfaceContainerHigh:
          Color.lerp(surfaceContainerHigh, other.surfaceContainerHigh, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      onSurfaceVariant:
          Color.lerp(onSurfaceVariant, other.onSurfaceVariant, t)!,
      outline: Color.lerp(outline, other.outline, t)!,
      outlineVariant: Color.lerp(outlineVariant, other.outlineVariant, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      primaryContainer:
          Color.lerp(primaryContainer, other.primaryContainer, t)!,
      onPrimaryContainer:
          Color.lerp(onPrimaryContainer, other.onPrimaryContainer, t)!,
      error: Color.lerp(error, other.error, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
    );
  }
}

extension JillaniPaletteX on BuildContext {
  JillaniPalette get palette =>
      Theme.of(this).extension<JillaniPalette>() ?? JillaniPalette.dark;
}
