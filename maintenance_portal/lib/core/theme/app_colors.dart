import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors (SAP/Fiori inspired)
  static const Color sapBlue = Color(0xFF0056D2);
  static const Color sapGold = Color(0xFFE4AA18);
  static const Color sapLightBlue = Color(0xFF0A6ED1);
  
  // Industrial Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0056D2), Color(0xFF0089FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A1C1E), Color(0xFF2C2F33)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Background Colors
  static const Color lightBg = Color(0xFFF4F7FC);
  static const Color darkBg = Color(0xFF0F1115);
  static const Color darkSurface = Color(0xFF1A1C1E);

  // Card Colors
  static const Color cardLight = Colors.white;
  static const Color cardDark = Color(0xFF23262B);

  // Status Colors
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF1C40F);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF3498DB);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF1D1D1F);
  static const Color textSecondaryLight = Color(0xFF6E6E73);
  static const Color textPrimaryDark = Color(0xFFE5E5E7);
  static const Color textSecondaryDark = Color(0xFFA1A1A6);

  // Glassmorphism
  static Color glassWhite = Colors.white.withOpacity(0.15);
  static Color glassBlack = Colors.black.withOpacity(0.3);
}
