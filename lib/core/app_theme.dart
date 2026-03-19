import 'package:flutter/material.dart';

class AppTheme {
  // Primary Palette
  static const Color primary = Color(0xFF4F46E5); // Indigo
  static const Color secondary = Color(0xFF22C55E); // Green
  static const Color accent = Color(0xFFF59E0B); // Orange
  static const Color background = Color(0xFFF8FAFC); // Light grey

  // Danger/Red Palette
  static const Color danger = Color(0xFFEF4444);

  // Surface & Text
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);

  // Gradients for Cards
  static const LinearGradient revenueGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF3B82F6)], // Purple to Blue
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient ordersGradient = LinearGradient(
    colors: [Color(0xFFF97316), Color(0xFFEAB308)], // Orange to Yellow
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient posActivityGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF14B8A6)], // Green to Teal
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cancelledGradient = LinearGradient(
    colors: [Color(0xFFF43F5E), Color(0xFFD946EF)], // Red to Pink
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      primaryColor: primary,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        secondary: secondary,
        error: danger,
        background: background,
        surface: surface,
      ),
      fontFamily: 'Inter',
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 32,
        ),
        headlineMedium: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        titleLarge: TextStyle(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        bodyLarge: TextStyle(color: textSecondary, fontSize: 16),
        bodyMedium: TextStyle(color: textSecondary, fontSize: 14),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 4,
        shadowColor: primary.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          elevation: 2,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        hintStyle: const TextStyle(color: textSecondary),
      ),
    );
  }
}
