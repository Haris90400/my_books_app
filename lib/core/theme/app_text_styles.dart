import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static TextStyle _poppins({
    required double fontSize,
    required FontWeight fontWeight,
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  /// Setup required properties.
  static TextStyle get headlineLarge =>
      _poppins(fontSize: 32, fontWeight: FontWeight.w700);

  /// Setup required properties.
  static TextStyle get headlineMedium =>
      _poppins(fontSize: 24, fontWeight: FontWeight.w700);

  /// Setup required properties.
  static TextStyle get titleLarge =>
      _poppins(fontSize: 18, fontWeight: FontWeight.w500);

  /// Setup required properties.
  static TextStyle get titleMedium =>
      _poppins(fontSize: 16, fontWeight: FontWeight.w500);

  /// Setup required properties.
  static TextStyle get bodyMedium =>
      _poppins(fontSize: 14, fontWeight: FontWeight.w400);

  /// Setup required properties.
  static TextStyle get bodySmall =>
      _poppins(fontSize: 12, fontWeight: FontWeight.w400);

  /// Setup required properties.
  static TextStyle get labelSmall =>
      _poppins(fontSize: 11, fontWeight: FontWeight.w500);
}
