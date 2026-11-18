import 'package:flutter/material.dart';

/// Captain Sports Theme Configuration
/// Matches the exact color guidelines:
/// - Primary: Red
/// - Accent: Red
/// - Dark: Black
/// - Card: Black
/// - Background: Light Grey
class AppTheme {
  // Theme Color Palette
  static const Color primaryRed = Color(0xFFD32F2F); // Athletic Primary Red
  static const Color primaryRedDark = Color(0xFF9A0007); // Deep Red
  static const Color accentRed = Color(0xFFFF5252); // Energetic Bright Red Accent
  static const Color accentRedLight = Color(0xFFFF867F);

  static const Color darkBlack = Color(0xFF0D0D11); // Deepest Black for AppBars & text
  static const Color cardBlack = Color(0xFF18181C); // Sleek Black Card Surface
  static const Color cardBlackHover = Color(0xFF222228); // Elevated Card Surface
  static const Color borderSubtleRed = Color(0x33D32F2F); // Subtle Red card border

  static const Color backgroundLightGrey = Color(0xFFF3F4F7); // Screen Canvas Background
  static const Color surfaceLightGrey = Color(0xFFE5E7EB); // Dividers & Search Bar
  static const Color textMutedGrey = Color(0xFF9E9EA7); // Card Subtitles
  static const Color textDark = Color(0xFF1F2937); // Text on light grey canvas
  static const Color textWhite = Color(0xFFFFFFFF); // Text on black cards

  // Status Colors
  static const Color statusSuccess = Color(0xFF10B981); // In Stock
  static const Color statusWarning = Color(0xFFF59E0B); // Low Stock (warning)
  static const Color statusDanger = Color(0xFFEF4444); // Critical Out of Stock

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryRed,
      scaffoldBackgroundColor: backgroundLightGrey,
      fontFamily: 'Segoe UI',
      
      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: primaryRed,
        secondary: accentRed,
        surface: backgroundLightGrey,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textDark,
        error: accentRed,
      ),

      // App Bar Theme (Dark Black header with red accent)
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBlack,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: accentRed),
      ),

      // Card Theme (Black Card on Light Grey Background)
      cardTheme: CardThemeData(
        color: cardBlack,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderSubtleRed, width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      ),

      // Elevated Button (Primary Red)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryRed,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // Outlined Button (Red Border)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryRed,
          side: const BorderSide(color: primaryRed, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration (Modern dark-friendly forms inside black cards or light inputs)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF222228),
        labelStyle: const TextStyle(color: textMutedGrey, fontSize: 14),
        hintStyle: const TextStyle(color: Color(0xFF6B7280), fontSize: 14),
        prefixIconColor: accentRed,
        suffixIconColor: textMutedGrey,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentRed, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: statusDanger, width: 1.5),
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: CircleBorder(),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkBlack,
        selectedItemColor: accentRed,
        unselectedItemColor: textMutedGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        selectedColor: primaryRed,
        labelStyle: const TextStyle(color: textDark, fontWeight: FontWeight.w500),
        secondaryLabelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
      ),
    );
  }
}
