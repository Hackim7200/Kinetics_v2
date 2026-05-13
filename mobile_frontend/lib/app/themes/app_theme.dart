import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ─── Kinetic Archive Color Palette ───
  static const Color _primary = Color(0xFF000000);
  static const Color _onPrimary = Color(0xFFE2E2E2);
  static const Color _primaryContainer = Color(0xFF3B3B3B);
  static const Color _onPrimaryContainer = Color(0xFFFFFFFF);

  static const Color _secondary = Color(0xFF5E5E5E);
  static const Color _onSecondary = Color(0xFFFFFFFF);
  static const Color _secondaryContainer = Color(0xFFD5D4D4);

  static const Color _tertiary = Color(0xFF3A3C3C);
  static const Color _onTertiary = Color(0xFFE2E2E2);
  static const Color _tertiaryContainer = Color(0xFF737575);

  static const Color _surface = Color(0xFFF9F9F9);
  static const Color _onSurface = Color(0xFF1A1C1C);
  static const Color _onSurfaceVariant = Color(0xFF474747);

  static const Color _surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color _surfaceContainerLow = Color(0xFFF3F3F3);
  static const Color _surfaceContainer = Color(0xFFEEEEEE);
  static const Color _surfaceContainerHigh = Color(0xFFE8E8E8);
  static const Color _surfaceContainerHighest = Color(0xFFE2E2E2);
  static const Color _surfaceDim = Color(0xFFDADADA);

  static const Color _outline = Color(0xFF777777);
  static const Color _outlineVariant = Color(0xFFC6C6C6);

  static const Color _error = Color(0xFFBA1A1A);
  static const Color _onError = Color(0xFFFFFFFF);
  static const Color _errorContainer = Color(0xFFFFDAD6);

  static const Color _inverseSurface = Color(0xFF2F3131);
  static const Color _inverseOnSurface = Color(0xFFF1F1F1);
  static const Color _inversePrimary = Color(0xFFC6C6C6);

  static const Color success = Color(0xFF2E7D32);

  // ─── Dark Mode Palette ───
  static const Color _darkPrimary = Color(0xFFE2E2E2);
  static const Color _darkOnPrimary = Color(0xFF1A1C1C);
  static const Color _darkPrimaryContainer = Color(0xFF3B3B3B);
  static const Color _darkOnPrimaryContainer = Color(0xFFE2E2E2);

  static const Color _darkSecondary = Color(0xFFACABAB);
  static const Color _darkOnSecondary = Color(0xFF1B1C1C);
  static const Color _darkSecondaryContainer = Color(0xFF3B3B3C);

  static const Color _darkTertiary = Color(0xFF9E9E9E);
  static const Color _darkOnTertiary = Color(0xFF1A1C1C);

  static const Color _darkSurface = Color(0xFF121212);
  static const Color _darkOnSurface = Color(0xFFE2E2E2);
  static const Color _darkOnSurfaceVariant = Color(0xFFACABAB);

  static const Color _darkSurfaceContainerLowest = Color(0xFF0A0A0A);
  static const Color _darkSurfaceContainerLow = Color(0xFF1A1A1A);
  static const Color _darkSurfaceContainer = Color(0xFF222222);
  static const Color _darkSurfaceContainerHigh = Color(0xFF2C2C2C);
  static const Color _darkSurfaceContainerHighest = Color(0xFF363636);
  static const Color _darkSurfaceDim = Color(0xFF0E0E0E);

  static const Color _darkOutline = Color(0xFF777777);
  static const Color _darkOutlineVariant = Color(0xFF474747);

  static const Color _darkInverseSurface = Color(0xFFE2E2E2);
  static const Color _darkInverseOnSurface = Color(0xFF1A1C1C);

  static TextTheme _buildTextTheme(Color onSurface, Color onSurfaceVariant) {
    return TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.04 * 57,
        color: onSurface,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.04 * 45,
        color: onSurface,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.04 * 36,
        color: onSurface,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.02 * 32,
        color: onSurface,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.05 * 28,
        color: onSurface,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        color: onSurface,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.02 * 22,
        color: onSurface,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: onSurface,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: onSurfaceVariant,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: onSurface,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: onSurface,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: onSurfaceVariant,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.4,
        color: onSurface,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: onSurfaceVariant,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 2.0,
        color: onSurfaceVariant,
      ),
    );
  }

  static ThemeData get light {
    final textTheme = _buildTextTheme(_onSurface, _onSurfaceVariant);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      textTheme: textTheme,
      colorScheme: const ColorScheme.light(
        primary: _primary,
        onPrimary: _onPrimary,
        primaryContainer: _primaryContainer,
        onPrimaryContainer: _onPrimaryContainer,
        secondary: _secondary,
        onSecondary: _onSecondary,
        secondaryContainer: _secondaryContainer,
        tertiary: _tertiary,
        onTertiary: _onTertiary,
        tertiaryContainer: _tertiaryContainer,
        surface: _surface,
        onSurface: _onSurface,
        onSurfaceVariant: _onSurfaceVariant,
        surfaceContainerLowest: _surfaceContainerLowest,
        surfaceContainerLow: _surfaceContainerLow,
        surfaceContainer: _surfaceContainer,
        surfaceContainerHigh: _surfaceContainerHigh,
        surfaceContainerHighest: _surfaceContainerHighest,
        surfaceDim: _surfaceDim,
        outline: _outline,
        outlineVariant: _outlineVariant,
        error: _error,
        onError: _onError,
        errorContainer: _errorContainer,
        inverseSurface: _inverseSurface,
        onInverseSurface: _inverseOnSurface,
        inversePrimary: _inversePrimary,
      ),
      scaffoldBackgroundColor: _surface,
      appBarTheme: AppBarTheme(
        backgroundColor: _surface.withValues(alpha: 0.8),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          color: _primary,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white.withValues(alpha: 0.8),
        selectedItemColor: _primary,
        unselectedItemColor: _outline,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: _onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 3.0,
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: _outline),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: _primary, width: 2),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 2.0,
          color: _tertiary,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: _outlineVariant,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: _surfaceContainerHighest,
        thickness: 1,
        space: 0,
      ),
    );
  }

  static ThemeData get dark {
    final textTheme = _buildTextTheme(_darkOnSurface, _darkOnSurfaceVariant);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      textTheme: textTheme,
      colorScheme: const ColorScheme.dark(
        primary: _darkPrimary,
        onPrimary: _darkOnPrimary,
        primaryContainer: _darkPrimaryContainer,
        onPrimaryContainer: _darkOnPrimaryContainer,
        secondary: _darkSecondary,
        onSecondary: _darkOnSecondary,
        secondaryContainer: _darkSecondaryContainer,
        tertiary: _darkTertiary,
        onTertiary: _darkOnTertiary,
        surface: _darkSurface,
        onSurface: _darkOnSurface,
        onSurfaceVariant: _darkOnSurfaceVariant,
        surfaceContainerLowest: _darkSurfaceContainerLowest,
        surfaceContainerLow: _darkSurfaceContainerLow,
        surfaceContainer: _darkSurfaceContainer,
        surfaceContainerHigh: _darkSurfaceContainerHigh,
        surfaceContainerHighest: _darkSurfaceContainerHighest,
        surfaceDim: _darkSurfaceDim,
        outline: _darkOutline,
        outlineVariant: _darkOutlineVariant,
        error: _error,
        onError: _onError,
        errorContainer: _errorContainer,
        inverseSurface: _darkInverseSurface,
        onInverseSurface: _darkInverseOnSurface,
        inversePrimary: _inversePrimary,
      ),
      scaffoldBackgroundColor: _darkSurface,
      appBarTheme: AppBarTheme(
        backgroundColor: _darkSurface.withValues(alpha: 0.8),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
          color: _darkOnSurface,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _darkSurface.withValues(alpha: 0.8),
        selectedItemColor: _darkPrimary,
        unselectedItemColor: _darkOutline,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPrimary,
          foregroundColor: _darkOnPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 3.0,
          ),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: _darkOutline),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: _darkPrimary, width: 2),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 2.0,
          color: _darkTertiary,
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: _darkOutlineVariant,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: _darkSurfaceContainerHighest,
        thickness: 1,
        space: 0,
      ),
    );
  }
}
