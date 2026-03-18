import 'package:flutter/material.dart';

/// App Theme Constants for Ramadan-themed Muslim App
class AppColors {
  // Primary Colors
  static const Color primaryGreen = Color(0xFF0D5C46); // Deep Islamic Green
  static const Color secondaryWhite = Color(0xFFFFFFFF);
  static const Color accentGold = Color(
    0xFFFFB800,
  ); // Gold/Amber for indicators

  // Additional Colors
  static const Color darkGreen = Color(0xFF073D30);
  static const Color lightGreen = Color(0xFF1A8F6E);
  static const Color cardBackground = Color(0xFFF5F5F5);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color divider = Color(0xFFE0E0E0);

  // Gradient Colors
  static const List<Color> headerGradient = [
    Color(0xFF0D5C46),
    Color(0xFF1A8F6E),
  ];

  static const List<Color> prayerCardGradient = [
    Color(0xFF0D5C46),
    Color(0xFF0A4A38),
  ];
}

class AppDimensions {
  // Border Radius
  static const double borderRadiusSmall = 12.0;
  static const double borderRadiusMedium = 20.0;
  static const double borderRadiusLarge = 30.0;

  // Padding
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  // Card Elevation
  static const double elevationSoft = 2.0;
  static const double elevationMedium = 4.0;
}
