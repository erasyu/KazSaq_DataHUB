import 'package:flutter/material.dart';

class AppColors {
  // Строгая профессиональная палитра
  static const Color primary = Color(0xFF1A1A1A);
  static const Color primaryDark = Color(0xFF000000);
  static const Color primaryLight = Color(0xFF2D2D2D);
  static const Color secondary = Color(0xFF1A1A1A);
  static const Color accent = Color(0xFF1A1A1A);
  
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFFF5F5F5);
  
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF999999);
  
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFE65100);
  static const Color error = Color(0xFFC62828);
  static const Color info = Color(0xFF1A1A1A);
  
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shadow = Color(0x0D000000);
  
  static const Gradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );
  
  static const Gradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );
}

