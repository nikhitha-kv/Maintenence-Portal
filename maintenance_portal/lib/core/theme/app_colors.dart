import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors (Premium Industrial)
  static const Color primary = Color(0xFF6B4EE6); // Deep Purple
  static const Color secondary = Color(0xFFFF8C00); // Sunset Orange
  static const Color accent = Color(0xFFE64EAB); // Vibrant Magenta
  
  // Industrial Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6B4EE6), Color(0xFF9B4EE6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFF8C00), Color(0xFFFF4500)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0D0D12), Color(0xFF1A1A24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Background Colors
  static const Color lightBg = Color(0xFFF8F9FE);
  static const Color darkBg = Color(0xFF0D0D12);
  static const Color darkSurface = Color(0xFF14141B);

  // Card Colors
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF1C1C26);

  // Status Colors
  static const Color success = Color(0xFF00C853);
  static const Color warning = Color(0xFFFFAB00);
  static const Color error = Color(0xFFFF1744);
  static const Color info = Color(0xFF00B0FF); // Cyan/Light Blue - replacing with Tealish Cyan if needed, or keeping for standard info

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF1D1D21);
  static const Color textSecondaryLight = Color(0xFF6B6B75);
  static const Color textPrimaryDark = Color(0xFFF2F2F7);
  static const Color textSecondaryDark = Color(0xFF9898A1);

  // Glassmorphism
  static Color glassWhite = Colors.white.withOpacity(0.12);
  static Color glassBlack = Colors.black.withOpacity(0.25);
}
