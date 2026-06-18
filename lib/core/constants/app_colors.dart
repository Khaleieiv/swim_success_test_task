import 'package:flutter/material.dart';

abstract final class AppColors {
  // Dark Theme Colors
  static const darkBackground = Color(0xFF0D1117);
  static const darkSurface = Color(0xFF161B22);
  static const darkAccent = Color(0xFF00B4D8);
  static const darkTextPrimary = Color(0xFFE6EDF3);
  static const darkTextSecondary = Color(0xFF8B949E);

  // Light Theme Colors
  static const lightBackground = Color(0xFFF6F8FA);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightAccent = Color(0xFF0077B6);
  static const lightTextPrimary = Color(0xFF1F2328);
  static const lightTextSecondary = Color(0xFF57606A);

  // Swimmer Levels Colors
  static const levelElite = Color(0xFFFF453A);
  static const levelAdvanced = Color(0xFFFF9F0A);
  static const levelIntermediate = Color(0xFF64D2FF);
  static const levelBeginner = Color(0xFF30D158);

  // Border Colors
  static const darkBorder = Color(0xFF30363D);
  static const lightBorder = Color(0xFFD0D7DE);

  // Inactive Track Colors
  static const darkInactiveTrack = Color(0xFF21262D);
  static const lightInactiveTrack = Color(0xFFD0D7DE);

  // Overlay Colors
  static const darkOverlay = Color(0x2900B4D8);
  static const lightOverlay = Color(0x290077B6);

  // Progress Bar Colors
  static const darkProgressActive = Color(0xFF30D158);
  static const lightProgressActive = Color(0xFF2EA44F);

  // Status Notifications Colors
  static const errorStatus = Color(0xFFFF453A);
  static const successStatus = Color(0xFF2EA44F);
}
